import 'package:stdnum_dart/src/exceptions.dart';
import 'package:stdnum_dart/src/helpers/utils.dart';
import 'package:stdnum_dart/src/interfaces/document_interface.dart';

class AR_CUIT implements DocumentInterface {
  static const Set<String> _cuitTypes = {
    '20',
    '23',
    '24',
    '27',
    '30',
    '33',
    '34',
    '50',
    '51',
    '55',
  };
  static const List<int> _weights = [5, 4, 3, 2, 7, 6, 5, 4, 3, 2];
  static const String _digitMap = '012345678990';

  @override
  String compact(String cuit) {
    return cuit.replaceAll(RegExp(r'[ -]'), '');
  }

  @override
  String format(String cuit) {
    final clearedCUIT = compact(cuit);
    if (clearedCUIT.length != 11) {
      throw InvalidLength();
    }

    return '${clearedCUIT.substring(0, 2)}-${clearedCUIT.substring(2, 10)}-${clearedCUIT.substring(10, 11)}';
  }

  String _calculateCheckDigit(String value) {
    var sum = 0;
    for (var index = 0; index < value.length; index++) {
      sum += int.parse(value[index]) * _weights[index];
    }
    final checksum = sum % 11;
    return _digitMap[11 - checksum];
  }

  @override
  String validate(String cuit) {
    final clearedCUIT = compact(cuit);
    if (clearedCUIT.length != 11) {
      throw InvalidLength();
    }
    if (!StdnumDartUtils.isOnlyDigits(clearedCUIT)) {
      throw InvalidFormat();
    }

    final front = clearedCUIT.substring(0, 2);
    final body = clearedCUIT.substring(2, 10);
    final checkDigit = clearedCUIT.substring(10, 11);

    if (!_cuitTypes.contains(front)) {
      throw InvalidComponent();
    }

    final expectedDigit = _calculateCheckDigit('$front$body');
    if (expectedDigit != checkDigit) {
      throw InvalidChecksum();
    }

    return cuit;
  }

  @override
  bool isValid(String cuit) {
    try {
      validate(cuit);
      return true;
    } catch (e) {
      return false;
    }
  }
}
