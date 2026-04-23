import 'package:stdnum_dart/src/countries/py/ruc.dart';
import 'package:stdnum_dart/src/exceptions.dart';
import 'package:test/test.dart';

String _calculateCheckDigit(String front) {
  final reversedDigits =
      front.split('').reversed.map((digit) => int.parse(digit)).toList();
  final sum = reversedDigits
      .asMap()
      .entries
      .map((entry) => entry.value * (entry.key + 2))
      .reduce((a, b) => a + b);
  return '${(11 - (sum % 11)) % 10}';
}

String _buildRUC(String front) {
  final checkDigit = _calculateCheckDigit(front);
  return '$front$checkDigit';
}

String _withInvalidChecksum(String ruc) {
  final current = ruc.substring(ruc.length - 1);
  final invalid = current == '0' ? '1' : '0';
  return '${ruc.substring(0, ruc.length - 1)}$invalid';
}

final generatedRUCs = [
  _buildRUC('1234'),
  _buildRUC('1234567'),
  _buildRUC('7999999'),
  _buildRUC('80000001'),
  _buildRUC('98765432'),
];

final validRUCs = [
  generatedRUCs[0],
  generatedRUCs[1],
  '${generatedRUCs[2].substring(0, generatedRUCs[2].length - 1)}-${generatedRUCs[2].substring(generatedRUCs[2].length - 1)}',
  ' ${generatedRUCs[3]} ',
  '${generatedRUCs[4].substring(0, generatedRUCs[4].length - 1)}-${generatedRUCs[4].substring(generatedRUCs[4].length - 1)}',
];

final invalidChecksumRUCs = [
  _withInvalidChecksum(generatedRUCs[0]),
  _withInvalidChecksum(generatedRUCs[1]),
  _withInvalidChecksum(generatedRUCs[2]),
  _withInvalidChecksum(generatedRUCs[4]),
];

final invalidLengthRUCs = ['1234', '1234567890', '12-3', '123456789-0'];

final invalidComponentRUCs = ['12A45', '1234B678', 'ABC12345', '1234_5'];

void main() {
  for (var ruc in validRUCs) {
    test('ruc valid $ruc', () async {
      final isValid = PY_RUC().isValid(ruc);
      expect(isValid, true);
    });
  }

  for (var ruc in invalidChecksumRUCs) {
    test('ruc invalid checksum $ruc', () async {
      isValid() => PY_RUC().validate(ruc);
      expect(isValid, throwsA(isA<InvalidChecksum>()));
    });
  }

  for (var ruc in invalidLengthRUCs) {
    test('ruc invalid length $ruc', () async {
      isValid() => PY_RUC().validate(ruc);
      expect(isValid, throwsA(isA<InvalidLength>()));
    });
  }

  for (var ruc in invalidComponentRUCs) {
    test('ruc invalid component $ruc', () async {
      isValid() => PY_RUC().validate(ruc);
      expect(isValid, throwsA(isA<InvalidComponent>()));
    });
  }

  test('ruc compact', () async {
    final compacted = PY_RUC().compact(' 1234-5 ');
    expect(compacted, '12345');
  });

  test('ruc format', () async {
    final formatted = PY_RUC().format(generatedRUCs[3]);
    expect(
      formatted,
      '${generatedRUCs[3].substring(0, generatedRUCs[3].length - 1)}-${generatedRUCs[3].substring(generatedRUCs[3].length - 1)}',
    );
  });
}
