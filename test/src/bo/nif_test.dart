import 'package:stdnum_dart/src/countries/bo/nif.dart';
import 'package:stdnum_dart/src/exceptions.dart';
import 'package:test/test.dart';

final validNIFs = [
  '301140029',
  '4746889017',
  'BO308468025',
  ' 12345 ',
  '123456789012',
];

final invalidLengthNIFs = [
  '1234',
  '1234567890123',
  'BO1234',
  'BO1234567890123',
];

final invalidFormatNIFs = ['30114002A', '1234_6789', 'ABCDEFGHI'];

void main() {
  for (var nif in validNIFs) {
    test('nif valid $nif', () async {
      final isValid = BO_NIF().isValid(nif);
      expect(isValid, true);
    });
  }

  for (var nif in invalidLengthNIFs) {
    test('nif invalid length $nif', () async {
      isValid() => BO_NIF().validate(nif);
      expect(isValid, throwsA(isA<InvalidLength>()));
    });
  }

  for (var nif in invalidFormatNIFs) {
    test('nif invalid format $nif', () async {
      isValid() => BO_NIF().validate(nif);
      expect(isValid, throwsA(isA<InvalidFormat>()));
    });
  }

  test('nif compact', () async {
    final compacted = BO_NIF().compact(' BO-301.140 029 ');
    expect(compacted, '301140029');
  });

  test('nif format', () async {
    final formatted = BO_NIF().format('BO-301.140 029');
    expect(formatted, '301140029');
  });
}
