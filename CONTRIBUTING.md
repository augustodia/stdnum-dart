# Contributing

Thanks for considering contributing to `stdnum_dart`.

This package follows the same general idea as [`stdnum-js`](https://github.com/koblas/stdnum-js) and [`python-stdnum`](https://github.com/arthurdejong/python-stdnum): small validators for standard national numbers, grouped by country.

## What to Contribute

This is an initial release. Contributions are especially useful for:

- new countries and document types;
- official references for validation rules;
- checksum and formatting fixes;
- additional real-world valid and invalid fixtures;
- README and API documentation improvements.

## Validator Pattern

Each validator should:

- live in `lib/src/countries/<country>/<document>.dart`;
- implement `DocumentInterface`;
- provide `compact`, `format`, `validate`, and `isValid`;
- throw `InvalidLength`, `InvalidFormat`, `InvalidChecksum`, or `InvalidComponent`;
- avoid runtime dependencies unless they are clearly justified;
- include tests in `test/src/<country>/<document>_test.dart`.

Country namespaces should be exposed through:

- `lib/src/countries/<country>/index.dart`;
- `lib/src/index.dart`;
- the public export in `lib/stdnum_dart.dart` when needed.

## Tests

Add focused tests for:

- valid compact and formatted numbers;
- invalid length;
- invalid format;
- invalid components;
- invalid checksums;
- `compact`;
- `format`.

Run the full validation before opening a pull request:

```sh
dart format .
dart analyze
dart test
dart pub publish --dry-run
```

## Documentation

When adding a country or document:

- update the supported documents table in `README.md`;
- add meaningful source links in code comments or PR notes;
- add a `CHANGELOG.md` entry when the change is user-visible.

## Licensing and Credits

`stdnum_dart` is MIT licensed. Some validation rules and algorithms are based on public documentation and the work in `stdnum-js` and `python-stdnum`; keep credits and references clear when porting or adapting behavior.
