import 'package:stdnum_dart/src/exceptions.dart';
import 'package:stdnum_dart/src/helpers/utils.dart';
import 'package:stdnum_dart/src/interfaces/document_interface.dart';

class PU_CUI implements DocumentInterface {
  static const List<int> _weights = [3, 2, 7, 6, 5, 4, 3, 2];
  static const String _digitMap = '65432110987';

  int _weightedSum(String front) {
    var sum = 0;
    for (var index = 0; index < front.length; index++) {
      sum = (sum + int.parse(front[index]) * _weights[index]) % 11;
    }
    return sum;
  }

  @override
  String compact(String cui) {
    return cui.replaceAll(RegExp(r'[ -]'), '');
  }

  @override
  String format(String cui) {
    final clearedCUI = compact(cui);
    if (clearedCUI.length != 8 && clearedCUI.length != 9) {
      throw InvalidLength();
    }

    if (clearedCUI.length == 9) {
      return '${clearedCUI.substring(0, 8)}-${clearedCUI.substring(8, 9)}';
    }
    return clearedCUI;
  }

  @override
  String validate(String cui) {
    final clearedCUI = compact(cui);
    if (clearedCUI.length != 8 && clearedCUI.length != 9) {
      throw InvalidLength();
    }
    if (!StdnumDartUtils.isOnlyDigits(clearedCUI)) {
      throw InvalidFormat();
    }

    if (clearedCUI.length == 9) {
      final front = clearedCUI.substring(0, 8);
      final check = clearedCUI.substring(8, 9);
      final expectedDigit = _digitMap[_weightedSum(front)];

      if (check != expectedDigit) {
        throw InvalidChecksum();
      }
    }

    return cui;
  }

  @override
  bool isValid(String cui) {
    try {
      validate(cui);
      return true;
    } catch (e) {
      return false;
    }
  }
}
