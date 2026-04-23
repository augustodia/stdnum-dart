import 'package:stdnum_dart/src/countries/ar/dni.dart';
import 'package:stdnum_dart/src/exceptions.dart';
import 'package:test/test.dart';

final validDNIs = [
  '12345678',
  '12.345.678',
  '1234567',
  '1.234.567',
  ' 12.345.678 ',
];

final invalidLengthDNIs = ['123456', '123456789', '12.345', '1234'];

final invalidComponentDNIs = ['12A45678', '1.23A.567', '12-34567', 'ABC45678'];

void main() {
  for (var dni in validDNIs) {
    test('dni valid $dni', () async {
      final isValid = AR_DNI().isValid(dni);
      expect(isValid, true);
    });
  }

  for (var dni in invalidLengthDNIs) {
    test('dni invalid length $dni', () async {
      isValid() => AR_DNI().validate(dni);
      expect(isValid, throwsA(isA<InvalidLength>()));
    });
  }

  for (var dni in invalidComponentDNIs) {
    test('dni invalid component $dni', () async {
      isValid() => AR_DNI().validate(dni);
      expect(isValid, throwsA(isA<InvalidComponent>()));
    });
  }

  test('dni compact', () async {
    final compacted = AR_DNI().compact(' 12.345.678 ');
    expect(compacted, '12345678');
  });

  test('dni format', () async {
    final formatted8 = AR_DNI().format('12345678');
    final formatted7 = AR_DNI().format('1234567');

    expect(formatted8, '12.345.678');
    expect(formatted7, '1.234.567');
  });
}
