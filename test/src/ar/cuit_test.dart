import 'package:stdnum_dart/src/countries/ar/cuit.dart';
import 'package:stdnum_dart/src/exceptions.dart';
import 'package:test/test.dart';

String _calculateCheckDigit(String value) {
  final weights = [5, 4, 3, 2, 7, 6, 5, 4, 3, 2];
  const digitMap = '012345678990';

  var sum = 0;
  for (var index = 0; index < value.length; index++) {
    sum += int.parse(value[index]) * weights[index];
  }

  final checksum = sum % 11;
  return digitMap[11 - checksum];
}

String _buildCUIT(String type, String body) {
  final frontAndBody = '$type$body';
  final digit = _calculateCheckDigit(frontAndBody);
  return '$frontAndBody$digit';
}

String _withHyphen(String cuit) {
  return '${cuit.substring(0, 2)}-${cuit.substring(2, 10)}-${cuit.substring(10, 11)}';
}

String _withInvalidChecksum(String cuit) {
  final current = cuit.substring(10, 11);
  final invalid = current == '0' ? '1' : '0';
  return '${cuit.substring(0, 10)}$invalid';
}

final generatedCUITs = [
  _buildCUIT('20', '12345678'),
  _buildCUIT('23', '98765432'),
  _buildCUIT('30', '70987561'),
  _buildCUIT('33', '00012345'),
  _buildCUIT('50', '13579135'),
];

final validCUITs = [
  _withHyphen(generatedCUITs[0]),
  generatedCUITs[1],
  '  ${_withHyphen(generatedCUITs[2])}  ',
  _withHyphen(generatedCUITs[3]),
  generatedCUITs[4],
];

final invalidChecksumCUITs = [
  _withInvalidChecksum(generatedCUITs[0]),
  _withHyphen(_withInvalidChecksum(generatedCUITs[1])),
  _withInvalidChecksum(generatedCUITs[2]),
  _withHyphen(_withInvalidChecksum(generatedCUITs[3])),
];

final invalidLengthCUITs = [
  '20-1234567-8',
  '20-123456789-0',
  '201234567',
  '201234567890',
];

final invalidFormatCUITs = [
  '20A23456786',
  '2A123456786',
  '20-1234B678-6',
  '33-00012C45-8',
];

final invalidComponentCUITs = [
  '21-12345678-6',
  '99-12345678-0',
  '10-00000000-0',
  '40-70987561-1',
];

void main() {
  for (var cuit in validCUITs) {
    test('cuit valid $cuit', () async {
      final isValid = AR_CUIT().isValid(cuit);
      expect(isValid, true);
    });
  }

  for (var cuit in invalidChecksumCUITs) {
    test('cuit invalid checksum $cuit', () async {
      isValid() => AR_CUIT().validate(cuit);
      expect(isValid, throwsA(isA<InvalidChecksum>()));
    });
  }

  for (var cuit in invalidLengthCUITs) {
    test('cuit invalid length $cuit', () async {
      isValid() => AR_CUIT().validate(cuit);
      expect(isValid, throwsA(isA<InvalidLength>()));
    });
  }

  for (var cuit in invalidFormatCUITs) {
    test('cuit invalid format $cuit', () async {
      isValid() => AR_CUIT().validate(cuit);
      expect(isValid, throwsA(isA<InvalidFormat>()));
    });
  }

  for (var cuit in invalidComponentCUITs) {
    test('cuit invalid component $cuit', () async {
      isValid() => AR_CUIT().validate(cuit);
      expect(isValid, throwsA(isA<InvalidComponent>()));
    });
  }

  test('cuit compact', () async {
    final compacted = AR_CUIT().compact(' 20-12345678-6 ');
    expect(compacted, '20123456786');
  });

  test('cuit format', () async {
    final formatted = AR_CUIT().format(generatedCUITs[0]);
    expect(formatted, _withHyphen(generatedCUITs[0]));
  });
}
