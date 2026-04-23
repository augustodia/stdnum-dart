// ignore_for_file: non_constant_identifier_names

import 'package:stdnum_dart/src/countries/br/index.dart' as br;
import 'package:stdnum_dart/src/countries/cl/index.dart' as cl;
import 'package:stdnum_dart/src/countries/mx/index.dart' as mx;

class StdnumDart {
  static final StdnumDart _instance = StdnumDart._internal();

  StdnumDart._internal();

  factory StdnumDart() => _instance;

  br.BR get BR => br.BR();
  cl.CL get CL => cl.CL();
  mx.MX get MX => mx.MX();
}
