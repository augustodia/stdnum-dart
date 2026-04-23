import 'package:stdnum_dart/src/countries/us/ssn.dart';
import 'package:stdnum_dart/src/exceptions.dart';
import 'package:test/test.dart';

final validSSNs = [
  '123-45-6789',
  '001010001',
  '665-99-9999',
  ' 250 12 3456 ',
  '899123456',
];

final invalidLengthSSNs = [
  '12345678',
  '1234567890',
  '123-45-678',
  '123-45-67890',
];

final invalidComponentSSNs = [
  '111111111',
  '123123123',
  '078-05-1120',
  '000-12-3456',
  '666-12-3456',
  '900-12-3456',
  '123-00-4567',
  '123-45-67A9',
];

void main() {
  for (var ssn in validSSNs) {
    test('ssn valid $ssn', () async {
      final isValid = US_SSN().isValid(ssn);
      expect(isValid, true);
    });
  }

  for (var ssn in invalidLengthSSNs) {
    test('ssn invalid length $ssn', () async {
      isValid() => US_SSN().validate(ssn);
      expect(isValid, throwsA(isA<InvalidLength>()));
    });
  }

  for (var ssn in invalidComponentSSNs) {
    test('ssn invalid component $ssn', () async {
      isValid() => US_SSN().validate(ssn);
      expect(isValid, throwsA(isA<InvalidComponent>()));
    });
  }

  test('ssn compact', () async {
    final compacted = US_SSN().compact(' 123-45-6789 ');
    expect(compacted, '123456789');
  });

  test('ssn format', () async {
    final formatted = US_SSN().format('123456789');
    expect(formatted, '123-45-6789');
  });
}
