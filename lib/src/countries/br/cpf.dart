import 'package:stdnum_dart/src/interfaces/document_interface.dart';
import 'package:stdnum_dart/src/exceptions.dart';
import 'package:stdnum_dart/src/helpers/utils.dart';

class BR_CPF implements DocumentInterface {
  int _computeDigit(List<int> digits, List<int> factors) {
    final multiplier = 10;
    final modulus = 11;

    final digit =
        (factors
                .asMap()
                .entries
                .map((entry) => digits[entry.key] * entry.value)
                .reduce((a, b) => a + b) *
            multiplier) %
        modulus;

    return digit == 10 ? 0 : digit;
  }

  ({int firstDigit, int secondDigit}) _computeDigits(String cpf) {
    final digits = cpf.split('').map((d) => int.parse(d)).toList();
    final factors = [11, 10, 9, 8, 7, 6, 5, 4, 3, 2];

    final firstDigit = _computeDigit(
      digits,
      factors.sublist(1, factors.length),
    );
    final secondDigit = _computeDigit(digits, factors);

    return (firstDigit: firstDigit, secondDigit: secondDigit);
  }

  ({int firstDigit, int secondDigit}) _extractDigits(String cpf) {
    final clearedCPF = compact(cpf);
    return (
      firstDigit: int.parse(clearedCPF[9]),
      secondDigit: int.parse(clearedCPF[10]),
    );
  }

  @override
  String validate(String cpf) {
    final clearedCPF = compact(cpf);
    final isOnlyDigits = StdnumDartUtils.isOnlyDigits(clearedCPF);
    if (!isOnlyDigits) throw InvalidFormat();
    if (clearedCPF.length != 11) throw InvalidLength();
    final originalDigits = _extractDigits(clearedCPF);
    final calculedDigits = _computeDigits(clearedCPF);
    if (calculedDigits.firstDigit != originalDigits.firstDigit ||
        calculedDigits.secondDigit != originalDigits.secondDigit) {
      throw InvalidChecksum();
    }
    return cpf;
  }

  @override
  String compact(String cpf) {
    return cpf.replaceAll(RegExp(r'[.-]'), '');
  }

  @override
  String format(String cpf) {
    final clearedCPF = compact(cpf);
    return '${clearedCPF.substring(0, 3)}.${clearedCPF.substring(3, 6)}.${clearedCPF.substring(6, 9)}-${clearedCPF.substring(9, 11)}';
  }

  @override
  bool isValid(String cpf) {
    try {
      validate(cpf);
      return true;
    } catch (e) {
      return false;
    }
  }
}
