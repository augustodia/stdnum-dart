// ignore_for_file: camel_case_types

import 'package:stdnum_dart/src/exceptions.dart';
import 'package:stdnum_dart/src/interfaces/document_interface.dart';

class BO_CI implements DocumentInterface {
  static const Set<String> _validDepartments = {
    'LP',
    'OR',
    'PT',
    'CB',
    'CH',
    'TJ',
    'SC',
    'BE',
    'PD',
  };

  @override
  String compact(String ci) {
    return ci.replaceAll(RegExp(r'[ \-.]'), '').toUpperCase();
  }

  @override
  String format(String ci) {
    final clearedCI = compact(ci);
    final match = RegExp(
      r'^(\d{7,8})([A-Z]{2})([A-Z0-9]{0,2})$',
    ).firstMatch(clearedCI);

    if (match == null) {
      return clearedCI;
    }

    final number = match.group(1)!;
    final department = match.group(2)!;
    final extension = match.group(3)!;

    if (extension.isNotEmpty) {
      return '$number-$department-$extension';
    }

    return '$number-$department';
  }

  @override
  String validate(String ci) {
    final clearedCI = compact(ci);
    if (!RegExp(r'^[A-Z0-9]+$').hasMatch(clearedCI)) {
      throw InvalidFormat();
    }

    final match = RegExp(r'^(\d+)(.*)$').firstMatch(clearedCI);
    if (match == null) {
      throw InvalidFormat();
    }

    final number = match.group(1)!;
    final rest = match.group(2)!;

    if (number.length < 7 || number.length > 8) {
      throw InvalidLength();
    }
    if (rest.length < 2) {
      throw InvalidLength();
    }

    final department = rest.substring(0, 2);
    final extension = rest.substring(2);

    if (!RegExp(r'^[A-Z]{2}$').hasMatch(department)) {
      throw InvalidFormat();
    }
    if (!_validDepartments.contains(department)) {
      throw InvalidComponent();
    }
    if (extension.length > 2) {
      throw InvalidFormat();
    }
    if (extension.isNotEmpty && !RegExp(r'^[A-Z0-9]+$').hasMatch(extension)) {
      throw InvalidFormat();
    }

    final totalLength = number.length + department.length + extension.length;
    if (totalLength < 9 || totalLength > 12) {
      throw InvalidLength();
    }

    return ci;
  }

  @override
  bool isValid(String ci) {
    try {
      validate(ci);
      return true;
    } catch (e) {
      return false;
    }
  }
}
