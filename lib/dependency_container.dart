import 'package:dio/dio.dart';

import 'core/exceptions/storage_exceptions.dart';
import 'core/network/exceptions/network_exceptions.dart';
import 'data/datasources/file_task_datasource.dart';
import 'data/datasources/prefs_task_datasource.dart';
import 'data/datasources/remote/api/countries_datasource.dart';
import 'data/datasources/remote/api/dio_client_with_interceptors.dart';
import 'data/datasources/remote/api/json_placeholder_api.dart';
import 'data/datasources/remote/api/json_placeholder_datasource.dart';
import 'data/datasources/remote/api/rest_countries_api.dart';
import 'data/datasources/secure_settings_datasource.dart';
import 'data/datasources/settings_local_datasource.dart';
import 'data/repositories/network_demo_repository_impl.dart';
import 'data/repositories/settings_repository_impl.dart';
import 'data/repositories/task_repository_impl.dart';
import 'domain/repositories/network_demo_repository.dart';
import 'domain/repositories/settings_repository.dart';
import 'domain/repositories/task_repository.dart';
import 'domain/usecases/network_demo_usecases.dart';
import 'domain/usecases/settings_usecases.dart';
import 'domain/usecases/task_usecases.dart';

class DependencyContainer {
  DependencyContainer._();

  static final DependencyContainer instance = DependencyContainer._();

  static const String _jsonPlaceholderBaseUrl =
      'https://jsonplaceholder.typicode.com';
  static const String _restCountriesBaseUrl = 'https://restcountries.com/v3.1';

  // --- Network ---
  Dio? _jsonDio;
  Dio? _countriesDio;

  JsonPlaceholderApi? _jsonApi;
  RestCountriesApi? _countriesApi;

  JsonPlaceholderDataSource? _jsonDataSource;
  CountriesDataSource? _countriesDataSource;

  NetworkDemoRepository? _networkRepo;
  NetworkDemoUseCases? _networkUseCases;

  // --- Tasks (local storages) ---
  FileTaskDataSource? _secureTasksDataSource;
  PrefsTaskDataSource? _prefsTasksDataSource;
  TaskRepository? _taskRepository;

  GetAllTasksUseCase? _getAllTasksUseCase;
  AddTaskUseCase? _addTaskUseCase;
  UpdateTaskUseCase? _updateTaskUseCase;
  DeleteTaskUseCase? _deleteTaskUseCase;
  ToggleTaskStatusUseCase? _toggleTaskStatusUseCase;

  // --- Settings (local storages) ---
  SettingsLocalDataSource? _settingsLocal;
  SecureSettingsDataSource? _secureSettings;
  SettingsRepository? _settingsRepository;

  GetDarkModeUseCase? _getDarkModeUseCase;
  SetDarkModeUseCase? _setDarkModeUseCase;
  ToggleDarkModeUseCase? _toggleDarkModeUseCase;
  GetUserNameUseCase? _getUserNameUseCase;
  SetUserNameUseCase? _setUserNameUseCase;

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

  // --- Tasks ---
  FileTaskDataSource get secureTasksDataSource {
    _secureTasksDataSource ??= FileTaskDataSource();
    return _secureTasksDataSource!;
  }

  PrefsTaskDataSource get prefsTasksDataSource {
    _prefsTasksDataSource ??= PrefsTaskDataSource();
    return _prefsTasksDataSource!;
  }

  TaskRepository get taskRepository {
    _taskRepository ??= TaskRepositoryImpl(
      secureDataSource: secureTasksDataSource,
      prefsDataSource: prefsTasksDataSource,
    );
    return _taskRepository!;
  }

  GetAllTasksUseCase get getAllTasksUseCase {
    _getAllTasksUseCase ??= GetAllTasksUseCase(taskRepository);
    return _getAllTasksUseCase!;
  }

  AddTaskUseCase get addTaskUseCase {
    _addTaskUseCase ??= AddTaskUseCase(taskRepository);
    return _addTaskUseCase!;
  }

  UpdateTaskUseCase get updateTaskUseCase {
    _updateTaskUseCase ??= UpdateTaskUseCase(taskRepository);
    return _updateTaskUseCase!;
  }

  DeleteTaskUseCase get deleteTaskUseCase {
    _deleteTaskUseCase ??= DeleteTaskUseCase(taskRepository);
    return _deleteTaskUseCase!;
  }

  ToggleTaskStatusUseCase get toggleTaskStatusUseCase {
    _toggleTaskStatusUseCase ??= ToggleTaskStatusUseCase(taskRepository);
    return _toggleTaskStatusUseCase!;
  }

  // --- Settings ---
  SettingsLocalDataSource get settingsLocalDataSource {
    _settingsLocal ??= SettingsLocalDataSource();
    return _settingsLocal!;
  }

  SecureSettingsDataSource get secureSettingsDataSource {
    _secureSettings ??= SecureSettingsDataSource();
    return _secureSettings!;
  }

  SettingsRepository get settingsRepository {
    _settingsRepository ??= SettingsRepositoryImpl(
      settings: settingsLocalDataSource,
      secureSettings: secureSettingsDataSource,
    );
    return _settingsRepository!;
  }

  GetDarkModeUseCase get getDarkModeUseCase {
    _getDarkModeUseCase ??= GetDarkModeUseCase(settingsRepository);
    return _getDarkModeUseCase!;
  }

  SetDarkModeUseCase get setDarkModeUseCase {
    _setDarkModeUseCase ??= SetDarkModeUseCase(settingsRepository);
    return _setDarkModeUseCase!;
  }

  ToggleDarkModeUseCase get toggleDarkModeUseCase {
    _toggleDarkModeUseCase ??= ToggleDarkModeUseCase(settingsRepository);
    return _toggleDarkModeUseCase!;
  }

  GetUserNameUseCase get getUserNameUseCase {
    _getUserNameUseCase ??= GetUserNameUseCase(settingsRepository);
    return _getUserNameUseCase!;
  }

  SetUserNameUseCase get setUserNameUseCase {
    _setUserNameUseCase ??= SetUserNameUseCase(settingsRepository);
    return _setUserNameUseCase!;
  }

  void reset() {
    // Network
    _jsonDio = null;
    _countriesDio = null;

    _jsonApi = null;
    _countriesApi = null;

    _jsonDataSource = null;
    _countriesDataSource = null;

    _networkRepo = null;
    _networkUseCases = null;

    // Tasks
    _secureTasksDataSource = null;
    _prefsTasksDataSource = null;
    _taskRepository = null;
    _getAllTasksUseCase = null;
    _addTaskUseCase = null;
    _updateTaskUseCase = null;
    _deleteTaskUseCase = null;
    _toggleTaskStatusUseCase = null;

    // Settings
    _settingsLocal = null;
    _secureSettings = null;
    _settingsRepository = null;
    _getDarkModeUseCase = null;
    _setDarkModeUseCase = null;
    _toggleDarkModeUseCase = null;
    _getUserNameUseCase = null;
    _setUserNameUseCase = null;
  }
}

final di = DependencyContainer.instance;

NetworkException asNetworkException(Object e) {
  if (e is NetworkException) return e;
  return NetworkException('Неизвестная ошибка', data: e);
}

String asErrorMessage(Object e) {
  if (e is NetworkException) return e.message;
  if (e is StorageException) return e.message;
  if (e is ArgumentError) return e.message?.toString() ?? 'Некорректные данные';
  return e.toString();
}
