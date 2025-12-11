import 'package:shared_preferences/shared_preferences.dart';

class SettingsLocalDataSource {
  static const String _isDarkModeKey = 'is_dark_mode';
  static const String _userNameKey = 'user_name';
  static const String _notificationsEnabledKey = 'notifications_enabled';
  static const String _lastSyncTimestampKey = 'last_sync_timestamp';

  SharedPreferences? _prefs;

  Future<SharedPreferences> _getPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<void> setDarkMode(bool isDarkMode) async {
    final prefs = await _getPrefs();
    await prefs.setBool(_isDarkModeKey, isDarkMode);
  }

  Future<bool> getDarkMode() async {
    final prefs = await _getPrefs();
    return prefs.getBool(_isDarkModeKey) ?? true;
  }

  Future<void> setUserName(String userName) async {
    final prefs = await _getPrefs();
    await prefs.setString(_userNameKey, userName);
  }

  Future<String> getUserName() async {
    final prefs = await _getPrefs();
    return prefs.getString(_userNameKey) ?? 'Гость';
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    final prefs = await _getPrefs();
    await prefs.setBool(_notificationsEnabledKey, enabled);
  }

  Future<bool> getNotificationsEnabled() async {
    final prefs = await _getPrefs();
    return prefs.getBool(_notificationsEnabledKey) ?? true;
  }

  Future<void> setLastSyncTimestamp(DateTime timestamp) async {
    final prefs = await _getPrefs();
    await prefs.setInt(_lastSyncTimestampKey, timestamp.millisecondsSinceEpoch);
  }

  Future<DateTime?> getLastSyncTimestamp() async {
    final prefs = await _getPrefs();
    final timestamp = prefs.getInt(_lastSyncTimestampKey);
    if (timestamp == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  Future<void> clearAll() async {
    final prefs = await _getPrefs();
    await prefs.clear();
  }

  Future<void> remove(String key) async {
    final prefs = await _getPrefs();
    await prefs.remove(key);
  }
}
