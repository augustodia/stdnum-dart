// ignore_for_file: camel_case_types

import 'package:stdnum_dart/src/exceptions.dart';
import 'package:stdnum_dart/src/helpers/utils.dart';
import 'package:stdnum_dart/src/interfaces/document_interface.dart';

class US_EIN implements DocumentInterface {
  static const Set<String> _prefixes = {
    '01',
    '02',
    '03',
    '04',
    '05',
    '06',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '20',
    '21',
    '22',
    '23',
    '24',
    '25',
    '26',
    '27',
    '30',
    '31',
    '32',
    '33',
    '34',
    '35',
    '36',
    '37',
    '38',
    '39',
    '40',
    '41',
    '42',
    '43',
    '44',
    '45',
    '46',
    '47',
    '48',
    '50',
    '51',
    '52',
    '53',
    '54',
    '55',
    '56',
    '57',
    '58',
    '59',
    '60',
    '61',
    '62',
    '63',
    '64',
    '65',
    '66',
    '67',
    '68',
    '71',
    '72',
    '73',
    '74',
    '75',
    '76',
    '77',
    '80',
    '81',
    '82',
    '83',
    '84',
    '85',
    '86',
    '87',
    '88',
    '90',
    '91',
    '92',
    '93',
    '94',
    '95',
    '98',
    '99',
  };

  @override
  String compact(String ein) {
    return ein.replaceAll(RegExp(r'[- ]'), '');
  }

  @override
  String format(String ein) {
    final clearedEIN = compact(ein);
    if (clearedEIN.length != 9) {
      throw InvalidLength();
    }

    return '${clearedEIN.substring(0, 2)}-${clearedEIN.substring(2)}';
  }

  @override
  String validate(String ein) {
    final clearedEIN = compact(ein);
    if (clearedEIN.length != 9) {
      throw InvalidLength();
    }
    if (!StdnumDartUtils.isOnlyDigits(clearedEIN)) {
      throw InvalidComponent();
    }
    if (!_prefixes.contains(clearedEIN.substring(0, 2))) {
      throw InvalidComponent();
    }

    return ein;
  }

  @override
  bool isValid(String ein) {
    try {
      validate(ein);
      return true;
    } catch (e) {
      return false;
    }
  }
}
