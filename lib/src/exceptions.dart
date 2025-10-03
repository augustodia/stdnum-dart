class ValidationError extends Error {
  final String name = 'ValidationError';
  final String message;

  ValidationError(this.message);
}

class InvalidFormat extends ValidationError {
  @override
  String get name => 'InvalidFormat';

  InvalidFormat([super.message = 'The number has an invalid format.']);
}

class InvalidChecksum extends ValidationError {
  @override
  String get name => 'InvalidChecksum';

  InvalidChecksum([
    super.message = 'The number checksum or check digit is invalid.',
  ]);
}

class InvalidLength extends ValidationError {
  @override
  String get name => 'InvalidLength';

  InvalidLength([super.message = 'The number has an invalid length.']);
}

class InvalidComponent extends ValidationError {
  @override
  String get name => 'InvalidComponent';

  InvalidComponent([
    super.message = 'One of the parts of the number are invalid or unknown.',
  ]);
}
