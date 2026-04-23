// ignore_for_file: non_constant_identifier_names

import 'package:stdnum_dart/src/countries/ar/cuit.dart';
import 'package:stdnum_dart/src/countries/ar/dni.dart';

class AR {
  static final AR _instance = AR._internal();

  AR._internal();

  factory AR() => _instance;

  AR_CUIT get CUIT => AR_CUIT();
  AR_DNI get DNI => AR_DNI();
}
