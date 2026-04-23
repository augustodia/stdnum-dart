// ignore_for_file: non_constant_identifier_names

import 'package:stdnum_dart/src/countries/uy/ci.dart';
import 'package:stdnum_dart/src/countries/uy/rut.dart';

class UY {
  static final UY _instance = UY._internal();

  UY._internal();

  factory UY() => _instance;

  UY_CI get CI => UY_CI();
  UY_RUT get RUT => UY_RUT();
}
