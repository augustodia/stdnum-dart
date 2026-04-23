import 'package:stdnum_dart/src/countries/es/dni.dart';
import 'package:stdnum_dart/src/countries/es/nif.dart';
import 'package:stdnum_dart/src/exceptions.dart';
import 'package:test/test.dart';

String _buildDNI(String body) {
  return '$body${ES_DNI.calcCheckDigit(body)}';
}

String _buildNIE(String prefix, String body) {
  const prefixes = 'XYZ';
  final digit = ES_DNI.calcCheckDigit('${prefixes.indexOf(prefix)}$body');
  return '$prefix$body$digit';
}

int _luhnChecksumValue(String value) {
  final digits = value.split('').reversed.map((d) => int.parse(d)).toList();

  var sum = 0;
  for (var index = 0; index < digits.length; index++) {
    final digit = digits[index];
    if (index.isEven) {
      sum = (sum + digit) % 10;
    } else {
      final doubled = digit * 2;
      sum = (sum + (doubled ~/ 10) + (doubled % 10)) % 10;
    }
  }

  return sum;
}

String _buildCIF(String prefix, String body, {bool letter = false}) {
  const letterCheckDigits = 'JABCDEFGHI';
  final checksum = (10 - _luhnChecksumValue('${body}0')) % 10;
  final check = letter ? letterCheckDigits[checksum] : '$checksum';
  return '$prefix$body$check';
}

final validNIFs = [
  _buildDNI('12345678'),
  'ES-${_buildDNI('00000001')}',
  _buildNIE('X', '2482300'),
  _buildNIE('Y', '1234567'),
  _buildNIE('Z', '7654321'),
  'K1234567${ES_DNI.calcCheckDigit('1234567')}',
  _buildCIF('B', '8667046'),
  _buildCIF('Q', '2876031', letter: true),
  'ES.${_buildCIF('N', '0112768', letter: true)}',
];

final invalidChecksumNIFs = [
  '12345678A',
  'X2482300A',
  'K1234567A',
  'B86670461',
];

final invalidLengthNIFs = [
  '12345678',
  '1234567890',
  'ES12345678',
  'B866704601',
];

final invalidComponentNIFs = [
  'A1234567Z',
  'O1234567L',
  'X12345A7L',
  'B8667046X',
];

void main() {
  for (var nif in validNIFs) {
    test('nif valid $nif', () async {
      final isValid = ES_NIF().isValid(nif);
      expect(isValid, true);
    });
  }

  for (var nif in invalidChecksumNIFs) {
    test('nif invalid checksum $nif', () async {
      isValid() => ES_NIF().validate(nif);
      expect(isValid, throwsA(isA<InvalidChecksum>()));
    });
  }

  for (var nif in invalidLengthNIFs) {
    test('nif invalid length $nif', () async {
      isValid() => ES_NIF().validate(nif);
      expect(isValid, throwsA(isA<InvalidLength>()));
    });
  }

  for (var nif in invalidComponentNIFs) {
    test('nif invalid component $nif', () async {
      isValid() => ES_NIF().validate(nif);
      expect(isValid, throwsA(isA<InvalidComponent>()));
    });
  }

  test('nif compact', () async {
    final compacted = ES_NIF().compact(' ES-X-2482300-W ');
    expect(compacted, 'X2482300W');
  });

  test('nif format', () async {
    final formatted = ES_NIF().format('x2482300w');
    expect(formatted, 'X-2482300W');
  });
}
