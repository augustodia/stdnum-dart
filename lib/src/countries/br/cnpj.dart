import 'package:stdnum_dart/src/exceptions.dart';
import 'package:stdnum_dart/src/helpers/utils.dart';
import 'package:stdnum_dart/src/interfaces/document_interface.dart';

class BR_CNPJ implements DocumentInterface {
  int _computeDigit(List<int> digits, List<int> factors) {
    final modulus = 11;

    final digit =
        factors
            .asMap()
            .entries
            .map((entry) => digits[entry.key] * entry.value)
            .reduce((a, b) => a + b) %
        modulus;

    return digit <= 1 ? 0 : 11 - digit;
  }

  ({int firstDigit, int secondDigit}) _computeDigits(String cnpj) {
    final digits = cnpj.split('').map((d) => int.parse(d)).toList();
    final factors = [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];

    final firstDigit = _computeDigit(
      digits,
      factors.sublist(1, factors.length),
    );
    final secondDigit = _computeDigit(digits, factors);

    return (firstDigit: firstDigit, secondDigit: secondDigit);
  }

  ({int firstDigit, int secondDigit}) _extractDigits(String cnpj) {
    final clearedCNPJ = compact(cnpj);
    return (
      firstDigit: int.parse(clearedCNPJ[12]),
      secondDigit: int.parse(clearedCNPJ[13]),
    );
  }

  @override
  String compact(String cnpj) {
    return cnpj.replaceAll(RegExp(r'[-./]'), '');
  }

  @override
  String format(String cnpj) {
    final clearedCNPJ = compact(cnpj);
    return '${clearedCNPJ.substring(0, 2)}.${clearedCNPJ.substring(2, 5)}.${clearedCNPJ.substring(5, 8)}/${clearedCNPJ.substring(8, 12)}-${clearedCNPJ.substring(12, 14)}';
  }

  @override
  String validate(String cnpj) {
    final clearedCNPJ = compact(cnpj);
    final isOnlyDigits = StdnumDartUtils.isOnlyDigits(clearedCNPJ);
    if (!isOnlyDigits) throw InvalidFormat();
    if (clearedCNPJ.length != 14) throw InvalidLength();
    final originalDigits = _extractDigits(clearedCNPJ);
    final calculedDigits = _computeDigits(clearedCNPJ);
    if (calculedDigits.firstDigit != originalDigits.firstDigit ||
        calculedDigits.secondDigit != originalDigits.secondDigit) {
      throw InvalidChecksum();
    }
    return cnpj;
  }

  @override
  bool isValid(String cnpj) {
    try {
      validate(cnpj);
      return true;
    } catch (e) {
      return false;
    }
  }
}
