// ignore_for_file: non_constant_identifier_names

import 'package:stdnum_dart/src/countries/py/ci.dart';
import 'package:stdnum_dart/src/countries/py/ruc.dart';

class PY {
  static final PY _instance = PY._internal();

  PY._internal();

  factory PY() => _instance;

  PY_CI get CI => PY_CI();
  PY_RUC get RUC => PY_RUC();
}
