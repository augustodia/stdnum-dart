// ignore_for_file: camel_case_types

import 'package:stdnum_dart/src/exceptions.dart';
import 'package:stdnum_dart/src/helpers/utils.dart';
import 'package:stdnum_dart/src/interfaces/document_interface.dart';

class PU_RUC implements DocumentInterface {
  static const Set<String> _validPrefixes = {'10', '15', '16', '17', '20'};
  static const List<int> _weights = [5, 4, 3, 2, 7, 6, 5, 4, 3, 2];

  int _weightedSum(String front) {
    var sum = 0;
    for (var index = 0; index < front.length; index++) {
      sum = (sum + int.parse(front[index]) * _weights[index]) % 11;
    }
    return sum;
  }

  @override
  String compact(String ruc) {
    return ruc.replaceAll(RegExp(r'[ -]'), '');
  }

  @override
  String format(String ruc) {
    return compact(ruc);
  }

  @override
  String validate(String ruc) {
    final clearedRUC = compact(ruc);
    if (clearedRUC.length != 11) {
      throw InvalidLength();
    }
    if (!StdnumDartUtils.isOnlyDigits(clearedRUC)) {
      throw InvalidFormat();
    }
    if (!_validPrefixes.contains(clearedRUC.substring(0, 2))) {
      throw InvalidComponent();
    }

    final front = clearedRUC.substring(0, 10);
    final check = clearedRUC.substring(10, 11);
    final expectedDigit = '${(11 - _weightedSum(front)) % 10}';

    if (check != expectedDigit) {
      throw InvalidChecksum();
    }

    return ruc;
  }

  @override
  bool isValid(String ruc) {
    try {
      validate(ruc);
      return true;
    } catch (e) {
      return false;
    }
  }
}
