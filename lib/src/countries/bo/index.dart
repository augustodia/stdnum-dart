// ignore_for_file: non_constant_identifier_names

import 'package:stdnum_dart/src/countries/bo/ci.dart';
import 'package:stdnum_dart/src/countries/bo/nif.dart';

class BO {
  static final BO _instance = BO._internal();

  BO._internal();

  factory BO() => _instance;

  BO_CI get CI => BO_CI();
  BO_NIF get NIF => BO_NIF();
}
