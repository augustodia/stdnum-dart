// ignore_for_file: camel_case_types

import 'package:stdnum_dart/src/exceptions.dart';
import 'package:stdnum_dart/src/helpers/utils.dart';
import 'package:stdnum_dart/src/interfaces/document_interface.dart';

class ES_DNI implements DocumentInterface {
  static const String _checkDigits = 'TRWAGMYFPDXBNJZSQVHLCKE';

  static String calcCheckDigit(String value) {
    final end = value.length < 8 ? value.length : 8;
    final digits = RegExp(r'^\d+').stringMatch(value.substring(0, end));
    return _checkDigits[int.parse(digits!) % 23];
  }

  @override
  String compact(String dni) {
    return dni.replaceAll(RegExp(r'[ -]'), '').toUpperCase();
  }

  @override
  String format(String dni) {
    final clearedDNI = compact(dni);
    if (clearedDNI.length != 9) {
      throw InvalidLength();
    }

    return '${clearedDNI.substring(0, 8)}-${clearedDNI.substring(8, 9)}';
  }

  @override
  String validate(String dni) {
    final clearedDNI = compact(dni);
    if (clearedDNI.length != 9) {
      throw InvalidLength();
    }

    final body = clearedDNI.substring(0, 8);
    final check = clearedDNI.substring(8, 9);

    if ('KLM'.contains(body[0]) &&
        StdnumDartUtils.isOnlyDigits(body.substring(1))) {
      return dni;
    }
    if (!StdnumDartUtils.isOnlyDigits(body)) {
      throw InvalidComponent();
    }
    if (calcCheckDigit(body) != check) {
      throw InvalidChecksum();
    }

    return dni;
  }

  @override
  bool isValid(String dni) {
    try {
      validate(dni);
      return true;
    } catch (e) {
      return false;
    }
  }
}
