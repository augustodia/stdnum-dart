// ignore_for_file: camel_case_types

import 'package:stdnum_dart/src/exceptions.dart';
import 'package:stdnum_dart/src/interfaces/document_interface.dart';

class MX_RFC implements DocumentInterface {
  static const Set<String> _nameBlacklist = {
    'BUEI',
    'BUEY',
    'CACA',
    'CACO',
    'CAGA',
    'CAGO',
    'CAKA',
    'CAKO',
    'COGE',
    'COJA',
    'COJE',
    'COJI',
    'COJO',
    'CULO',
    'FETO',
    'GUEY',
    'JOTO',
    'KACA',
    'KACO',
    'KAGA',
    'KAGO',
    'KAKA',
    'KOGE',
    'KOJO',
    'KULO',
    'MAME',
    'MAMO',
    'MEAR',
    'MEAS',
    'MEON',
    'MION',
    'MOCO',
    'MULA',
    'PEDA',
    'PEDO',
    'PENE',
    'PUTA',
    'PUTO',
    'QULO',
    'RATA',
    'RUIN',
  };

  static const String _checkAlphabet =
      '0123456789ABCDEFGHIJKLMN&OPQRSTUVWXYZ Ñ';
  static const String _checkAlphabetLegacy =
      '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ ';
  static const List<int> _weights = [
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
  ];

  @override
  String compact(String rfc) {
    return rfc.replaceAll(RegExp(r'[-_\s]'), '').toUpperCase();
  }

  @override
  String format(String rfc) {
    final clearedRFC = compact(rfc);

    if (clearedRFC.length == 12) {
      return '${clearedRFC.substring(0, 3)} ${clearedRFC.substring(3, 9)} ${clearedRFC.substring(9, 12)}';
    }
    if (clearedRFC.length == 13) {
      return '${clearedRFC.substring(0, 4)} ${clearedRFC.substring(4, 10)} ${clearedRFC.substring(10, 13)}';
    }
    if (clearedRFC.length == 10) {
      return '${clearedRFC.substring(0, 4)} ${clearedRFC.substring(4, 10)}';
    }
    throw InvalidLength();
  }

  bool _isValidDateCompactYYMMDD(String value, {bool isBefore = false}) {
    if (!RegExp(r'^\d{6}$').hasMatch(value)) return false;

    final year = int.parse(value.substring(0, 2));
    final month = int.parse(value.substring(2, 4));
    final day = int.parse(value.substring(4, 6));

    final fullYear = year < 20 ? 2000 + year : 1900 + year;
    final date = DateTime(fullYear, month, day);

    final isValidDate =
        date.year == fullYear && date.month == month && date.day == day;
    if (!isValidDate) return false;

    if (isBefore) {
      final now = DateTime.now();
      if (date.isAfter(now)) return false;
    }

    return true;
  }

  int _weightedSum(String value, String alphabet, int modulus) {
    final chars = value.split('').reversed.toList();

    var sum = 0;
    for (var index = 0; index < chars.length; index++) {
      final mapped = alphabet.indexOf(chars[index]);
      var weighted = mapped * _weights[index % _weights.length];

      while (weighted < 0) {
        weighted += modulus;
      }

      sum = (sum + weighted) % modulus;
    }
    return sum;
  }

  String _calculateChecksum(String value, String alphabet) {
    final sum = _weightedSum(value, alphabet, 11);
    final mod = 11 - (sum % 11);
    if (mod == 11) return '0';
    if (mod == 10) return 'A';
    return '$mod';
  }

  @override
  String validate(String rfc) {
    final clearedRFC = compact(rfc);

    if (clearedRFC.length == 10 || clearedRFC.length == 13) {
      if (!RegExp(r'^[A-Z&Ñ]{4}[0-9]{6}([0-9A-Z]{3})?$').hasMatch(clearedRFC)) {
        throw InvalidComponent();
      }

      if (_nameBlacklist.contains(clearedRFC.substring(0, 4))) {
        throw InvalidComponent();
      }

      if (!_isValidDateCompactYYMMDD(
        clearedRFC.substring(4, 10),
        isBefore: true,
      )) {
        throw InvalidComponent();
      }
    } else if (clearedRFC.length == 12) {
      if (!RegExp(r'^[A-Z&Ñ]{3}[0-9]{6}[0-9A-Z]{3}$').hasMatch(clearedRFC)) {
        throw InvalidComponent();
      }

      if (!_isValidDateCompactYYMMDD(clearedRFC.substring(3, 9))) {
        throw InvalidComponent();
      }
    } else {
      throw InvalidLength();
    }

    if (clearedRFC.length >= 12) {
      if (!RegExp(r'[1-9A-V][1-9A-Z][0-9A]$').hasMatch(clearedRFC)) {
        throw InvalidComponent();
      }

      final front = clearedRFC.substring(0, clearedRFC.length - 1);
      final check = clearedRFC.substring(clearedRFC.length - 1);
      final paddedInput = front.padLeft(12, ' ');

      final officialChecksum = _calculateChecksum(paddedInput, _checkAlphabet);
      if (check != officialChecksum) {
        final legacyChecksum = _calculateChecksum(
          paddedInput,
          _checkAlphabetLegacy,
        );
        if (check != legacyChecksum) {
          throw InvalidChecksum();
        }
      }
    }

    return rfc;
  }

  @override
  bool isValid(String rfc) {
    try {
      validate(rfc);
      return true;
    } catch (e) {
      return false;
    }
  }
}
