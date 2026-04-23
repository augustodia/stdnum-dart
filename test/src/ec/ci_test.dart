import 'package:stdnum_dart/src/countries/ec/ci.dart';
import 'package:stdnum_dart/src/exceptions.dart';
import 'package:test/test.dart';

String _calculateCheckDigit(String front) {
  var sum = 0;

  for (var index = 0; index < front.length; index++) {
    var digit = int.parse(front[index]);
    if (index.isEven) {
      digit *= 2;
    }
    if (digit > 9) {
      digit -= 9;
    }

    sum += digit;
  }

  return '${(10 - (sum % 10)) % 10}';
}

String _buildCI(String front) {
  return '$front${_calculateCheckDigit(front)}';
}

String _withInvalidChecksum(String ci) {
  final current = ci.substring(9, 10);
  final invalid = current == '0' ? '1' : '0';
  return '${ci.substring(0, 9)}$invalid';
}

String _formatCI(String ci) {
  return '${ci.substring(0, 9)}-${ci.substring(9, 10)}';
}

final generatedCIs = [
  _buildCI('010203040'),
  _buildCI('240000001'),
  _buildCI('300123456'),
  _buildCI('506543210'),
];

final validCIs = [
  generatedCIs[0],
  _formatCI(generatedCIs[1]),
  ' ${generatedCIs[2]} ',
  '${generatedCIs[3].substring(0, 4)} ${generatedCIs[3].substring(4)}',
];

final invalidChecksumCIs = [
  _withInvalidChecksum(generatedCIs[0]),
  _withInvalidChecksum(generatedCIs[1]),
  _withInvalidChecksum(generatedCIs[2]),
];

final invalidLengthCIs = [
  '010203040',
  '01020304011',
  '01-020304',
  '010203040-11',
];

final invalidFormatCIs = ['01020304A1', '0102_30401', 'ABCDEFGHIJ'];

final invalidComponentCIs = ['2502030401', '0002030401', '0172030401'];

void main() {
  for (var ci in validCIs) {
    test('ci valid $ci', () async {
      final isValid = EC_CI().isValid(ci);
      expect(isValid, true);
    });
  }

  for (var ci in invalidChecksumCIs) {
    test('ci invalid checksum $ci', () async {
      isValid() => EC_CI().validate(ci);
      expect(isValid, throwsA(isA<InvalidChecksum>()));
    });
  }

  for (var ci in invalidLengthCIs) {
    test('ci invalid length $ci', () async {
      isValid() => EC_CI().validate(ci);
      expect(isValid, throwsA(isA<InvalidLength>()));
    });
  }

  for (var ci in invalidFormatCIs) {
    test('ci invalid format $ci', () async {
      isValid() => EC_CI().validate(ci);
      expect(isValid, throwsA(isA<InvalidFormat>()));
    });
  }

  for (var ci in invalidComponentCIs) {
    test('ci invalid component $ci', () async {
      isValid() => EC_CI().validate(ci);
      expect(isValid, throwsA(isA<InvalidComponent>()));
    });
  }

  test('ci compact', () async {
    final compacted = EC_CI().compact(' 0102-030401 ');
    expect(compacted, '0102030401');
  });

  test('ci format', () async {
    final formatted = EC_CI().format(generatedCIs[0]);
    expect(formatted, _formatCI(generatedCIs[0]));
  });
}
