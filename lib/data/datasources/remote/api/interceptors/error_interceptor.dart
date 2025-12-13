import 'package:dio/dio.dart';

import '../../../../../core/network/exceptions/network_exceptions.dart';

/// Maps Dio errors to app-specific [NetworkException] hierarchy.
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final mapped = _map(err);
    handler.reject(err.copyWith(error: mapped));
  }

  Exception _map(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutException(
          'Превышено время ожидания ответа от сервера',
        );

      case DioExceptionType.badResponse:
        final response = error.response;
        if (response == null) {
          return const NetworkException('Некорректный ответ сервера');
        }
        return _handleHttp(response);

      case DioExceptionType.unknown:
        final msg = error.error?.toString() ?? error.message ?? '';
        if (msg.contains('SocketException') ||
            msg.contains('Failed host lookup')) {
          return const NetworkException('Нет подключения к интернету');
        }
        return const NetworkException('Неизвестная сетевая ошибка');

      case DioExceptionType.badCertificate:
        return const NetworkException('Ошибка сертификата');

      case DioExceptionType.cancel:
        return const NetworkException('Запрос отменён');

      case DioExceptionType.connectionError:
        return const NetworkException('Ошибка соединения');
    }
  }

  Exception _handleHttp(Response response) {
    final statusCode = response.statusCode;
    final data = response.data;

    switch (statusCode) {
      case 400:
        return BadRequestException('Неверный запрос', data: data);
      case 401:
        return const UnauthorizedException(
          'Требуется аутентификация',
          statusCode: 401,
        );
      case 403:
        return const UnauthorizedException('Доступ запрещён', statusCode: 403);
      case 404:
        return const NetworkException('Ресурс не найден', statusCode: 404);
      case 429:
        return const NetworkException(
          'Превышен лимит запросов',
          statusCode: 429,
        );
      case 500:
      case 502:
      case 503:
      case 504:
        return ServerException(
          'Ошибка сервера',
          statusCode: statusCode ?? 500,
          data: data,
        );
      default:
        return NetworkException(
          'HTTP ошибка ${statusCode ?? 'unknown'}',
          statusCode: statusCode,
          data: data,
        );
    }
  }
}
