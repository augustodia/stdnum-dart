import 'package:stdnum_dart/src/countries/uy/rut.dart';
import 'package:stdnum_dart/src/exceptions.dart';
import 'package:test/test.dart';

String _calculateCheckDigit(String front) {
  final weights = [4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];

  var sum = 0;
  for (var index = 0; index < front.length; index++) {
    sum = (sum + int.parse(front[index]) * weights[index]) % 11;
  }

  return '${(-sum) % 11}';
}

String _buildRUT(String registration, String sequence) {
  final front = '$registration${sequence}001';
  return '$front${_calculateCheckDigit(front)}';
}

String _withInvalidChecksum(String rut) {
  final current = rut.substring(11, 12);
  final invalid = current == '0' ? '1' : '0';
  return '${rut.substring(0, 11)}$invalid';
}

String _formatRUT(String rut) {
  return '${rut.substring(0, 2)}-${rut.substring(2, 8)}-${rut.substring(8, 11)}-${rut.substring(11, 12)}';
}

final generatedRUTs = [
  _buildRUT('01', '234567'),
  _buildRUT('10', '000001'),
  _buildRUT('21', '999999'),
  _buildRUT('03', '654321'),
];

final validRUTs = [
  generatedRUTs[0],
  _formatRUT(generatedRUTs[1]),
  'UY${generatedRUTs[2]}',
  ' UY-${_formatRUT(generatedRUTs[3])} ',
];

final invalidChecksumRUTs = [
  _withInvalidChecksum(generatedRUTs[0]),
  _withInvalidChecksum(generatedRUTs[1]),
  _withInvalidChecksum(generatedRUTs[2]),
  _withInvalidChecksum(generatedRUTs[3]),
];

final invalidLengthRUTs = [
  '01234567001',
  '0123456700111',
  'UY0123456700',
  '01-234567-001-99',
];

final invalidFormatRUTs = [
  '01A345670011',
  'UY01B345670011',
  '0123456_0011',
  'ABCDEFGHIJKL',
];

final invalidComponentRUTs = [
  '002345670011',
  '222345670011',
  _buildRUT('01', '000000'),
  '012345670021',
];

void main() {
  for (var rut in validRUTs) {
    test('rut valid $rut', () async {
      final isValid = UY_RUT().isValid(rut);
      expect(isValid, true);
    });
  }

  for (var rut in invalidChecksumRUTs) {
    test('rut invalid checksum $rut', () async {
      isValid() => UY_RUT().validate(rut);
      expect(isValid, throwsA(isA<InvalidChecksum>()));
    });
  }

  for (var rut in invalidLengthRUTs) {
    test('rut invalid length $rut', () async {
      isValid() => UY_RUT().validate(rut);
      expect(isValid, throwsA(isA<InvalidLength>()));
    });
  }

  for (var rut in invalidFormatRUTs) {
    test('rut invalid format $rut', () async {
      isValid() => UY_RUT().validate(rut);
      expect(isValid, throwsA(isA<InvalidFormat>()));
    });
  }

  for (var rut in invalidComponentRUTs) {
    test('rut invalid component $rut', () async {
      isValid() => UY_RUT().validate(rut);
      expect(isValid, throwsA(isA<InvalidComponent>()));
    });
  }

  test('rut compact', () async {
    final compacted = UY_RUT().compact(' UY-01-234567-001-1 ');
    expect(compacted, '012345670011');
  });

  test('rut format', () async {
    final formatted = UY_RUT().format(generatedRUTs[0]);
    expect(formatted, _formatRUT(generatedRUTs[0]));
  });
}
