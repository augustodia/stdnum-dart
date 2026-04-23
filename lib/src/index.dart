// ignore_for_file: non_constant_identifier_names

import 'package:stdnum_dart/src/countries/ar/index.dart' as ar;
import 'package:stdnum_dart/src/countries/br/index.dart' as br;
import 'package:stdnum_dart/src/countries/cl/index.dart' as cl;
import 'package:stdnum_dart/src/countries/es/index.dart' as es;
import 'package:stdnum_dart/src/countries/mx/index.dart' as mx;
import 'package:stdnum_dart/src/countries/pt/index.dart' as pt;
import 'package:stdnum_dart/src/countries/pu/index.dart' as pu;
import 'package:stdnum_dart/src/countries/py/index.dart' as py;
import 'package:stdnum_dart/src/countries/us/index.dart' as us;
import 'package:stdnum_dart/src/countries/uy/index.dart' as uy;

class StdnumDart {
  static final StdnumDart _instance = StdnumDart._internal();

  StdnumDart._internal();

  factory StdnumDart() => _instance;

  ar.AR get AR => ar.AR();
  br.BR get BR => br.BR();
  cl.CL get CL => cl.CL();
  es.ES get ES => es.ES();
  mx.MX get MX => mx.MX();
  pt.PT get PT => pt.PT();
  pu.PU get PU => pu.PU();
  py.PY get PY => py.PY();
  us.US get US => us.US();
  uy.UY get UY => uy.UY();
}
