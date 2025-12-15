abstract class SettingsRepository {
  Future<bool> getDarkMode();
  Future<void> setDarkMode(bool isDarkMode);

  Future<String> getUserName();
  Future<void> setUserName(String userName);
}
