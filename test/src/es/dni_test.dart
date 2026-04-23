import 'package:stdnum_dart/src/countries/es/dni.dart';
import 'package:stdnum_dart/src/exceptions.dart';
import 'package:test/test.dart';

String _buildDNI(String body) {
  return '$body${ES_DNI.calcCheckDigit(body)}';
}

final validDNIs = [
  _buildDNI('12345678'),
  '${_buildDNI('00000001').substring(0, 8)}-${_buildDNI('00000001').substring(8, 9)}',
  ' ${_buildDNI('87654321')} ',
  'K1234567A',
  'L1234567B',
  'M1234567C',
];

final invalidChecksumDNIs = ['12345678A', '00000001A', '87654321A'];

final invalidLengthDNIs = [
  '12345678',
  '1234567890',
  '1234567-A',
  '123456789-0',
];

final invalidComponentDNIs = [
  '1234567XA',
  'A2345678B',
  'X1234567L',
  'ABCDEFGHL',
];

void main() {
  for (var dni in validDNIs) {
    test('dni valid $dni', () async {
      final isValid = ES_DNI().isValid(dni);
      expect(isValid, true);
    });
  }

  for (var dni in invalidChecksumDNIs) {
    test('dni invalid checksum $dni', () async {
      isValid() => ES_DNI().validate(dni);
      expect(isValid, throwsA(isA<InvalidChecksum>()));
    });
  }

  for (var dni in invalidLengthDNIs) {
    test('dni invalid length $dni', () async {
      isValid() => ES_DNI().validate(dni);
      expect(isValid, throwsA(isA<InvalidLength>()));
    });
  }

  for (var dni in invalidComponentDNIs) {
    test('dni invalid component $dni', () async {
      isValid() => ES_DNI().validate(dni);
      expect(isValid, throwsA(isA<InvalidComponent>()));
    });
  }

  test('dni compact', () async {
    final compacted = ES_DNI().compact(' 12345678-z ');
    expect(compacted, '12345678Z');
  });

  test('dni format', () async {
    final formatted = ES_DNI().format(_buildDNI('12345678'));
    expect(
      formatted,
      '${_buildDNI('12345678').substring(0, 8)}-${_buildDNI('12345678').substring(8, 9)}',
    );
  });
}
