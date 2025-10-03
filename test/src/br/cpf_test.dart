import 'dart:math';

import 'package:stdnum_dart/src/countries/br/cpf.dart';
import 'package:stdnum_dart/src/exceptions.dart';
import 'package:test/test.dart';

List<String> _generateValidCPFs() {
  final cpfs = <String>[];
  final random = Random();

  for (var i = 0; i < 10; i++) {
    final baseDigits = List.generate(9, (_) => random.nextInt(10));

    var sum = 0;
    for (var i = 0; i < 9; i++) {
      sum += baseDigits[i] * (10 - i);
    }
    final firstDigit = (sum * 10) % 11 == 10 ? 0 : (sum * 10) % 11;

    baseDigits.add(firstDigit);

    sum = 0;
    for (var i = 0; i < 10; i++) {
      sum += baseDigits[i] * (11 - i);
    }
    final secondDigit = (sum * 10) % 11 == 10 ? 0 : (sum * 10) % 11;

    baseDigits.add(secondDigit);

    final cpf = baseDigits.join();
    cpfs.add(
      '${cpf.substring(0, 3)}.${cpf.substring(3, 6)}.${cpf.substring(6, 9)}-${cpf.substring(9)}',
    );
  }

  return cpfs;
}

final validCPFs = _generateValidCPFs();
final invalidCPFs = [
  '123.456.789-01',
  '123.456.789-00',
  '123.456.789-01',
  '123.456.789-02',
];
final invalidLengthCPFs = [
  '123.456.789',
  '123.456.789-0000',
  '123.456.789-00000',
  '123.456.789-000000',
  '123.456.789-0000000',
];
final invalidFormatCPFs = [
  '12A.456.789-01',
  'AAA.BBB.CCC-DD',
  '123.456.789-01A',
  '123.456.789-02A',
];
void main() {
  for (var cpf in validCPFs) {
    test('cpf valid $cpf', () async {
      final isValid = BR_CPF().isValid(cpf);
      expect(isValid, true);
    });
  }

  for (var cpf in invalidCPFs) {
    test('cpf invalid $cpf', () async {
      isValid() => BR_CPF().validate(cpf);
      expect(isValid, throwsA(isA<InvalidChecksum>()));
    });
  }

  for (var cpf in invalidLengthCPFs) {
    test('cpf invalid length $cpf', () async {
      isValid() => BR_CPF().validate(cpf);
      expect(isValid, throwsA(isA<InvalidLength>()));
    });
  }

  for (var cpf in invalidFormatCPFs) {
    test('cpf invalid format $cpf', () async {
      isValid() => BR_CPF().validate(cpf);
      expect(isValid, throwsA(isA<InvalidFormat>()));
    });
  }
}
