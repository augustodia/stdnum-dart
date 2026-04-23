// ignore_for_file: camel_case_types

import 'package:stdnum_dart/src/countries/es/dni.dart';
import 'package:stdnum_dart/src/exceptions.dart';
import 'package:stdnum_dart/src/helpers/utils.dart';
import 'package:stdnum_dart/src/interfaces/document_interface.dart';

class ES_NIF implements DocumentInterface {
  static const String _niePrefixes = 'XYZ';
  static const String _cifEntityTypes = 'ABCDEFGHJNPQRSUVW';
  static const String _cifLetterCheckDigits = 'JABCDEFGHI';

  String _clean(String nif) {
    final clearedNIF = nif.replaceAll(RegExp(r'[ -./]'), '').toUpperCase();
    if (clearedNIF.startsWith('ES')) {
      return clearedNIF.substring(2);
    }
    return clearedNIF;
  }

  int _luhnChecksumValue(String value) {
    final digits = value.split('').reversed.map((d) => int.parse(d)).toList();

    var sum = 0;
    for (var index = 0; index < digits.length; index++) {
      final digit = digits[index];
      if (index.isEven) {
        sum = (sum + digit) % 10;
      } else {
        final doubled = digit * 2;
        sum = (sum + (doubled ~/ 10) + (doubled % 10)) % 10;
      }
    }

    return sum;
  }

  String _luhnChecksumDigit(String value) {
    final checksum = _luhnChecksumValue('${value}0');
    return '${(10 - checksum) % 10}';
  }

  void _validateNIE(String value) {
    final first = value.substring(0, 1);
    final body = value.substring(1, 8);
    final check = value.substring(8, 9);

    if (!StdnumDartUtils.isOnlyDigits(body) ||
        !_niePrefixes.contains(first) ||
        StdnumDartUtils.isOnlyDigits(check)) {
      throw InvalidComponent();
    }

    final dniBody = '${_niePrefixes.indexOf(first)}$body';
    if (ES_DNI.calcCheckDigit(dniBody) != check) {
      throw InvalidChecksum();
    }
  }

  void _validateCIF(String value) {
    final first = value.substring(0, 1);
    final body = value.substring(1, 8);
    final check = value.substring(8, 9);

    if (!StdnumDartUtils.isOnlyDigits(body) ||
        !_cifEntityTypes.contains(first) ||
        !(StdnumDartUtils.isOnlyDigits(check) ||
            _cifLetterCheckDigits.contains(check))) {
      throw InvalidComponent();
    }

    final checksum = int.parse(_luhnChecksumDigit(body));
    final possibleCheckDigits = '${_cifLetterCheckDigits[checksum]}$checksum';
    if (!possibleCheckDigits.contains(check)) {
      throw InvalidChecksum();
    }
  }

  @override
  String compact(String nif) {
    return _clean(nif);
  }

  @override
  String format(String nif) {
    final clearedNIF = compact(nif);
    if (clearedNIF.length != 9) {
      throw InvalidLength();
    }

    return '${clearedNIF.substring(0, 1)}-${clearedNIF.substring(1)}';
  }

  @override
  String validate(String nif) {
    final clearedNIF = compact(nif);
    if (clearedNIF.length != 9) {
      throw InvalidLength();
    }

    if ('KLM'.contains(clearedNIF[0])) {
      if (clearedNIF[8] != ES_DNI.calcCheckDigit(clearedNIF.substring(1))) {
        throw InvalidChecksum();
      }
      return nif;
    }

    if (StdnumDartUtils.isOnlyDigits(clearedNIF[0])) {
      ES_DNI().validate(clearedNIF);
      return nif;
    }

    if (_niePrefixes.contains(clearedNIF[0])) {
      _validateNIE(clearedNIF);
      return nif;
    }

    _validateCIF(clearedNIF);
    return nif;
  }

  @override
  bool isValid(String nif) {
    try {
      validate(nif);
      return true;
    } catch (e) {
      return false;
    }
  }
}
