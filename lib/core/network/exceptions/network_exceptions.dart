class NetworkException implements Exception {
  final String message;
  final dynamic data;
  final int? statusCode;

  const NetworkException(this.message, {this.data, this.statusCode});

  @override
  String toString() =>
      'NetworkException(message: $message, statusCode: $statusCode, data: $data)';
}

class TimeoutException extends NetworkException {
  const TimeoutException(String message) : super(message);
}

class BadRequestException extends NetworkException {
  const BadRequestException(String message, {dynamic data})
    : super(message, data: data, statusCode: 400);
}

class UnauthorizedException extends NetworkException {
  const UnauthorizedException(String message, {int? statusCode})
    : super(message, statusCode: statusCode);
}

class ServerException extends NetworkException {
  const ServerException(String message, {required int statusCode, dynamic data})
    : super(message, statusCode: statusCode, data: data);
}
