import 'package:stdnum_dart/src/exceptions.dart';
import 'package:stdnum_dart/src/interfaces/document_interface.dart';

class MX_INE implements DocumentInterface {
  static const Set<String> _cardModels = {
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
  };

  bool _isValidDateCompactYYMMDD(String value) {
    if (!RegExp(r'^\d{6}$').hasMatch(value)) return false;

    final year = int.parse(value.substring(0, 2));
    final month = int.parse(value.substring(2, 4));
    final day = int.parse(value.substring(4, 6));

    final fullYear = year < 20 ? 2000 + year : 1900 + year;
    final date = DateTime(fullYear, month, day);

    final isValidDate =
        date.year == fullYear && date.month == month && date.day == day;
    if (!isValidDate) return false;

    return !date.isAfter(DateTime.now());
  }

  bool _isValidElectorKey(String key) {
    final upper = key.toUpperCase();
    if (!RegExp(r'^[A-Z]{6}\d{6}\d{2}[HMN][A-Z0-9]{3}$').hasMatch(upper)) {
      return false;
    }

    final birthdate = upper.substring(6, 12);
    return _isValidDateCompactYYMMDD(birthdate);
  }

  bool _isValidCIC(String cic) {
    return RegExp(r'^\d{9}$').hasMatch(cic);
  }

  bool _isValidOCRorCitizenId(String value) {
    return RegExp(r'^\d{9,13}$').hasMatch(value);
  }

  void _validateCompositeDToH(List<String> parts) {
    if (parts.length != 3) throw InvalidFormat();
    if (parts.any((part) => part.isEmpty)) throw InvalidFormat();

    final cic = parts[0];
    final citizenIdOrOcr = parts[1];
    final model = parts[2].toUpperCase();

    if (!_cardModels.contains(model) ||
        model == 'A' ||
        model == 'B' ||
        model == 'C') {
      throw InvalidComponent();
    }
    if (!_isValidCIC(cic) || !_isValidOCRorCitizenId(citizenIdOrOcr)) {
      throw InvalidComponent();
    }
  }

  void _validateCompositeAToC(List<String> parts) {
    if (parts.length != 4) throw InvalidFormat();
    if (parts.any((part) => part.isEmpty)) throw InvalidFormat();

    final electorKey = parts[0].toUpperCase();
    final issuingNumber = parts[1];
    final ocr = parts[2];
    final model = parts[3].toUpperCase();

    if (!_cardModels.contains(model) ||
        (model != 'A' && model != 'B' && model != 'C')) {
      throw InvalidComponent();
    }
    if (!_isValidElectorKey(electorKey)) throw InvalidComponent();
    if (!RegExp(r'^\d{2}$').hasMatch(issuingNumber)) throw InvalidComponent();
    if (!_isValidOCRorCitizenId(ocr)) throw InvalidComponent();
  }

  @override
  String compact(String ine) {
    return ine.replaceAll(RegExp(r'[\s-]'), '').toUpperCase();
  }

  @override
  String format(String ine) {
    final normalized = ine.trim().toUpperCase().replaceAll(RegExp(r'\s+'), '');
    final parts = normalized.split(':');

    if (parts.length == 1) {
      final value = compact(parts[0]);
      if (_isValidCIC(value) ||
          _isValidOCRorCitizenId(value) ||
          _isValidElectorKey(value)) {
        return value;
      }
      throw InvalidComponent();
    }

    if (parts.length == 3) {
      _validateCompositeDToH(parts);
      return '${parts[0]}:${parts[1]}:${parts[2].toUpperCase()}';
    }

    if (parts.length == 4) {
      _validateCompositeAToC(parts);
      return '${parts[0].toUpperCase()}:${parts[1]}:${parts[2]}:${parts[3].toUpperCase()}';
    }

    throw InvalidFormat();
  }

  @override
  String validate(String ine) {
    final normalized = ine.trim().toUpperCase().replaceAll(RegExp(r'\s+'), '');
    final parts = normalized.split(':');

    if (parts.length == 1) {
      final value = compact(parts[0]);
      if (_isValidCIC(value) ||
          _isValidOCRorCitizenId(value) ||
          _isValidElectorKey(value)) {
        return ine;
      }

      if (value.isEmpty) throw InvalidLength();
      throw InvalidComponent();
    }

    if (parts.length == 3) {
      _validateCompositeDToH(parts);
      return ine;
    }

    if (parts.length == 4) {
      _validateCompositeAToC(parts);
      return ine;
    }

    throw InvalidFormat();
  }

  @override
  bool isValid(String ine) {
    try {
      validate(ine);
      return true;
    } catch (e) {
      return false;
    }
  }
}
