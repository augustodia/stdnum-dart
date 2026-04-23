// ignore_for_file: non_constant_identifier_names

import 'package:stdnum_dart/src/countries/mx/rfc.dart';

class MX {
  static final MX _instance = MX._internal();

  MX._internal();

  factory MX() => _instance;

  MX_RFC get RFC => MX_RFC();
}
