// ignore_for_file: non_constant_identifier_names

import 'package:stdnum_dart/src/countries/ve/rif.dart';

class VE {
  static final VE _instance = VE._internal();

  VE._internal();

  factory VE() => _instance;

  VE_RIF get RIF => VE_RIF();
}
