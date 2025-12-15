import '../../domain/repositories/settings_repository.dart';
import '../datasources/secure_settings_datasource.dart';
import '../datasources/settings_local_datasource.dart';

/// Repository that coordinates multiple local storages.
///
/// - Dark mode is stored in SharedPreferences via [SettingsLocalDataSource]
/// - User name is stored in SecureStorage via [SecureSettingsDataSource]
class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl({
    required SettingsLocalDataSource settings,
    required SecureSettingsDataSource secureSettings,
  }) : _settings = settings,
       _secureSettings = secureSettings;

  final SettingsLocalDataSource _settings;
  final SecureSettingsDataSource _secureSettings;

  @override
  Future<bool> getDarkMode() => _settings.getDarkMode();

  @override
  Future<void> setDarkMode(bool isDarkMode) =>
      _settings.setDarkMode(isDarkMode);

  @override
  Future<String> getUserName() => _secureSettings.getUserName();

  @override
  Future<void> setUserName(String userName) =>
      _secureSettings.setUserName(userName);
}
