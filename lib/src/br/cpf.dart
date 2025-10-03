import 'package:stdnum_dart/src/interfaces/document_interface.dart';
import 'package:stdnum_dart/src/exceptions.dart';
import 'package:stdnum_dart/src/helpers/utils.dart';

class BR_CPF implements DocumentInterface {
  ({int firstDigit, int secondDigit}) _computeDigits(String cpf) {
    final digits = cpf.split('').map((d) => int.parse(d)).toList();
    final factorsFirstDigit = [10, 9, 8, 7, 6, 5, 4, 3, 2];
    final factorsSecondDigit = [11, 10, 9, 8, 7, 6, 5, 4, 3, 2];

    final firstDigit =
        (factorsFirstDigit
                .asMap()
                .entries
                .map((entry) => digits[entry.key] * entry.value)
                .reduce((a, b) => a + b) *
            10) %
        11;

    final secondDigit =
        (factorsSecondDigit
                .asMap()
                .entries
                .map((entry) => digits[entry.key] * entry.value)
                .reduce((a, b) => a + b) *
            10) %
        11;

    return (
      firstDigit: firstDigit == 10 ? 0 : firstDigit,
      secondDigit: secondDigit == 10 ? 0 : secondDigit,
    );
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
    final originalDigits = _extractDigits(cpf);
    final calculedDigits = _computeDigits(clearedCPF);
    if (calculedDigits.firstDigit != originalDigits.firstDigit ||
        calculedDigits.secondDigit != originalDigits.secondDigit) {
      throw InvalidChecksum();
    }
    return cpf;
  }

  @override
  String compact(String cpf) {
    return cpf.replaceAll(RegExp(r'[^0-9]'), '');
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
