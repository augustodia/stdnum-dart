# stdnum_dart

`stdnum_dart` is a Dart library for validating, compacting, and formatting standard document numbers such as tax identifiers, VAT numbers, and personal identity numbers.

This project is based on and inspired by:

- [`koblas/stdnum-js`](https://github.com/koblas/stdnum-js)
- [`arthurdejong/python-stdnum`](https://github.com/arthurdejong/python-stdnum)

This is an initial Dart version. Many countries, document types, official references, examples, and documentation pages still need to be added. Contributions are welcome.

## Features

- Validates national document numbers and throws typed validation errors.
- Compacts formatted values by removing separators accepted by each validator.
- Formats compact values into the common local representation.
- Groups validators by country namespace, for example `StdnumDart().BR.CPF`.
- Has no runtime dependencies.

## Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  stdnum_dart: ^0.1.0
```

Then run:

```sh
dart pub get
```

## Usage

```dart
import 'package:stdnum_dart/stdnum_dart.dart';

void main() {
  final stdnum = StdnumDart();

  final cpf = stdnum.BR.CPF;
  final value = '111.444.777-35';

  print(cpf.isValid(value)); // true
  print(cpf.compact(value)); // 11144477735
  print(cpf.format('11144477735')); // 111.444.777-35

  try {
    cpf.validate('12345678901');
  } on ValidationError catch (error) {
    print(error.name);
  }
}
```

Each validator implements:

- `compact(String value)`: removes accepted separators and normalizes the value.
- `format(String value)`: returns the local formatted representation.
- `validate(String value)`: returns the original value or throws a validation error.
- `isValid(String value)`: returns `true` or `false`.

## Supported Documents

| Country | Namespace | Documents |
| --- | --- | --- |
| Argentina | `AR` | `CUIT`, `DNI` |
| Bolivia | `BO` | `CI`, `NIF` |
| Brazil | `BR` | `CPF`, `CNPJ` |
| Chile | `CL` | `RUT` |
| Colombia | `CO` | `NIT` |
| Ecuador | `EC` | `CI`, `RUC` |
| Mexico | `MX` | `RFC`, `INE` |
| Paraguay | `PY` | `CI`, `RUC` |
| Peru | `PU` | `CUI`, `RUC` |
| Portugal | `PT` | `CC`, `NIF` |
| Spain | `ES` | `DNI`, `NIF` |
| United States | `US` | `EIN`, `SSN` |
| Uruguay | `UY` | `CI`, `RUT` |
| Venezuela | `VE` | `RIF` |

## Validation Errors

`validate` throws one of the package validation errors:

- `InvalidFormat`
- `InvalidChecksum`
- `InvalidLength`
- `InvalidComponent`

All validation errors extend `ValidationError`.

## Project Status

This package is in an initial release stage. It already covers a focused set of countries and documents, but it is not yet as broad as `stdnum-js` or `python-stdnum`.

Planned and welcome contributions include:

- more countries and document numbers;
- more official source links for each validator;
- more examples and documentation pages;
- API refinements based on real-world usage;
- additional edge-case test fixtures.

## Contributing

See [`CONTRIBUTING.md`](CONTRIBUTING.md) for the implementation pattern, test requirements, and release checks.

## License

This package is released under the MIT License. See [`LICENSE`](LICENSE).
