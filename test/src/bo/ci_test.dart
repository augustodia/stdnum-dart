import 'package:stdnum_dart/src/countries/bo/ci.dart';
import 'package:stdnum_dart/src/exceptions.dart';
import 'package:test/test.dart';

final validCIs = [
  '1234567LP',
  '12345678-SC',
  ' 7654321.CB.A1 ',
  '12345678-tj-9',
];

final invalidLengthCIs = ['123456LP', '123456789LP', '1234567', '12345678'];

final invalidFormatCIs = [
  '1234567L1',
  '1234567LPABC',
  '1234567_LP',
  'ABCDEFGHLP',
];

final invalidComponentCIs = ['1234567XX', '12345678AA', '7654321SP'];

void main() {
  for (var ci in validCIs) {
    test('ci valid $ci', () async {
      final isValid = BO_CI().isValid(ci);
      expect(isValid, true);
    });
  }

  for (var ci in invalidLengthCIs) {
    test('ci invalid length $ci', () async {
      isValid() => BO_CI().validate(ci);
      expect(isValid, throwsA(isA<InvalidLength>()));
    });
  }

  for (var ci in invalidFormatCIs) {
    test('ci invalid format $ci', () async {
      isValid() => BO_CI().validate(ci);
      expect(isValid, throwsA(isA<InvalidFormat>()));
    });
  }

  for (var ci in invalidComponentCIs) {
    test('ci invalid component $ci', () async {
      isValid() => BO_CI().validate(ci);
      expect(isValid, throwsA(isA<InvalidComponent>()));
    });
  }

  test('ci compact', () async {
    final compacted = BO_CI().compact(' 1234567-lp.a1 ');
    expect(compacted, '1234567LPA1');
  });

  test('ci format without extension', () async {
    final formatted = BO_CI().format('12345678sc');
    expect(formatted, '12345678-SC');
  });

  test('ci format with extension', () async {
    final formatted = BO_CI().format('1234567lpA1');
    expect(formatted, '1234567-LP-A1');
  });
}
