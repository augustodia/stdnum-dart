import 'package:stdnum_dart/src/exceptions.dart';
import 'package:stdnum_dart/src/helpers/utils.dart';
import 'package:stdnum_dart/src/interfaces/document_interface.dart';

class EC_CI implements DocumentInterface {
  static bool validPrefix(String value) {
    final prefix = int.parse(value.substring(0, 2));
    return (prefix >= 1 && prefix <= 24) || prefix == 30 || prefix == 50;
  }

  int _checksum(String value) {
    var sum = 0;

    for (var index = 0; index < value.length; index++) {
      var digit = int.parse(value[index]);
      if (index.isEven) {
        digit *= 2;
      }
      if (digit > 9) {
        digit -= 9;
      }

      sum += digit;
    }

    return sum % 10;
  }

  @override
  String compact(String ci) {
    return ci.replaceAll(RegExp(r'[ -]'), '');
  }

  @override
  String format(String ci) {
    final clearedCI = compact(ci);
    if (clearedCI.length != 10) {
      throw InvalidLength();
    }

    return '${clearedCI.substring(0, 9)}-${clearedCI.substring(9, 10)}';
  }

  @override
  String validate(String ci) {
    final clearedCI = compact(ci);
    if (clearedCI.length != 10) {
      throw InvalidLength();
    }
    if (!StdnumDartUtils.isOnlyDigits(clearedCI)) {
      throw InvalidFormat();
    }
    if (!validPrefix(clearedCI)) {
      throw InvalidComponent();
    }
    if (int.parse(clearedCI[2]) > 6) {
      throw InvalidComponent();
    }
    if (_checksum(clearedCI) != 0) {
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
