import 'package:stdnum_dart/src/countries/ec/ci.dart';
import 'package:stdnum_dart/src/exceptions.dart';
import 'package:stdnum_dart/src/helpers/utils.dart';
import 'package:stdnum_dart/src/interfaces/document_interface.dart';

class EC_RUC implements DocumentInterface {
  static const List<int> _publicWeights = [3, 2, 7, 6, 5, 4, 3, 2, 1];
  static const List<int> _juridicalWeights = [4, 3, 2, 7, 6, 5, 4, 3, 2, 1];

  int _weightedSum(String value, List<int> weights) {
    var sum = 0;
    for (var index = 0; index < value.length; index++) {
      sum = (sum + int.parse(value[index]) * weights[index]) % 11;
    }
    return sum;
  }

  @override
  String compact(String ruc) {
    return ruc.replaceAll(RegExp(r'[ -.]'), '');
  }

  @override
  String format(String ruc) {
    final clearedRUC = compact(ruc);
    if (clearedRUC.length != 13) {
      throw InvalidLength();
    }

    return '${clearedRUC.substring(0, 10)}-${clearedRUC.substring(10, 13)}';
  }

  @override
  String validate(String ruc) {
    final clearedRUC = compact(ruc);
    if (clearedRUC.length != 13) {
      throw InvalidLength();
    }
    if (!StdnumDartUtils.isOnlyDigits(clearedRUC)) {
      throw InvalidFormat();
    }
    if (!EC_CI.validPrefix(clearedRUC)) {
      throw InvalidComponent();
    }

    final thirdDigit = int.parse(clearedRUC[2]);

    if (thirdDigit < 6) {
      final front = clearedRUC.substring(0, 10);
      final end = clearedRUC.substring(10, 13);
      if (end == '000') {
        throw InvalidComponent();
      }

      EC_CI().validate(front);
      return ruc;
    }

    if (thirdDigit == 6) {
      final front = clearedRUC.substring(0, 9);
      final end = clearedRUC.substring(9, 13);
      if (end == '0000') {
        throw InvalidComponent();
      }

      if (_weightedSum(front, _publicWeights) != 0) {
        if (end.endsWith('000')) {
          throw InvalidComponent();
        }

        EC_CI().validate(clearedRUC.substring(0, 10));
        return ruc;
      }
    } else if (thirdDigit == 9) {
      final front = clearedRUC.substring(0, 10);
      final end = clearedRUC.substring(10, 13);
      if (end == '000') {
        throw InvalidComponent();
      }
      if (_weightedSum(front, _juridicalWeights) != 0) {
        throw InvalidChecksum();
      }
    } else {
      throw InvalidComponent();
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
