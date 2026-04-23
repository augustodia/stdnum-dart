// ignore_for_file: non_constant_identifier_names

import 'package:stdnum_dart/src/countries/cl/rut.dart';

class CL {
  static final CL _instance = CL._internal();

  CL._internal();

  factory CL() => _instance;

  CL_RUT get RUT => CL_RUT();
}
