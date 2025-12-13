import 'package:dio/dio.dart';

import 'core/network/exceptions/network_exceptions.dart';
import 'data/datasources/remote/api/countries_datasource.dart';
import 'data/datasources/remote/api/dio_client_with_interceptors.dart';
import 'data/datasources/remote/api/json_placeholder_api.dart';
import 'data/datasources/remote/api/json_placeholder_datasource.dart';
import 'data/datasources/remote/api/rest_countries_api.dart';
import 'data/repositories/network_demo_repository_impl.dart';
import 'domain/repositories/network_demo_repository.dart';
import 'domain/usecases/network_demo_usecases.dart';

/// Simple DI container (singleton) for PR13.
///
/// The main app mostly uses Riverpod providers; this container is added to match
/// the PR13 requirement and can be used from providers as well.
class DependencyContainer {
  DependencyContainer._();

  static final DependencyContainer instance = DependencyContainer._();

  // ===== Config =====

  static const String _jsonPlaceholderBaseUrl =
      'https://jsonplaceholder.typicode.com';
  static const String _restCountriesBaseUrl = 'https://restcountries.com/v3.1';

  // ===== Cached instances =====

  Dio? _jsonDio;
  Dio? _countriesDio;

  JsonPlaceholderApi? _jsonApi;
  RestCountriesApi? _countriesApi;

  JsonPlaceholderDataSource? _jsonDataSource;
  CountriesDataSource? _countriesDataSource;

  NetworkDemoRepository? _networkRepo;
  NetworkDemoUseCases? _networkUseCases;

  Dio get jsonDio {
    _jsonDio ??= DioClientWithInterceptors(
      baseUrl: _jsonPlaceholderBaseUrl,
      bearerToken: 'demo-token',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      logTag: 'JSONPlaceholder',
    ).dio;
    return _jsonDio!;
  }

  Dio get countriesDio {
    _countriesDio ??= DioClientWithInterceptors(
      baseUrl: _restCountriesBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      logTag: 'RESTCountries',
    ).dio;
    return _countriesDio!;
  }

  JsonPlaceholderApi get jsonApi {
    _jsonApi ??= JsonPlaceholderApi(jsonDio);
    return _jsonApi!;
  }

  RestCountriesApi get countriesApi {
    _countriesApi ??= RestCountriesApi(countriesDio);
    return _countriesApi!;
  }

  JsonPlaceholderDataSource get jsonDataSource {
    _jsonDataSource ??= JsonPlaceholderDataSource(jsonApi);
    return _jsonDataSource!;
  }

  CountriesDataSource get countriesDataSource {
    _countriesDataSource ??= CountriesDataSource(countriesApi);
    return _countriesDataSource!;
  }

  NetworkDemoRepository get networkDemoRepository {
    _networkRepo ??= NetworkDemoRepositoryImpl(
      jsonPlaceholder: jsonDataSource,
      countries: countriesDataSource,
    );
    return _networkRepo!;
  }

  NetworkDemoUseCases get networkDemoUseCases {
    _networkUseCases ??= NetworkDemoUseCases(networkDemoRepository);
    return _networkUseCases!;
  }

  void reset() {
    _jsonDio = null;
    _countriesDio = null;

    _jsonApi = null;
    _countriesApi = null;

    _jsonDataSource = null;
    _countriesDataSource = null;

    _networkRepo = null;
    _networkUseCases = null;
  }
}

final di = DependencyContainer.instance;

/// Helper to normalize unknown errors.
NetworkException asNetworkException(Object e) {
  if (e is NetworkException) return e;
  return NetworkException('Неизвестная ошибка', data: e);
}
