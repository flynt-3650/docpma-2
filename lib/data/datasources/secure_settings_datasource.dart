import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecureSettingsDataSource {
  static const String _userNameKey = 'user_name';

  final FlutterSecureStorage _storage;

  SecureSettingsDataSource({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  Future<void> setUserName(String userName) async {
    await _storage.write(key: _userNameKey, value: userName);
  }

  Future<String> getUserName() async {
    var name = await _storage.read(key: _userNameKey);

    // One-time migration from legacy SharedPreferences storage (if present).
    if (name == null || name.isEmpty) {
      final prefs = await SharedPreferences.getInstance();
      final legacy = prefs.getString(_userNameKey);
      if (legacy != null && legacy.isNotEmpty) {
        name = legacy;
        await _storage.write(key: _userNameKey, value: legacy);
        await prefs.remove(_userNameKey);
      }
    }

    return name ?? 'Гость';
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  Future<void> remove(String key) async {
    await _storage.delete(key: key);
  }
}
