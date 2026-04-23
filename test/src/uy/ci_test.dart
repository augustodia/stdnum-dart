import 'package:stdnum_dart/src/countries/uy/ci.dart';
import 'package:stdnum_dart/src/exceptions.dart';
import 'package:test/test.dart';

String _calculateCheckDigit(String front) {
  final weights = [2, 9, 8, 7, 6, 3, 4];

  var sum = 0;
  for (var index = 0; index < front.length; index++) {
    sum = (sum + int.parse(front[index]) * weights[index]) % 10;
  }

  return '${(10 - sum) % 10}';
}

String _buildCI(String front) {
  return '$front${_calculateCheckDigit(front)}';
}

String _withInvalidChecksum(String ci) {
  final current = ci.substring(7, 8);
  final invalid = current == '0' ? '1' : '0';
  return '${ci.substring(0, 7)}$invalid';
}

final generatedCIs = [
  _buildCI('1234567'),
  _buildCI('7654321'),
  _buildCI('1000000'),
  _buildCI('9999999'),
];

final validCIs = [
  generatedCIs[0],
  '${generatedCIs[1].substring(0, 1)}.${generatedCIs[1].substring(1, 4)}.${generatedCIs[1].substring(4, 7)}-${generatedCIs[1].substring(7, 8)}',
  ' ${generatedCIs[2].substring(0, 1)}-${generatedCIs[2].substring(1, 4)}-${generatedCIs[2].substring(4, 7)}/${generatedCIs[2].substring(7, 8)} ',
  generatedCIs[3],
];

final invalidChecksumCIs = [
  _withInvalidChecksum(generatedCIs[0]),
  _withInvalidChecksum(generatedCIs[1]),
  _withInvalidChecksum(generatedCIs[2]),
  _withInvalidChecksum(generatedCIs[3]),
];

final invalidLengthCIs = ['1234567', '123456789', '1.234.56-7', '12.345.678-9'];

final invalidFormatCIs = ['12A45678', '1.23B.567-8', 'ABC45678', '1234_678'];

void main() {
  for (var ci in validCIs) {
    test('ci valid $ci', () async {
      final isValid = UY_CI().isValid(ci);
      expect(isValid, true);
    });
  }

  for (var ci in invalidChecksumCIs) {
    test('ci invalid checksum $ci', () async {
      isValid() => UY_CI().validate(ci);
      expect(isValid, throwsA(isA<InvalidChecksum>()));
    });
  }

  for (var ci in invalidLengthCIs) {
    test('ci invalid length $ci', () async {
      isValid() => UY_CI().validate(ci);
      expect(isValid, throwsA(isA<InvalidLength>()));
    });
  }

  for (var ci in invalidFormatCIs) {
    test('ci invalid format $ci', () async {
      isValid() => UY_CI().validate(ci);
      expect(isValid, throwsA(isA<InvalidFormat>()));
    });
  }

  test('ci compact', () async {
    final compacted = UY_CI().compact(' 1.234.567-8 ');
    expect(compacted, '12345678');
  });

  test('ci format', () async {
    final formatted = UY_CI().format(generatedCIs[0]);
    expect(
      formatted,
      '${generatedCIs[0].substring(0, 1)}.${generatedCIs[0].substring(1, 4)}.${generatedCIs[0].substring(4, 7)}-${generatedCIs[0].substring(7, 8)}',
    );
  });
}
