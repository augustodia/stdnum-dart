// ignore_for_file: non_constant_identifier_names

import 'package:stdnum_dart/src/countries/pt/cc.dart';
import 'package:stdnum_dart/src/countries/pt/nif.dart';

class PT {
  static final PT _instance = PT._internal();

  PT._internal();

  factory PT() => _instance;

  PT_CC get CC => PT_CC();
  PT_NIF get NIF => PT_NIF();
}
