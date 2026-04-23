// ignore_for_file: non_constant_identifier_names

import 'package:stdnum_dart/src/countries/ec/ci.dart';
import 'package:stdnum_dart/src/countries/ec/ruc.dart';

class EC {
  static final EC _instance = EC._internal();

  EC._internal();

  factory EC() => _instance;

  EC_CI get CI => EC_CI();
  EC_RUC get RUC => EC_RUC();
}
