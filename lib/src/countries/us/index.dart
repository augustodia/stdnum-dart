// ignore_for_file: non_constant_identifier_names

import 'package:stdnum_dart/src/countries/us/ein.dart';
import 'package:stdnum_dart/src/countries/us/ssn.dart';

class US {
  static final US _instance = US._internal();

  US._internal();

  factory US() => _instance;

  US_EIN get EIN => US_EIN();
  US_SSN get SSN => US_SSN();
}
