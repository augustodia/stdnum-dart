// ignore_for_file: camel_case_types

import 'package:stdnum_dart/src/exceptions.dart';
import 'package:stdnum_dart/src/helpers/utils.dart';
import 'package:stdnum_dart/src/interfaces/document_interface.dart';

class PT_NIF implements DocumentInterface {
  static const List<int> _weights = [9, 8, 7, 6, 5, 4, 3, 2, 1];

  int _weightedSum(String front) {
    var sum = 0;
    for (var index = 0; index < front.length; index++) {
      sum = (sum + int.parse(front[index]) * _weights[index]) % 11;
    }
    return sum;
  }

  @override
  String compact(String nif) {
    final compacted = nif.replaceAll(RegExp(r'[ -.]+'), '').toUpperCase();
    if (compacted.startsWith('PT')) {
      return compacted.substring(2);
    }
    return compacted;
  }

  @override
  String format(String nif) {
    final clearedNIF = compact(nif);
    if (clearedNIF.length != 9) {
      throw InvalidLength();
    }

    return '${clearedNIF.substring(0, 3)} ${clearedNIF.substring(3, 6)} ${clearedNIF.substring(6, 9)}';
  }

  @override
  String validate(String nif) {
    final clearedNIF = compact(nif);
    if (clearedNIF.length != 9) {
      throw InvalidLength();
    }
    if (!StdnumDartUtils.isOnlyDigits(clearedNIF) || clearedNIF[0] == '0') {
      throw InvalidFormat();
    }

    final front = clearedNIF.substring(0, 8);
    final check = clearedNIF.substring(8, 9);
    final expectedDigit = '${(11 - _weightedSum(front)) % 11 % 10}';

    if (check != expectedDigit) {
      throw InvalidChecksum();
    }

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
