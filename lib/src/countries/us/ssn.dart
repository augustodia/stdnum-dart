// ignore_for_file: camel_case_types

import 'package:stdnum_dart/src/exceptions.dart';
import 'package:stdnum_dart/src/helpers/utils.dart';
import 'package:stdnum_dart/src/interfaces/document_interface.dart';

class US_SSN implements DocumentInterface {
  static const Set<String> _invalidSSNs = {
    '111111111',
    '222222222',
    '333333333',
    '444444444',
    '555555555',
    '777777777',
    '888888888',
    '999999999',
    '123123123',
    '002281852',
    '042103580',
    '062360749',
    '078051120',
    '095073645',
    '128036045',
    '135016629',
    '141186941',
    '165167999',
    '165187999',
    '165207999',
    '165227999',
    '165247999',
    '189092294',
    '212097694',
    '212099999',
    '219099999',
    '306302348',
    '308125070',
    '457555462',
    '468288779',
    '549241889',
  };

  @override
  String compact(String ssn) {
    return ssn.replaceAll(RegExp(r'[- ]'), '');
  }

  @override
  String format(String ssn) {
    final clearedSSN = compact(ssn);
    if (clearedSSN.length != 9) {
      throw InvalidLength();
    }

    return '${clearedSSN.substring(0, 3)}-${clearedSSN.substring(3, 5)}-${clearedSSN.substring(5)}';
  }

  @override
  String validate(String ssn) {
    final clearedSSN = compact(ssn);
    if (clearedSSN.length != 9) {
      throw InvalidLength();
    }
    if (!StdnumDartUtils.isOnlyDigits(clearedSSN)) {
      throw InvalidComponent();
    }
    if (_invalidSSNs.contains(clearedSSN)) {
      throw InvalidComponent();
    }
    if (RegExp(r'^(000|666|9)\d+').hasMatch(clearedSSN)) {
      throw InvalidComponent();
    }
    if (RegExp(r'^\d{3}00\d{4}').hasMatch(clearedSSN)) {
      throw InvalidComponent();
    }

    return ssn;
  }

  @override
  bool isValid(String ssn) {
    try {
      validate(ssn);
      return true;
    } catch (e) {
      return false;
    }
  }
}
