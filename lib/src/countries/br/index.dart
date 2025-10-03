// ignore_for_file: non_constant_identifier_names

import 'package:stdnum_dart/src/br/cpf.dart';
import 'package:stdnum_dart/src/countries/br/cnpj.dart';

class BR {
  static final BR _instance = BR._internal();

  BR._internal();

  factory BR() => _instance;

  BR_CPF get CPF => BR_CPF();
  BR_CNPJ get CNPJ => BR_CNPJ();
}
