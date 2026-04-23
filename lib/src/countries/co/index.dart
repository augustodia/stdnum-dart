// ignore_for_file: non_constant_identifier_names

import 'package:stdnum_dart/src/countries/co/nit.dart';

class CO {
  static final CO _instance = CO._internal();

  CO._internal();

  factory CO() => _instance;

  CO_NIT get NIT => CO_NIT();
}
