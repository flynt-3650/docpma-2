import 'package:dio/dio.dart';

import '../../../../core/network/exceptions/network_exceptions.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/logging_interceptor.dart';

/// Dio client configured with interceptors + helper methods.
class DioClientWithInterceptors {
  DioClientWithInterceptors({
    required String baseUrl,
    String? bearerToken,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    Duration connectTimeout = const Duration(seconds: 15),
    Duration receiveTimeout = const Duration(seconds: 15),
    String logTag = 'HTTP',
  }) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: connectTimeout,
        receiveTimeout: receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          ...?headers,
        },
      ),
    );

    _dio.interceptors.addAll([
      AuthInterceptor(
        bearerToken: bearerToken,
        headers: headers,
        queryParameters: queryParameters,
      ),
      LoggingInterceptor(tag: logTag),
      ErrorInterceptor(),
    ]);
  }

  late final Dio _dio;

  Dio get dio => _dio;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw e.error ??
          const NetworkException('Ошибка при выполнении GET запроса');
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw e.error ??
          const NetworkException('Ошибка при выполнении POST запроса');
    }
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw e.error ??
          const NetworkException('Ошибка при выполнении PUT запроса');
    }
  }

  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw e.error ??
          const NetworkException('Ошибка при выполнении PATCH запроса');
    }
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw e.error ??
          const NetworkException('Ошибка при выполнении DELETE запроса');
    }
  }
}
