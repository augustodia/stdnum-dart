import 'package:stdnum_dart/src/countries/ve/rif.dart';
import 'package:stdnum_dart/src/exceptions.dart';
import 'package:test/test.dart';

const Map<String, int> _companyTypes = {
  'V': 4,
  'E': 8,
  'J': 12,
  'P': 16,
  'G': 20,
};

String _calculateCheckDigit(String type, String body) {
  final weights = [3, 2, 7, 6, 5, 4, 3, 2];
  var sum = 0;

  for (var index = 0; index < body.length; index++) {
    sum = (sum + int.parse(body[index]) * weights[index]) % 11;
  }

  final digit = (_companyTypes[type]! + sum) % 11;
  return '00987654321'[digit];
}

String _buildRIF(String type, String body) {
  return '$type$body${_calculateCheckDigit(type, body)}';
}

String _withInvalidChecksum(String rif) {
  final current = rif.substring(9, 10);
  final invalid = current == '0' ? '1' : '0';
  return '${rif.substring(0, 9)}$invalid';
}

String _formatRIF(String rif) {
  return '${rif.substring(0, 1)}-${rif.substring(1, 9)}-${rif.substring(9, 10)}';
}

final generatedRIFs = [
  _buildRIF('V', '12345678'),
  _buildRIF('E', '00000001'),
  _buildRIF('J', '87654321'),
  _buildRIF('P', '13579135'),
  _buildRIF('G', '24680246'),
];

final validRIFs = [
  generatedRIFs[0],
  _formatRIF(generatedRIFs[1]),
  ' ${generatedRIFs[2]} ',
  generatedRIFs[3].toLowerCase(),
  generatedRIFs[4],
];

final invalidChecksumRIFs = [
  _withInvalidChecksum(generatedRIFs[0]),
  _withInvalidChecksum(generatedRIFs[1]),
  _withInvalidChecksum(generatedRIFs[2]),
];

final invalidLengthRIFs = [
  'V1234567',
  'V1234567890',
  'J-1234567-8',
  'J-123456789-0',
];

final invalidFormatRIFs = ['V1234567A0', 'J1234A6780', 'E123_56780'];

final invalidComponentRIFs = ['A123456780', 'B123456780', 'C123456780'];

void main() {
  for (var rif in validRIFs) {
    test('rif valid $rif', () async {
      final isValid = VE_RIF().isValid(rif);
      expect(isValid, true);
    });
  }

  for (var rif in invalidChecksumRIFs) {
    test('rif invalid checksum $rif', () async {
      isValid() => VE_RIF().validate(rif);
      expect(isValid, throwsA(isA<InvalidChecksum>()));
    });
  }

  for (var rif in invalidLengthRIFs) {
    test('rif invalid length $rif', () async {
      isValid() => VE_RIF().validate(rif);
      expect(isValid, throwsA(isA<InvalidLength>()));
    });
  }

  for (var rif in invalidFormatRIFs) {
    test('rif invalid format $rif', () async {
      isValid() => VE_RIF().validate(rif);
      expect(isValid, throwsA(isA<InvalidFormat>()));
    });
  }

  for (var rif in invalidComponentRIFs) {
    test('rif invalid component $rif', () async {
      isValid() => VE_RIF().validate(rif);
      expect(isValid, throwsA(isA<InvalidComponent>()));
    });
  }

  test('rif compact', () async {
    final compacted = VE_RIF().compact(' j-87654321-2 ');
    expect(compacted, 'J876543212');
  });

  test('rif format', () async {
    final formatted = VE_RIF().format(generatedRIFs[0]);
    expect(formatted, _formatRIF(generatedRIFs[0]));
  });
}
