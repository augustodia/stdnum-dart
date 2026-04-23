import 'package:stdnum_dart/src/countries/mx/rfc.dart';
import 'package:stdnum_dart/src/exceptions.dart';
import 'package:test/test.dart';

final validRFCs = [
  'GODE561231GR8',
  'GODE 561231 GR8',
  'MAB9307148T4',
  'MAB-930714-8T4',
  'MHTR93041179A',
  'Ñ&T130705MD6',
  'SALC7304253S0',
  'RET130705MD5',
  'COMG600703',
  'SOTO800101110',
  '  mhtr-93041179a  ',
  'COMG-600703',
];

final invalidChecksumRFCs = [
  'VACE460910SX6',
  'MAB9307148T0',
  'MHTR930411790',
  'SOTO800101111',
  'RET130705MD0',
  'VACE-460910-SX6',
];

final invalidLengthRFCs = [
  'GODE561231G',
  'GODE561231GR88',
  'MAB9307148T',
  'COMG60070',
];

final invalidComponentRFCs = [
  'CACA800101ABC',
  'GODE991332GR8',
  'ABCD56123AGR8',
  'GODE561231GR!',
  'AB1561231GR8',
];

void main() {
  for (var rfc in validRFCs) {
    test('rfc valid $rfc', () async {
      final isValid = MX_RFC().isValid(rfc);
      expect(isValid, true);
    });
  }

  for (var rfc in invalidChecksumRFCs) {
    test('rfc invalid checksum $rfc', () async {
      isValid() => MX_RFC().validate(rfc);
      expect(isValid, throwsA(isA<InvalidChecksum>()));
    });
  }

  for (var rfc in invalidLengthRFCs) {
    test('rfc invalid length $rfc', () async {
      isValid() => MX_RFC().validate(rfc);
      expect(isValid, throwsA(isA<InvalidLength>()));
    });
  }

  for (var rfc in invalidComponentRFCs) {
    test('rfc invalid component $rfc', () async {
      isValid() => MX_RFC().validate(rfc);
      expect(isValid, throwsA(isA<InvalidComponent>()));
    });
  }

  test('rfc compact', () async {
    final compacted = MX_RFC().compact('  mhtr-93041179a  ');
    expect(compacted, 'MHTR93041179A');
  });

  test('rfc format person and company', () async {
    final person = MX_RFC().format('GODE561231GR8');
    final company = MX_RFC().format('MAB9307148T4');
    final shortPerson = MX_RFC().format('COMG600703');

    expect(person, 'GODE 561231 GR8');
    expect(company, 'MAB 930714 8T4');
    expect(shortPerson, 'COMG 600703');
  });
}
