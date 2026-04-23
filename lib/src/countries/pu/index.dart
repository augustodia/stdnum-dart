// ignore_for_file: non_constant_identifier_names

import 'package:stdnum_dart/src/countries/pu/cui.dart';
import 'package:stdnum_dart/src/countries/pu/ruc.dart';

class PU {
  static final PU _instance = PU._internal();

  PU._internal();

  factory PU() => _instance;

  PU_CUI get CUI => PU_CUI();
  PU_RUC get RUC => PU_RUC();
}
