import 'package:stdnum_dart/src/exceptions.dart';
import 'package:stdnum_dart/src/helpers/utils.dart';
import 'package:stdnum_dart/src/interfaces/document_interface.dart';

class PY_CI implements DocumentInterface {
  @override
  String compact(String ci) {
    return ci.replaceAll(RegExp(r'[ .-]'), '');
  }

  @override
  String format(String ci) {
    return compact(ci);
  }

  @override
  String validate(String ci) {
    final clearedCI = compact(ci);
    if (clearedCI.length < 5 || clearedCI.length > 7) {
      throw InvalidLength();
    }
    if (!StdnumDartUtils.isOnlyDigits(clearedCI)) {
      throw InvalidComponent();
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
