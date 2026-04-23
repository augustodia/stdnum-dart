import 'package:stdnum_dart/src/countries/pt/cc.dart';
import 'package:stdnum_dart/src/exceptions.dart';
import 'package:test/test.dart';

const String _alphabet = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';

bool _luhnChecksumValidate(String value) {
  final parity = value.length % 2;
  var sum = 0;

  for (var index = 0; index < value.length; index++) {
    var digit = _alphabet.indexOf(value[index]);
    if (index % 2 == parity) {
      digit *= 2;
      if (digit > 9) {
        digit -= 9;
      }
    }
    sum += digit;
  }

  return sum % 10 == 0;
}

String _buildCC(String front) {
  for (var digit = 0; digit <= 9; digit++) {
    final cc = '$front$digit';
    if (_luhnChecksumValidate(cc)) {
      return cc;
    }
  }

  throw StateError('Unable to generate valid CC');
}

String _withInvalidChecksum(String cc) {
  final current = cc.substring(11, 12);
  final invalid = current == '0' ? '1' : '0';
  return '${cc.substring(0, 11)}$invalid';
}

String _formatCC(String cc) {
  return '${cc.substring(0, 8)} ${cc.substring(8, 9)} ${cc.substring(9, 12)}';
}

final generatedCCs = [
  _buildCC('123456789AB'),
  _buildCC('000000001ZZ'),
  _buildCC('98765432100'),
  _buildCC('135791357A1'),
];

final validCCs = [
  generatedCCs[0],
  _formatCC(generatedCCs[1]),
  ' ${generatedCCs[2]} ',
  generatedCCs[3].toLowerCase(),
];

final invalidChecksumCCs = [
  _withInvalidChecksum(generatedCCs[0]),
  _withInvalidChecksum(generatedCCs[1]),
  _withInvalidChecksum(generatedCCs[2]),
];

final invalidLengthCCs = ['12345678AB0', '123456789AB00', '12345678 A 0'];

final invalidFormatCCs = [
  '12345678AAB0',
  '123456789A@0',
  '123456789ABC',
  'ABCDEFGHIAB0',
];

void main() {
  for (var cc in validCCs) {
    test('cc valid $cc', () async {
      final isValid = PT_CC().isValid(cc);
      expect(isValid, true);
    });
  }

  for (var cc in invalidChecksumCCs) {
    test('cc invalid checksum $cc', () async {
      isValid() => PT_CC().validate(cc);
      expect(isValid, throwsA(isA<InvalidChecksum>()));
    });
  }

  for (var cc in invalidLengthCCs) {
    test('cc invalid length $cc', () async {
      isValid() => PT_CC().validate(cc);
      expect(isValid, throwsA(isA<InvalidLength>()));
    });
  }

  for (var cc in invalidFormatCCs) {
    test('cc invalid format $cc', () async {
      isValid() => PT_CC().validate(cc);
      expect(isValid, throwsA(isA<InvalidFormat>()));
    });
  }

  test('cc compact', () async {
    final compacted = PT_CC().compact(' 12345678 a b0 ');
    expect(compacted, '12345678AB0');
  });

  test('cc format', () async {
    final formatted = PT_CC().format(generatedCCs[0]);
    expect(formatted, _formatCC(generatedCCs[0]));
  });
}
