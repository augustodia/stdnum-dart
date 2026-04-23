// ignore_for_file: camel_case_types

import 'package:stdnum_dart/src/exceptions.dart';
import 'package:stdnum_dart/src/helpers/utils.dart';
import 'package:stdnum_dart/src/interfaces/document_interface.dart';

class UY_RUT implements DocumentInterface {
  static const List<int> _weights = [4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];

  String _clean(String rut) {
    final clearedRUT = rut.replaceAll(RegExp(r'[ -]'), '').toUpperCase();
    if (clearedRUT.startsWith('UY')) {
      return clearedRUT.substring(2);
    }
    return clearedRUT;
  }

  int _weightedSum(String front) {
    var sum = 0;
    for (var index = 0; index < front.length; index++) {
      sum = (sum + int.parse(front[index]) * _weights[index]) % 11;
    }
    return sum;
  }

  @override
  String compact(String rut) {
    return _clean(rut);
  }

  @override
  String format(String rut) {
    final clearedRUT = compact(rut);
    if (clearedRUT.length != 12) {
      throw InvalidLength();
    }

    return '${clearedRUT.substring(0, 2)}-${clearedRUT.substring(2, 8)}-${clearedRUT.substring(8, 11)}-${clearedRUT.substring(11, 12)}';
  }

  @override
  String validate(String rut) {
    final clearedRUT = compact(rut);
    if (clearedRUT.length != 12) {
      throw InvalidLength();
    }
    if (!StdnumDartUtils.isOnlyDigits(clearedRUT)) {
      throw InvalidFormat();
    }

    final registrationNumber = int.parse(clearedRUT.substring(0, 2));
    if (registrationNumber == 0 || registrationNumber > 21) {
      throw InvalidComponent();
    }
    if (clearedRUT.substring(2, 8) == '000000') {
      throw InvalidComponent();
    }
    if (clearedRUT.substring(8, 11) != '001') {
      throw InvalidComponent();
    }

    final front = clearedRUT.substring(0, 11);
    final check = clearedRUT.substring(11, 12);
    final expectedDigit = '${(-_weightedSum(front)) % 11}';

    if (check != expectedDigit) {
      throw InvalidChecksum();
    }

    return rut;
  }

  @override
  bool isValid(String rut) {
    try {
      validate(rut);
      return true;
    } catch (e) {
      return false;
    }
  }
}
