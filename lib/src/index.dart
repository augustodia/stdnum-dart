// ignore_for_file: non_constant_identifier_names

import 'package:stdnum_dart/src/countries/ar/index.dart' as ar;
import 'package:stdnum_dart/src/countries/bo/index.dart' as bo;
import 'package:stdnum_dart/src/countries/br/index.dart' as br;
import 'package:stdnum_dart/src/countries/cl/index.dart' as cl;
import 'package:stdnum_dart/src/countries/co/index.dart' as co;
import 'package:stdnum_dart/src/countries/ec/index.dart' as ec;
import 'package:stdnum_dart/src/countries/es/index.dart' as es;
import 'package:stdnum_dart/src/countries/mx/index.dart' as mx;
import 'package:stdnum_dart/src/countries/pt/index.dart' as pt;
import 'package:stdnum_dart/src/countries/pu/index.dart' as pu;
import 'package:stdnum_dart/src/countries/py/index.dart' as py;
import 'package:stdnum_dart/src/countries/us/index.dart' as us;
import 'package:stdnum_dart/src/countries/uy/index.dart' as uy;
import 'package:stdnum_dart/src/countries/ve/index.dart' as ve;

/// Entry point for country-specific document validators.
class StdnumDart {
  static final StdnumDart _instance = StdnumDart._internal();

  StdnumDart._internal();

  /// Creates the singleton facade used to access all validators.
  factory StdnumDart() => _instance;

  /// Argentina validators.
  ar.AR get AR => ar.AR();

  /// Bolivia validators.
  bo.BO get BO => bo.BO();

  /// Brazil validators.
  br.BR get BR => br.BR();

  /// Chile validators.
  cl.CL get CL => cl.CL();

  /// Colombia validators.
  co.CO get CO => co.CO();

  /// Ecuador validators.
  ec.EC get EC => ec.EC();

  /// Spain validators.
  es.ES get ES => es.ES();

  /// Mexico validators.
  mx.MX get MX => mx.MX();

  /// Portugal validators.
  pt.PT get PT => pt.PT();

  /// Peru validators.
  pu.PU get PU => pu.PU();

  /// Paraguay validators.
  py.PY get PY => py.PY();

  /// United States validators.
  us.US get US => us.US();

  /// Uruguay validators.
  uy.UY get UY => uy.UY();

  /// Venezuela validators.
  ve.VE get VE => ve.VE();
}
