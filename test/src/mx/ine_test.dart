import 'package:stdnum_dart/src/countries/mx/ine.dart';
import 'package:stdnum_dart/src/exceptions.dart';
import 'package:test/test.dart';

final validINEs = [
  '156885641',
  '3614093418420',
  'VRFNRL96070621H100',
  '120217281:1552098405385:D',
  '156885641:3614093418420:H',
  'GMVLMR80070501M100',
  'VRFNRL96070621H100:08:123456789:A',
  ' vrfnrl96070621h100:08:123456789:a ',
];

final invalidLengthINEs = [''];

final invalidFormatINEs = [
  '120217281::D',
  'VRFNRL96070621H100:08',
  'A:B:C:D:E',
];

final invalidComponentINEs = [
  '12A885641',
  'VRFNRL99133221H100',
  'VRFNRL96070621X100',
  '120217281:1552098405385:Z',
  'VRFNRL96070621H100:8:123456789:A',
  'VRFNRL96070621H100:08:ABC123456:A',
  'VRFNRL96070621H100:08:123456789:H',
];

void main() {
  for (var ine in validINEs) {
    test('ine valid $ine', () async {
      final isValid = MX_INE().isValid(ine);
      expect(isValid, true);
    });
  }

  for (var ine in invalidLengthINEs) {
    test('ine invalid length $ine', () async {
      isValid() => MX_INE().validate(ine);
      expect(isValid, throwsA(isA<InvalidLength>()));
    });
  }

  for (var ine in invalidFormatINEs) {
    test('ine invalid format $ine', () async {
      isValid() => MX_INE().validate(ine);
      expect(isValid, throwsA(isA<InvalidFormat>()));
    });
  }

  for (var ine in invalidComponentINEs) {
    test('ine invalid component $ine', () async {
      isValid() => MX_INE().validate(ine);
      expect(isValid, throwsA(isA<InvalidComponent>()));
    });
  }

  test('ine compact', () async {
    final compacted = MX_INE().compact(' 120217281 : 1552098405385 : d ');
    expect(compacted, '120217281:1552098405385:D');
  });

  test('ine format', () async {
    final formattedSimple = MX_INE().format(' vrfnrl96070621h100 ');
    final formattedComposite = MX_INE().format('120217281:1552098405385:d');

    expect(formattedSimple, 'VRFNRL96070621H100');
    expect(formattedComposite, '120217281:1552098405385:D');
  });
}
