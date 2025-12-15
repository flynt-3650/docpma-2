class StorageException implements Exception {
  final String message;
  final Object? cause;

  const StorageException(this.message, {this.cause});

  @override
  String toString() => 'StorageException(message: $message, cause: $cause)';
}

class StorageReadException extends StorageException {
  const StorageReadException(String message, {Object? cause})
    : super(message, cause: cause);
}

class StorageWriteException extends StorageException {
  const StorageWriteException(String message, {Object? cause})
    : super(message, cause: cause);
}

class StorageCorruptedDataException extends StorageException {
  const StorageCorruptedDataException(String message, {Object? cause})
    : super(message, cause: cause);
}
