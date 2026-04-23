import 'package:stdnum_dart/src/countries/py/ci.dart';
import 'package:stdnum_dart/src/exceptions.dart';
import 'package:test/test.dart';

final validCIs = ['12345', '123456', '1234567', '1.234.567', ' 123-456 '];

final invalidLengthCIs = ['1234', '12345678', '12.34', '1234-5678'];

final invalidComponentCIs = ['12A45', '1234B6', 'ABC1234', '123_456'];

void main() {
  for (var ci in validCIs) {
    test('ci valid $ci', () async {
      final isValid = PY_CI().isValid(ci);
      expect(isValid, true);
    });
  }

  for (var ci in invalidLengthCIs) {
    test('ci invalid length $ci', () async {
      isValid() => PY_CI().validate(ci);
      expect(isValid, throwsA(isA<InvalidLength>()));
    });
  }

  for (var ci in invalidComponentCIs) {
    test('ci invalid component $ci', () async {
      isValid() => PY_CI().validate(ci);
      expect(isValid, throwsA(isA<InvalidComponent>()));
    });
  }

  test('ci compact', () async {
    final compacted = PY_CI().compact(' 1.234-567 ');
    expect(compacted, '1234567');
  });

  test('ci format', () async {
    final formatted = PY_CI().format(' 1.234-567 ');
    expect(formatted, '1234567');
  });
}
