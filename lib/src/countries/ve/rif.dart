// ignore_for_file: camel_case_types

import 'package:stdnum_dart/src/exceptions.dart';
import 'package:stdnum_dart/src/helpers/utils.dart';
import 'package:stdnum_dart/src/interfaces/document_interface.dart';

class VE_RIF implements DocumentInterface {
  static const Map<String, int> _companyTypes = {
    'V': 4,
    'E': 8,
    'J': 12,
    'P': 16,
    'G': 20,
  };

  static const List<int> _weights = [3, 2, 7, 6, 5, 4, 3, 2];

  int _weightedSum(String body) {
    var sum = 0;
    for (var index = 0; index < body.length; index++) {
      sum = (sum + int.parse(body[index]) * _weights[index]) % 11;
    }
    return sum;
  }

  @override
  String compact(String rif) {
    return rif.replaceAll(RegExp(r'[ -]'), '').toUpperCase();
  }

  @override
  String format(String rif) {
    final clearedRIF = compact(rif);
    if (clearedRIF.length != 10) {
      throw InvalidLength();
    }

    return '${clearedRIF.substring(0, 1)}-${clearedRIF.substring(1, 9)}-${clearedRIF.substring(9, 10)}';
  }

  @override
  String validate(String rif) {
    final clearedRIF = compact(rif);
    if (clearedRIF.length != 10) {
      throw InvalidLength();
    }
    if (!StdnumDartUtils.isOnlyDigits(clearedRIF.substring(1))) {
      throw InvalidFormat();
    }

    final type = clearedRIF.substring(0, 1);
    final body = clearedRIF.substring(1, 9);
    final check = clearedRIF.substring(9, 10);
    final first = _companyTypes[type];

    if (first == null) {
      throw InvalidComponent();
    }

    final digit = (first + _weightedSum(body)) % 11;
    if ('00987654321'[digit] != check) {
      throw InvalidChecksum();
    }

    return rif;
  }

  @override
  bool isValid(String rif) {
    try {
      validate(rif);
      return true;
    } catch (e) {
      return false;
    }
  }
}
