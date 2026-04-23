import 'package:stdnum_dart/src/countries/us/ein.dart';
import 'package:stdnum_dart/src/exceptions.dart';
import 'package:test/test.dart';

final validEINs = [
  '01-1234567',
  '101234567',
  '45-9876543',
  '82 1234567',
  ' 99-0000001 ',
];

final invalidLengthEINs = [
  '01-123456',
  '01-12345678',
  '12345678',
  '1234567890',
];

final invalidComponentEINs = [
  '00-1234567',
  '07-1234567',
  '89-1234567',
  '01-12345A7',
  'AB-1234567',
];

void main() {
  for (var ein in validEINs) {
    test('ein valid $ein', () async {
      final isValid = US_EIN().isValid(ein);
      expect(isValid, true);
    });
  }

  for (var ein in invalidLengthEINs) {
    test('ein invalid length $ein', () async {
      isValid() => US_EIN().validate(ein);
      expect(isValid, throwsA(isA<InvalidLength>()));
    });
  }

  for (var ein in invalidComponentEINs) {
    test('ein invalid component $ein', () async {
      isValid() => US_EIN().validate(ein);
      expect(isValid, throwsA(isA<InvalidComponent>()));
    });
  }

  test('ein compact', () async {
    final compacted = US_EIN().compact(' 45-9876543 ');
    expect(compacted, '459876543');
  });

  test('ein format', () async {
    final formatted = US_EIN().format('459876543');
    expect(formatted, '45-9876543');
  });
}
