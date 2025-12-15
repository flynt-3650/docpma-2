import 'dart:developer';

import 'package:dio/dio.dart';

class LoggingInterceptor extends Interceptor {
  LoggingInterceptor({this.tag = 'HTTP'});

  final String tag;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log(
      '➡️ ${options.method} ${options.uri}\nHeaders: ${options.headers}\nQuery: ${options.queryParameters}\nData: ${options.data}',
      name: tag,
    );
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log(
      '✅ ${response.statusCode} ${response.requestOptions.uri}\nData: ${response.data}',
      name: tag,
    );
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log(
      '❌ ${err.type} ${err.requestOptions.uri}\nMessage: ${err.message}\nResponse: ${err.response?.data}',
      name: tag,
    );
    super.onError(err, handler);
  }
}
