import 'package:stdnum_dart/src/exceptions.dart';
import 'package:stdnum_dart/src/helpers/utils.dart';
import 'package:stdnum_dart/src/interfaces/document_interface.dart';

class PY_RUC implements DocumentInterface {
  String _calculateCheckDigit(String front) {
    final reversedDigits =
        front.split('').reversed.map((digit) => int.parse(digit)).toList();

    final sum = reversedDigits
        .asMap()
        .entries
        .map((entry) => entry.value * (entry.key + 2))
        .reduce((a, b) => a + b);

    return '${(11 - (sum % 11)) % 10}';
  }

  @override
  String compact(String ruc) {
    return ruc.replaceAll(RegExp(r'[ -]'), '');
  }

  @override
  String format(String ruc) {
    final clearedRUC = compact(ruc);
    if (clearedRUC.length < 5 || clearedRUC.length > 9) {
      throw InvalidLength();
    }

    return '${clearedRUC.substring(0, clearedRUC.length - 1)}-${clearedRUC.substring(clearedRUC.length - 1)}';
  }

  @override
  String validate(String ruc) {
    final clearedRUC = compact(ruc);
    if (clearedRUC.length < 5 || clearedRUC.length > 9) {
      throw InvalidLength();
    }
    if (!StdnumDartUtils.isOnlyDigits(clearedRUC)) {
      throw InvalidComponent();
    }

    final front = clearedRUC.substring(0, clearedRUC.length - 1);
    final check = clearedRUC.substring(clearedRUC.length - 1);

    final expectedDigit = _calculateCheckDigit(front);
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
