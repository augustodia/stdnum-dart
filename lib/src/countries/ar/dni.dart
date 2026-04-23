import 'package:stdnum_dart/src/exceptions.dart';
import 'package:stdnum_dart/src/helpers/utils.dart';
import 'package:stdnum_dart/src/interfaces/document_interface.dart';

class AR_DNI implements DocumentInterface {
  @override
  String compact(String dni) {
    return dni.replaceAll(RegExp(r'[ .]'), '');
  }

  @override
  String format(String dni) {
    final clearedDNI = compact(dni);
    if (clearedDNI.length != 7 && clearedDNI.length != 8) {
      throw InvalidLength();
    }

    return '${clearedDNI.substring(0, clearedDNI.length - 6)}.${clearedDNI.substring(clearedDNI.length - 6, clearedDNI.length - 3)}.${clearedDNI.substring(clearedDNI.length - 3)}';
  }

  @override
  String validate(String dni) {
    final clearedDNI = compact(dni);
    if (clearedDNI.length != 7 && clearedDNI.length != 8) {
      throw InvalidLength();
    }
    if (!StdnumDartUtils.isOnlyDigits(clearedDNI)) {
      throw InvalidComponent();
    }

    return dni;
  }

  @override
  bool isValid(String dni) {
    try {
      validate(dni);
      return true;
    } catch (e) {
      return false;
    }
  }
}
