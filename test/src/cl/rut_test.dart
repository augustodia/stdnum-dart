import 'package:stdnum_dart/src/countries/cl/rut.dart';
import 'package:stdnum_dart/src/exceptions.dart';
import 'package:test/test.dart';

final validRUTs = [
  '12345678-5',
  '76086428-5',
  '60803000-k',
  'CL12345678-5',
  '1 234 567-4',
  '22222222-2',
];

final invalidChecksumRUTs = [
  '12345678-9',
  '76086428-K',
  '60803000-1',
  '22222222-0',
];

final invalidLengthRUTs = ['1234567', '1234567890', 'CL123456', '12.345.678-5'];

final invalidComponentRUTs = [
  '12A45678-5',
  '1234.567-4',
  'ABC45678-5',
  'AB123456-7',
];

void main() {
  for (var rut in validRUTs) {
    test('rut valid $rut', () async {
      final isValid = CL_RUT().isValid(rut);
      expect(isValid, true);
    });
  }

  for (var rut in invalidChecksumRUTs) {
    test('rut invalid checksum $rut', () async {
      isValid() => CL_RUT().validate(rut);
      expect(isValid, throwsA(isA<InvalidChecksum>()));
    });
  }

  for (var rut in invalidLengthRUTs) {
    test('rut invalid length $rut', () async {
      isValid() => CL_RUT().validate(rut);
      expect(isValid, throwsA(isA<InvalidLength>()));
    });
  }

  for (var rut in invalidComponentRUTs) {
    test('rut invalid component $rut', () async {
      isValid() => CL_RUT().validate(rut);
      expect(isValid, throwsA(isA<InvalidComponent>()));
    });
  }

  test('rut compact', () async {
    final compacted = CL_RUT().compact('CL 12345678-5');
    expect(compacted, '123456785');
  });

  test('rut format person/entity', () async {
    final full = CL_RUT().format('123456785');
    final short = CL_RUT().format('12345674');

    expect(full, '12.345.678-5');
    expect(short, '1.234.567-4');
  });
}
