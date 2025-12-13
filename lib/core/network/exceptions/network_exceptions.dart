/// Network exception hierarchy used across the app.
///
/// We keep these exceptions "domain-friendly": UI and business logic should not
/// depend on Dio-specific error types.
class NetworkException implements Exception {
  final String message;
  final dynamic data;
  final int? statusCode;

  const NetworkException(this.message, {this.data, this.statusCode});

  @override
  String toString() =>
      'NetworkException(message: $message, statusCode: $statusCode, data: $data)';
}

/// Connection/receive timeout.
class TimeoutException extends NetworkException {
  const TimeoutException(String message) : super(message);
}

/// HTTP 400.
class BadRequestException extends NetworkException {
  const BadRequestException(String message, {dynamic data})
    : super(message, data: data, statusCode: 400);
}

/// HTTP 401/403.
class UnauthorizedException extends NetworkException {
  const UnauthorizedException(String message, {int? statusCode})
    : super(message, statusCode: statusCode);
}

/// HTTP 5xx.
class ServerException extends NetworkException {
  const ServerException(String message, {required int statusCode, dynamic data})
    : super(message, statusCode: statusCode, data: data);
}
