import 'package:stdnum_dart/src/countries/br/cnpj.dart';
import 'package:stdnum_dart/src/exceptions.dart';
import 'package:test/test.dart';

String _calculateCheckDigit(String value, List<int> weights) {
  final sum = weights
      .asMap()
      .entries
      .map((entry) => (value[entry.key].codeUnitAt(0) - 48) * entry.value)
      .reduce((a, b) => a + b);
  final remainder = sum % 11;

  return '${remainder <= 1 ? 0 : 11 - remainder}';
}

String _buildCNPJ(String body) {
  final firstDigit = _calculateCheckDigit(body, [
    5,
    4,
    3,
    2,
    9,
    8,
    7,
    6,
    5,
    4,
    3,
    2,
  ]);
  final secondDigit = _calculateCheckDigit('$body$firstDigit', [
    6,
    5,
    4,
    3,
    2,
    9,
    8,
    7,
    6,
    5,
    4,
    3,
    2,
  ]);

  return '$body$firstDigit$secondDigit';
}

String _formatCNPJ(String cnpj) {
  return '${cnpj.substring(0, 2)}.${cnpj.substring(2, 5)}.${cnpj.substring(5, 8)}/${cnpj.substring(8, 12)}-${cnpj.substring(12, 14)}';
}

final generatedAlphanumericCNPJ = _buildCNPJ('ABCDEF123456');

final validCNPJs = [
  '27.964.657/0001-25',
  '85.060.965/0001-22',
  '20.060.005/0001-17',
  '12.ABC.345/01DE-35',
  '12.abc.345/01de-35',
  _formatCNPJ(generatedAlphanumericCNPJ),
];
final invalidCNPJs = [
  '27.964.657/0001-00',
  '27.964.657/0001-10',
  '85.060.965/0001-12',
  '20.060.005/0001-77',
  '12.ABC.345/01DE-00',
  _formatCNPJ('${generatedAlphanumericCNPJ.substring(0, 12)}00'),
];
final invalidLengthCNPJs = [
  '12.456.78',
  '12.456.789',
  '12.456.789/0000',
  '12.456.789/00000',
  '12.ABC.345/01DE-3',
  '12.ABC.345/01DE-355',
];
final invalidFormatCNPJs = [
  '12.ABC.345/01DE-3A',
  '12.ABC.345/01D_-35',
  '12.ABC.345/01DÉ-35',
  '12.ABC.345/01DE-AA',
];
void main() {
  for (var cnpj in validCNPJs) {
    test('cnpj valid $cnpj', () async {
      final isValid = BR_CNPJ().isValid(cnpj);
      expect(isValid, true);
    });
  }

  for (var cnpj in invalidCNPJs) {
    test('cnpj invalid $cnpj', () async {
      isValid() => BR_CNPJ().validate(cnpj);
      expect(isValid, throwsA(isA<InvalidChecksum>()));
    });
  }

  for (var cnpj in invalidLengthCNPJs) {
    test('cnpj invalid length $cnpj', () async {
      isValid() => BR_CNPJ().validate(cnpj);
      expect(isValid, throwsA(isA<InvalidLength>()));
    });
  }

  for (var cnpj in invalidFormatCNPJs) {
    test('cnpj invalid format $cnpj', () async {
      isValid() => BR_CNPJ().validate(cnpj);
      expect(isValid, throwsA(isA<InvalidFormat>()));
    });
  }

  test('cnpj compact alphanumeric', () async {
    final compacted = BR_CNPJ().compact('12.abc.345/01de-35');
    expect(compacted, '12ABC34501DE35');
  });

  test('cnpj format alphanumeric', () async {
    final formatted = BR_CNPJ().format('12abc34501de35');
    expect(formatted, '12.ABC.345/01DE-35');
  });
}
