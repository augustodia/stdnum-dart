// ignore_for_file: camel_case_types

import 'package:stdnum_dart/src/exceptions.dart';
import 'package:stdnum_dart/src/helpers/utils.dart';
import 'package:stdnum_dart/src/interfaces/document_interface.dart';

class CL_RUT implements DocumentInterface {
  static const String _checkDigits = '0123456789K';
  static const List<int> _weights = [9, 8, 7, 6, 5, 4, 9, 8, 7];

  int _weightedSum(String front, int modulus) {
    final reversedDigits =
        front.split('').reversed.map((digit) => int.parse(digit)).toList();

    var sum = 0;
    for (var index = 0; index < reversedDigits.length; index++) {
      var weighted = reversedDigits[index] * _weights[index % _weights.length];
      while (weighted < 0) {
        weighted += modulus;
      }
      sum = (sum + weighted) % modulus;
    }

    return sum;
  }

  @override
  String compact(String rut) {
    final clearedRUT = rut.replaceAll(RegExp(r'[ -]'), '').toUpperCase();
    if (clearedRUT.startsWith('CL')) {
      return clearedRUT.substring(2);
    }
    return clearedRUT;
  }

  @override
  String format(String rut) {
    final clearedRUT = compact(rut);
    if (clearedRUT.length != 8 && clearedRUT.length != 9) {
      throw InvalidLength();
    }

    final a = clearedRUT.substring(0, clearedRUT.length - 7);
    final b = clearedRUT.substring(
      clearedRUT.length - 7,
      clearedRUT.length - 4,
    );
    final c = clearedRUT.substring(
      clearedRUT.length - 4,
      clearedRUT.length - 1,
    );
    final d = clearedRUT.substring(clearedRUT.length - 1);

    return '$a.$b.$c-$d';
  }

  @override
  String validate(String rut) {
    final clearedRUT = compact(rut);
    if (clearedRUT.length != 8 && clearedRUT.length != 9) {
      throw InvalidLength();
    }

    final front = clearedRUT.substring(0, clearedRUT.length - 1);
    final check = clearedRUT.substring(clearedRUT.length - 1);

    if (!StdnumDartUtils.isOnlyDigits(front)) {
      throw InvalidComponent();
    }

    final sum = _weightedSum(front, 11);
    final expectedDigit = _checkDigits[sum];
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
