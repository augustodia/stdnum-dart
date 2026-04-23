import 'package:stdnum_dart/src/countries/ec/ruc.dart';
import 'package:stdnum_dart/src/exceptions.dart';
import 'package:test/test.dart';

String _calculateCICheckDigit(String front) {
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
  return '$front${_calculateCICheckDigit(front)}';
}

String _calculateWeightedCheckDigit(String front, List<int> weights) {
  var sum = 0;
  for (var index = 0; index < front.length; index++) {
    sum = (sum + int.parse(front[index]) * weights[index]) % 11;
  }

  return '${(-sum) % 11}';
}

String _buildPublicRUC(String frontWithoutCheck, String establishment) {
  final check = _calculateWeightedCheckDigit(frontWithoutCheck, [
    3,
    2,
    7,
    6,
    5,
    4,
    3,
    2,
  ]);
  return '$frontWithoutCheck$check$establishment';
}

String _buildJuridicalRUC(String frontWithoutCheck, String establishment) {
  final check = _calculateWeightedCheckDigit(frontWithoutCheck, [
    4,
    3,
    2,
    7,
    6,
    5,
    4,
    3,
    2,
  ]);
  return '$frontWithoutCheck$check$establishment';
}

String _formatRUC(String ruc) {
  return '${ruc.substring(0, 10)}-${ruc.substring(10, 13)}';
}

String _withInvalidNaturalChecksum(String ruc) {
  final current = ruc.substring(9, 10);
  final invalid = current == '0' ? '1' : '0';
  return '${ruc.substring(0, 9)}$invalid${ruc.substring(10, 13)}';
}

String _withInvalidPublicChecksum(String ruc) {
  for (var digit = 0; digit <= 9; digit++) {
    final candidate = '${ruc.substring(0, 8)}$digit${ruc.substring(9, 13)}';
    if (candidate != ruc && !EC_RUC().isValid(candidate)) {
      return candidate;
    }
  }

  throw StateError('Unable to generate invalid public RUC');
}

String _withInvalidJuridicalChecksum(String ruc) {
  final current = ruc.substring(9, 10);
  final invalid = current == '0' ? '1' : '0';
  return '${ruc.substring(0, 9)}$invalid${ruc.substring(10, 13)}';
}

final naturalRUC = '${_buildCI('010203040')}001';
final publicRUC = _buildPublicRUC('01612345', '0001');
final juridicalRUC = _buildJuridicalRUC('019123456', '001');
final naturalThirdSixRUC = '${_buildCI('016203040')}001';

final validRUCs = [
  naturalRUC,
  _formatRUC(publicRUC),
  ' $juridicalRUC ',
  '${naturalThirdSixRUC.substring(0, 10)}.${naturalThirdSixRUC.substring(10)}',
];

final invalidChecksumRUCs = [
  _withInvalidNaturalChecksum(naturalRUC),
  _withInvalidPublicChecksum(publicRUC),
  _withInvalidJuridicalChecksum(juridicalRUC),
];

final invalidLengthRUCs = [
  '010203040100',
  '01020304010011',
  '0102030401-',
  '0102030401-0011',
];

final invalidFormatRUCs = ['010203040A001', '0102030401_01', 'ABCDEFGHIJKLM'];

final invalidComponentRUCs = [
  '2502030401001',
  '${_buildCI('010203040')}000',
  '${publicRUC.substring(0, 9)}0000',
  '${juridicalRUC.substring(0, 10)}000',
  '0172030401001',
];

void main() {
  for (var ruc in validRUCs) {
    test('ruc valid $ruc', () async {
      final isValid = EC_RUC().isValid(ruc);
      expect(isValid, true);
    });
  }

  for (var ruc in invalidChecksumRUCs) {
    test('ruc invalid checksum $ruc', () async {
      isValid() => EC_RUC().validate(ruc);
      expect(isValid, throwsA(isA<InvalidChecksum>()));
    });
  }

  for (var ruc in invalidLengthRUCs) {
    test('ruc invalid length $ruc', () async {
      isValid() => EC_RUC().validate(ruc);
      expect(isValid, throwsA(isA<InvalidLength>()));
    });
  }

  for (var ruc in invalidFormatRUCs) {
    test('ruc invalid format $ruc', () async {
      isValid() => EC_RUC().validate(ruc);
      expect(isValid, throwsA(isA<InvalidFormat>()));
    });
  }

  for (var ruc in invalidComponentRUCs) {
    test('ruc invalid component $ruc', () async {
      isValid() => EC_RUC().validate(ruc);
      expect(isValid, throwsA(isA<InvalidComponent>()));
    });
  }

  test('ruc compact', () async {
    final compacted = EC_RUC().compact(' 0102030401-001 ');
    expect(compacted, '0102030401001');
  });

  test('ruc format', () async {
    final formatted = EC_RUC().format(naturalRUC);
    expect(formatted, _formatRUC(naturalRUC));
  });
}
