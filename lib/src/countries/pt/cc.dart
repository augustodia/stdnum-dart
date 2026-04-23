import 'package:stdnum_dart/src/exceptions.dart';
import 'package:stdnum_dart/src/interfaces/document_interface.dart';

class PT_CC implements DocumentInterface {
  static const String _alphabet = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  static final RegExp _validRe = RegExp(r'^\d{9}[A-Z0-9]{2}\d$');

  bool _luhnChecksumValidate(String value) {
    final parity = value.length % 2;
    var sum = 0;

    for (var index = 0; index < value.length; index++) {
      final alphabetIndex = _alphabet.indexOf(value[index]);
      if (alphabetIndex < 0) {
        return false;
      }

      var digit = alphabetIndex;
      if (index % 2 == parity) {
        digit *= 2;
        if (digit > 9) {
          digit -= 9;
        }
      }

      sum += digit;
    }

    return sum % 10 == 0;
  }

  @override
  String compact(String cc) {
    return cc.replaceAll(RegExp(r' '), '').toUpperCase();
  }

  @override
  String format(String cc) {
    final clearedCC = compact(cc);
    if (clearedCC.length != 12) {
      throw InvalidLength();
    }

    return '${clearedCC.substring(0, 8)} ${clearedCC.substring(8, 9)} ${clearedCC.substring(9, 12)}';
  }

  @override
  String validate(String cc) {
    final clearedCC = compact(cc);
    if (clearedCC.length != 12) {
      throw InvalidLength();
    }
    if (!_validRe.hasMatch(clearedCC)) {
      throw InvalidFormat();
    }
    if (!_luhnChecksumValidate(clearedCC)) {
      throw InvalidChecksum();
    }

    return cc;
  }

  @override
  bool isValid(String cc) {
    try {
      validate(cc);
      return true;
    } catch (e) {
      return false;
    }
  }
}
