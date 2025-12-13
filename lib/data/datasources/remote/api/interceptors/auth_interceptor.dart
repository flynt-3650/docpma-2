import 'package:dio/dio.dart';

/// Simple auth interceptor.
///
/// Supports:
/// - adding Bearer token to `Authorization` header
/// - adding additional static headers
/// - adding static query parameters
class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    this.bearerToken,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) : _headers = headers ?? const {},
       _queryParameters = queryParameters ?? const {};

  final String? bearerToken;
  final Map<String, String> _headers;
  final Map<String, dynamic> _queryParameters;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (bearerToken != null && bearerToken!.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $bearerToken';
    }

    if (_headers.isNotEmpty) {
      options.headers.addAll(_headers);
    }

    if (_queryParameters.isNotEmpty) {
      options.queryParameters.addAll(_queryParameters);
    }

    super.onRequest(options, handler);
  }
}
