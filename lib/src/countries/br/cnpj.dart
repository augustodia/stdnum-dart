import 'package:stdnum_dart/src/exceptions.dart';
import 'package:stdnum_dart/src/interfaces/document_interface.dart';

class BR_CNPJ implements DocumentInterface {
  static final RegExp _validCNPJ = RegExp(r'^[A-Z0-9]{12}\d{2}$');
  static const List<int> _firstDigitWeights = [
    5,
    4,
    3,
    2,
    9,
    8,
    7,
    6,
    5,
    4,
    3,
    2,
  ];
  static const List<int> _secondDigitWeights = [
    6,
    5,
    4,
    3,
    2,
    9,
    8,
    7,
    6,
    5,
    4,
    3,
    2,
  ];

  int _characterValue(String character) {
    return character.codeUnitAt(0) - 48;
  }

  int _computeDigit(String value, List<int> weights) {
    final sum = weights
        .asMap()
        .entries
        .map((entry) => _characterValue(value[entry.key]) * entry.value)
        .reduce((a, b) => a + b);
    final remainder = sum % 11;

    return remainder <= 1 ? 0 : 11 - remainder;
  }

  ({int firstDigit, int secondDigit}) _computeDigits(String cnpj) {
    final body = cnpj.substring(0, 12);
    final firstDigit = _computeDigit(body, _firstDigitWeights);
    final secondDigit = _computeDigit('$body$firstDigit', _secondDigitWeights);

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
    return cnpj.replaceAll(RegExp(r'[-./]'), '').toUpperCase();
  }

  @override
  String format(String cnpj) {
    final clearedCNPJ = compact(cnpj);
    if (clearedCNPJ.length != 14) {
      throw InvalidLength();
    }

    return '${clearedCNPJ.substring(0, 2)}.${clearedCNPJ.substring(2, 5)}.${clearedCNPJ.substring(5, 8)}/${clearedCNPJ.substring(8, 12)}-${clearedCNPJ.substring(12, 14)}';
  }

  @override
  String validate(String cnpj) {
    final clearedCNPJ = compact(cnpj);
    if (clearedCNPJ.length != 14) throw InvalidLength();
    if (!_validCNPJ.hasMatch(clearedCNPJ)) throw InvalidFormat();
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
