import 'package:stdnum_dart/src/countries/pu/ruc.dart';
import 'package:stdnum_dart/src/exceptions.dart';
import 'package:test/test.dart';

String _calculateCheckDigit(String front) {
  final weights = [5, 4, 3, 2, 7, 6, 5, 4, 3, 2];

  var sum = 0;
  for (var index = 0; index < front.length; index++) {
    sum = (sum + int.parse(front[index]) * weights[index]) % 11;
  }

  return '${(11 - sum) % 10}';
}

String _buildRUC(String prefix, String body) {
  final front = '$prefix$body';
  return '$front${_calculateCheckDigit(front)}';
}

String _withInvalidChecksum(String ruc) {
  final current = ruc.substring(10, 11);
  final invalid = current == '0' ? '1' : '0';
  return '${ruc.substring(0, 10)}$invalid';
}

final generatedRUCs = [
  _buildRUC('10', '12345678'),
  _buildRUC('15', '00000001'),
  _buildRUC('16', '87654321'),
  _buildRUC('17', '13579135'),
  _buildRUC('20', '24680246'),
];

final validRUCs = [
  generatedRUCs[0],
  '${generatedRUCs[1].substring(0, 2)}-${generatedRUCs[1].substring(2)}',
  ' ${generatedRUCs[2]} ',
  '${generatedRUCs[3].substring(0, 2)} ${generatedRUCs[3].substring(2)}',
  generatedRUCs[4],
];

final invalidChecksumRUCs = [
  _withInvalidChecksum(generatedRUCs[0]),
  _withInvalidChecksum(generatedRUCs[1]),
  _withInvalidChecksum(generatedRUCs[2]),
];

final invalidLengthRUCs = [
  '1012345678',
  '101234567890',
  '10-1234567',
  '10-1234567890',
];

final invalidFormatRUCs = [
  '10A23456781',
  '1012345678A',
  '10_12345678',
  'ABCDEFGHIJK',
];

final invalidComponentRUCs = [
  '11123456789',
  '14123456789',
  '18123456789',
  '99123456789',
];

void main() {
  for (var ruc in validRUCs) {
    test('ruc valid $ruc', () async {
      final isValid = PU_RUC().isValid(ruc);
      expect(isValid, true);
    });
  }

  for (var ruc in invalidChecksumRUCs) {
    test('ruc invalid checksum $ruc', () async {
      isValid() => PU_RUC().validate(ruc);
      expect(isValid, throwsA(isA<InvalidChecksum>()));
    });
  }

  for (var ruc in invalidLengthRUCs) {
    test('ruc invalid length $ruc', () async {
      isValid() => PU_RUC().validate(ruc);
      expect(isValid, throwsA(isA<InvalidLength>()));
    });
  }

  for (var ruc in invalidFormatRUCs) {
    test('ruc invalid format $ruc', () async {
      isValid() => PU_RUC().validate(ruc);
      expect(isValid, throwsA(isA<InvalidFormat>()));
    });
  }

  for (var ruc in invalidComponentRUCs) {
    test('ruc invalid component $ruc', () async {
      isValid() => PU_RUC().validate(ruc);
      expect(isValid, throwsA(isA<InvalidComponent>()));
    });
  }

  test('ruc compact', () async {
    final compacted = PU_RUC().compact(' 10-123456789 ');
    expect(compacted, '10123456789');
  });

  test('ruc format', () async {
    final formatted = PU_RUC().format('10-123456789');
    expect(formatted, '10123456789');
  });
}
