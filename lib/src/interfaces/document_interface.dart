/// Common contract implemented by every document validator.
abstract class DocumentInterface {
  /// Returns a normalized document string by removing accepted separators.
  String compact(String document);

  /// Validates [document] and returns the original value when it is valid.
  ///
  /// Implementations throw a validation error subtype when validation fails.
  String validate(String document);

  /// Returns whether [document] is valid without throwing validation errors.
  bool isValid(String document);

  /// Returns [document] in the common local presentation format.
  String format(String document);
}
