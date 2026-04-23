// ignore_for_file: non_constant_identifier_names

import 'package:stdnum_dart/src/countries/es/dni.dart';
import 'package:stdnum_dart/src/countries/es/nif.dart';

class ES {
  static final ES _instance = ES._internal();

  ES._internal();

  factory ES() => _instance;

  ES_DNI get DNI => ES_DNI();
  ES_NIF get NIF => ES_NIF();
}
