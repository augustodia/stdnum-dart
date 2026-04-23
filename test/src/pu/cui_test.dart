import 'package:stdnum_dart/src/countries/pu/cui.dart';
import 'package:stdnum_dart/src/exceptions.dart';
import 'package:test/test.dart';

String _calculateCheckDigit(String front) {
  final weights = [3, 2, 7, 6, 5, 4, 3, 2];
  const digitMap = '65432110987';

  var sum = 0;
  for (var index = 0; index < front.length; index++) {
    sum = (sum + int.parse(front[index]) * weights[index]) % 11;
  }

  return digitMap[sum];
}

String _buildCUI(String front) {
  return '$front${_calculateCheckDigit(front)}';
}

String _withInvalidChecksum(String cui) {
  final current = cui.substring(8, 9);
  final invalid = current == '0' ? '1' : '0';
  return '${cui.substring(0, 8)}$invalid';
}

final generatedCUIs = [
  _buildCUI('12345678'),
  _buildCUI('00000001'),
  _buildCUI('87654321'),
];

final validCUIs = [
  '12345678',
  generatedCUIs[0],
  '${generatedCUIs[1].substring(0, 8)}-${generatedCUIs[1].substring(8, 9)}',
  ' ${generatedCUIs[2]} ',
];

final invalidChecksumCUIs = [
  _withInvalidChecksum(generatedCUIs[0]),
  _withInvalidChecksum(generatedCUIs[1]),
  _withInvalidChecksum(generatedCUIs[2]),
];

final invalidLengthCUIs = ['1234567', '1234567890', '123456-', '12-34567890'];

final invalidFormatCUIs = ['1234567A', '12345678A', 'ABC45678', '1234_678'];

void main() {
  for (var cui in validCUIs) {
    test('cui valid $cui', () async {
      final isValid = PU_CUI().isValid(cui);
      expect(isValid, true);
    });
  }

  for (var cui in invalidChecksumCUIs) {
    test('cui invalid checksum $cui', () async {
      isValid() => PU_CUI().validate(cui);
      expect(isValid, throwsA(isA<InvalidChecksum>()));
    });
  }

  for (var cui in invalidLengthCUIs) {
    test('cui invalid length $cui', () async {
      isValid() => PU_CUI().validate(cui);
      expect(isValid, throwsA(isA<InvalidLength>()));
    });
  }

  for (var cui in invalidFormatCUIs) {
    test('cui invalid format $cui', () async {
      isValid() => PU_CUI().validate(cui);
      expect(isValid, throwsA(isA<InvalidFormat>()));
    });
  }

  test('cui compact', () async {
    final compacted = PU_CUI().compact(' 12345678-9 ');
    expect(compacted, '123456789');
  });

  test('cui format', () async {
    final formattedWithDigit = PU_CUI().format(generatedCUIs[0]);
    final formattedWithoutDigit = PU_CUI().format('12345678');

    expect(
      formattedWithDigit,
      '${generatedCUIs[0].substring(0, 8)}-${generatedCUIs[0].substring(8, 9)}',
    );
    expect(formattedWithoutDigit, '12345678');
  });
}
