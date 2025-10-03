import 'package:stdnum_dart/src/countries/br/cnpj.dart';
import 'package:stdnum_dart/src/exceptions.dart';
import 'package:test/test.dart';

final validCNPJs = [
  '27.964.657/0001-25',
  '85.060.965/0001-22',
  '20.060.005/0001-17',
];
final invalidCNPJs = [
  '27.964.657/0001-00',
  '27.964.657/0001-10',
  '85.060.965/0001-12',
  '20.060.005/0001-77',
];
final invalidLengthCNPJs = [
  '12.456.78',
  '12.456.789',
  '12.456.789/0000',
  '12.456.789/00000',
];
final invalidFormatCNPJs = [
  '12.A56.789/0198-55',
  'AA.BBB.CCC/DDHD-56',
  '12.456.789/01AB-23',
  '12.456.789/02A1-11',
];
void main() {
  for (var cnpj in validCNPJs) {
    test('cnpj valid $cnpj', () async {
      final isValid = BR_CNPJ().isValid(cnpj);
      expect(isValid, true);
    });
  }

  for (var cnpj in invalidCNPJs) {
    test('cnpj invalid $cnpj', () async {
      isValid() => BR_CNPJ().validate(cnpj);
      expect(isValid, throwsA(isA<InvalidChecksum>()));
    });
  }

  for (var cnpj in invalidLengthCNPJs) {
    test('cnpj invalid length $cnpj', () async {
      isValid() => BR_CNPJ().validate(cnpj);
      expect(isValid, throwsA(isA<InvalidLength>()));
    });
  }

  for (var cnpj in invalidFormatCNPJs) {
    test('cnpj invalid format $cnpj', () async {
      isValid() => BR_CNPJ().validate(cnpj);
      expect(isValid, throwsA(isA<InvalidFormat>()));
    });
  }
}
