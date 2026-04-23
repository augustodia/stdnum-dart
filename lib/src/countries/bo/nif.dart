// ignore_for_file: camel_case_types

import 'package:stdnum_dart/src/exceptions.dart';
import 'package:stdnum_dart/src/helpers/utils.dart';
import 'package:stdnum_dart/src/interfaces/document_interface.dart';

class BO_NIF implements DocumentInterface {
  @override
  String compact(String nif) {
    final compacted = nif.replaceAll(RegExp(r'[ \-.]'), '').toUpperCase();
    if (compacted.startsWith('BO')) {
      return compacted.substring(2);
    }
    return compacted;
  }

  @override
  String format(String nif) {
    return compact(nif);
  }

  @override
  String validate(String nif) {
    final clearedNIF = compact(nif);
    if (clearedNIF.length < 5 || clearedNIF.length > 12) {
      throw InvalidLength();
    }
    if (!StdnumDartUtils.isOnlyDigits(clearedNIF)) {
      throw InvalidFormat();
    }

    return nif;
  }

  @override
  bool isValid(String nif) {
    try {
      validate(nif);
      return true;
    } catch (e) {
      return false;
    }
  }
}
