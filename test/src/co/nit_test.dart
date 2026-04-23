import 'package:stdnum_dart/src/countries/co/nit.dart';
import 'package:stdnum_dart/src/exceptions.dart';
import 'package:test/test.dart';

String _calculateCheckDigit(String front) {
  final weights = [3, 7, 13, 17, 19, 23, 29, 37, 41, 43, 47, 53, 59, 67, 71];
  var sum = 0;

  for (var index = 0; index < front.length; index++) {
    final weight = weights[index];
    final digit = int.parse(front[front.length - index - 1]);
    sum = (sum + digit * weight) % 11;
  }

  return '01987654321'[sum];
}

String _buildNIT(String front) {
  return '$front${_calculateCheckDigit(front)}';
}

String _withInvalidChecksum(String nit) {
  final current = nit.substring(nit.length - 1);
  final invalid = current == '0' ? '1' : '0';
  return '${nit.substring(0, nit.length - 1)}$invalid';
}

String _formatNIT(String nit) {
  return '${nit.substring(0, 3)}.${nit.substring(3, 6)}.${nit.substring(6, 9)}-${nit.substring(9)}';
}

final generatedNITs = [
  _buildNIT('900373913'),
  _buildNIT('860002964'),
  _buildNIT('1234567'),
  _buildNIT('123456789012345'),
];

final validNITs = [
  generatedNITs[0],
  _formatNIT(generatedNITs[1]),
  ' ${generatedNITs[2]} ',
  '${generatedNITs[3].substring(0, 3)},${generatedNITs[3].substring(3)}',
];

final invalidChecksumNITs = [
  _withInvalidChecksum(generatedNITs[0]),
  _withInvalidChecksum(generatedNITs[1]),
  _withInvalidChecksum(generatedNITs[2]),
];

final invalidLengthNITs = [
  '1234567',
  '12345678901234567',
  '123.456',
  '1234567890123456-1',
];

final invalidComponentNITs = ['90037391A8', '90037_9138', 'ABCDEFGHI'];

void main() {
  for (var nit in validNITs) {
    test('nit valid $nit', () async {
      final isValid = CO_NIT().isValid(nit);
      expect(isValid, true);
    });
  }

  for (var nit in invalidChecksumNITs) {
    test('nit invalid checksum $nit', () async {
      isValid() => CO_NIT().validate(nit);
      expect(isValid, throwsA(isA<InvalidChecksum>()));
    });
  }

  for (var nit in invalidLengthNITs) {
    test('nit invalid length $nit', () async {
      isValid() => CO_NIT().validate(nit);
      expect(isValid, throwsA(isA<InvalidLength>()));
    });
  }

  for (var nit in invalidComponentNITs) {
    test('nit invalid component $nit', () async {
      isValid() => CO_NIT().validate(nit);
      expect(isValid, throwsA(isA<InvalidComponent>()));
    });
  }

  test('nit compact', () async {
    final compacted = CO_NIT().compact(' 900.373.913-8 ');
    expect(compacted, '9003739138');
  });

  test('nit format long', () async {
    final formatted = CO_NIT().format(generatedNITs[0]);
    expect(formatted, _formatNIT(generatedNITs[0]));
  });

  test('nit format short', () async {
    final formatted = CO_NIT().format(generatedNITs[2]);
    expect(
      formatted,
      '${generatedNITs[2].substring(0, 7)}-${generatedNITs[2].substring(7)}',
    );
  });
}
