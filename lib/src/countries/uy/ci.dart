import 'package:stdnum_dart/src/exceptions.dart';
import 'package:stdnum_dart/src/helpers/utils.dart';
import 'package:stdnum_dart/src/interfaces/document_interface.dart';

class UY_CI implements DocumentInterface {
  static const List<int> _weights = [2, 9, 8, 7, 6, 3, 4];

  int _weightedSum(String front) {
    var sum = 0;
    for (var index = 0; index < front.length; index++) {
      sum = (sum + int.parse(front[index]) * _weights[index]) % 10;
    }
    return sum;
  }

  @override
  String compact(String ci) {
    return ci.replaceAll(RegExp(r'[ -/]'), '');
  }

  @override
  String format(String ci) {
    final clearedCI = compact(ci);
    if (clearedCI.length != 8) {
      throw InvalidLength();
    }

    return '${clearedCI.substring(0, 1)}.${clearedCI.substring(1, 4)}.${clearedCI.substring(4, 7)}-${clearedCI.substring(7, 8)}';
  }

  @override
  String validate(String ci) {
    final clearedCI = compact(ci);
    if (clearedCI.length != 8) {
      throw InvalidLength();
    }
    if (!StdnumDartUtils.isOnlyDigits(clearedCI)) {
      throw InvalidFormat();
    }

    final front = clearedCI.substring(0, 7);
    final check = clearedCI.substring(7, 8);
    final expectedDigit = '${(10 - _weightedSum(front)) % 10}';

    if (check != expectedDigit) {
      throw InvalidChecksum();
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
