// ignore_for_file: non_constant_identifier_names

import 'package:stdnum_dart/src/countries/br/index.dart' as countries;

class StdnumDart {
  static final StdnumDart _instance = StdnumDart._internal();

  StdnumDart._internal();

  factory StdnumDart() => _instance;

  countries.BR get BR => countries.BR();
}
