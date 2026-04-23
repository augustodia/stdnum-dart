import 'package:stdnum_dart/src/countries/pt/nif.dart';
import 'package:stdnum_dart/src/exceptions.dart';
import 'package:test/test.dart';

String _calculateCheckDigit(String front) {
  final weights = [9, 8, 7, 6, 5, 4, 3, 2, 1];

  var sum = 0;
  for (var index = 0; index < front.length; index++) {
    sum = (sum + int.parse(front[index]) * weights[index]) % 11;
  }

  return '${(11 - sum) % 11 % 10}';
}

String _buildNIF(String front) {
  return '$front${_calculateCheckDigit(front)}';
}

String _withInvalidChecksum(String nif) {
  final current = nif.substring(8, 9);
  final invalid = current == '0' ? '1' : '0';
  return '${nif.substring(0, 8)}$invalid';
}

String _formatNIF(String nif) {
  return '${nif.substring(0, 3)} ${nif.substring(3, 6)} ${nif.substring(6, 9)}';
}

final generatedNIFs = [
  _buildNIF('12345678'),
  _buildNIF('50123456'),
  _buildNIF('91234567'),
  _buildNIF('29999999'),
];

final validNIFs = [
  generatedNIFs[0],
  _formatNIF(generatedNIFs[1]),
  'PT${generatedNIFs[2]}',
  ' PT-${_formatNIF(generatedNIFs[3])} ',
];

final invalidChecksumNIFs = [
  _withInvalidChecksum(generatedNIFs[0]),
  _withInvalidChecksum(generatedNIFs[1]),
  _withInvalidChecksum(generatedNIFs[2]),
];

final invalidLengthNIFs = [
  '12345678',
  '1234567890',
  'PT1234567',
  '123-456-7890',
];

final invalidFormatNIFs = ['023456789', '1234A6789', '1234_6789', 'ABCDEFGHI'];

void main() {
  for (var nif in validNIFs) {
    test('nif valid $nif', () async {
      final isValid = PT_NIF().isValid(nif);
      expect(isValid, true);
    });
  }

  for (var nif in invalidChecksumNIFs) {
    test('nif invalid checksum $nif', () async {
      isValid() => PT_NIF().validate(nif);
      expect(isValid, throwsA(isA<InvalidChecksum>()));
    });
  }

  for (var nif in invalidLengthNIFs) {
    test('nif invalid length $nif', () async {
      isValid() => PT_NIF().validate(nif);
      expect(isValid, throwsA(isA<InvalidLength>()));
    });
  }

  for (var nif in invalidFormatNIFs) {
    test('nif invalid format $nif', () async {
      isValid() => PT_NIF().validate(nif);
      expect(isValid, throwsA(isA<InvalidFormat>()));
    });
  }

  test('nif compact', () async {
    final compacted = PT_NIF().compact(' PT-123 456.789 ');
    expect(compacted, '123456789');
  });

  test('nif format', () async {
    final formatted = PT_NIF().format(generatedNIFs[0]);
    expect(formatted, _formatNIF(generatedNIFs[0]));
  });
}
