import 'package:stdnum_dart/stdnum_dart.dart';

void main() {
  final stdnum = StdnumDart();

  final br = stdnum.BR;

  print('=== CPF Examples ===');
  final validCpf = '11144477735';
  final invalidCpf = '12345678901';

  print('Valid CPF: $validCpf');
  print('Is valid: ${br.CPF.isValid(validCpf)}');
  print('Formatted: ${br.CPF.format(validCpf)}');
  print('Compact: ${br.CPF.compact(validCpf)}');

  print('\nInvalid CPF: $invalidCpf');
  print('Is valid: ${br.CPF.isValid(invalidCpf)}');

  print('\n=== CNPJ Examples ===');
  final validCnpj = '11222333000181';
  final invalidCnpj = '12345678000123';

  print('Valid CNPJ: $validCnpj');
  print('Is valid: ${br.CNPJ.isValid(validCnpj)}');
  print('Formatted: ${br.CNPJ.format(validCnpj)}');
  print('Compact: ${br.CNPJ.compact(validCnpj)}');

  print('\nInvalid CNPJ: $invalidCnpj');
  print('Is valid: ${br.CNPJ.isValid(invalidCnpj)}');

  print('\n=== Exception Handling ===');
  try {
    br.CPF.validate('00000000000');
  } catch (e) {
    print('Validation error: $e');
  }
}
