/// Base error thrown when document validation fails.
class ValidationError extends Error {
  /// Machine-readable error name.
  final String name = 'ValidationError';

  /// Human-readable validation failure message.
  final String message;

  /// Creates a validation error with [message].
  ValidationError(this.message);
}

/// Error thrown when the document format is not accepted.
class InvalidFormat extends ValidationError {
  @override
  String get name => 'InvalidFormat';

  /// Creates an invalid format error.
  InvalidFormat([super.message = 'The number has an invalid format.']);
}

/// Error thrown when the checksum or check digit is invalid.
class InvalidChecksum extends ValidationError {
  @override
  String get name => 'InvalidChecksum';

  /// Creates an invalid checksum error.
  InvalidChecksum([
    super.message = 'The number checksum or check digit is invalid.',
  ]);
}

/// Error thrown when the document length is invalid.
class InvalidLength extends ValidationError {
  @override
  String get name => 'InvalidLength';

  /// Creates an invalid length error.
  InvalidLength([super.message = 'The number has an invalid length.']);
}

/// Error thrown when a document component is invalid or unknown.
class InvalidComponent extends ValidationError {
  @override
  String get name => 'InvalidComponent';

  /// Creates an invalid component error.
  InvalidComponent([
    super.message = 'One of the parts of the number are invalid or unknown.',
  ]);
}
