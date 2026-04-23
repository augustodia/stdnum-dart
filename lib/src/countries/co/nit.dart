import 'package:stdnum_dart/src/exceptions.dart';
import 'package:stdnum_dart/src/helpers/utils.dart';
import 'package:stdnum_dart/src/interfaces/document_interface.dart';

class CO_NIT implements DocumentInterface {
  static const List<int> _weights = [
    3,
    7,
    13,
    17,
    19,
    23,
    29,
    37,
    41,
    43,
    47,
    53,
    59,
    67,
    71,
  ];

  int _weightedSum(String front) {
    var sum = 0;

    for (var index = 0; index < front.length; index++) {
      final weight = _weights[index];
      final digit = int.parse(front[front.length - index - 1]);
      sum = (sum + digit * weight) % 11;
    }

    return sum;
  }

  @override
  String compact(String nit) {
    return nit.replaceAll(RegExp(r'[,.\- ]'), '').toUpperCase();
  }

  @override
  String format(String nit) {
    final clearedNIT = compact(nit);
    if (clearedNIT.length < 8 || clearedNIT.length > 16) {
      throw InvalidLength();
    }

    if (clearedNIT.length >= 10) {
      return '${clearedNIT.substring(0, 3)}.${clearedNIT.substring(3, 6)}.${clearedNIT.substring(6, 9)}-${clearedNIT.substring(9)}';
    }

    return '${clearedNIT.substring(0, clearedNIT.length - 1)}-${clearedNIT.substring(clearedNIT.length - 1)}';
  }

  @override
  String validate(String nit) {
    final clearedNIT = compact(nit);
    if (clearedNIT.length < 8 || clearedNIT.length > 16) {
      throw InvalidLength();
    }
    if (!StdnumDartUtils.isOnlyDigits(clearedNIT)) {
      throw InvalidComponent();
    }

    final front = clearedNIT.substring(0, clearedNIT.length - 1);
    final check = clearedNIT.substring(clearedNIT.length - 1);
    final digit = '01987654321'[_weightedSum(front)];

    if (check != digit) {
      throw InvalidChecksum();
    }

    return nit;
  }

  @override
  bool isValid(String nit) {
    try {
      validate(nit);
      return true;
    } catch (e) {
      return false;
    }
  }
}
