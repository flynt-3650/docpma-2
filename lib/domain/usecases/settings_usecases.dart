import '../repositories/settings_repository.dart';

class GetDarkModeUseCase {
  final SettingsRepository _repo;
  GetDarkModeUseCase(this._repo);

  Future<bool> execute() => _repo.getDarkMode();
}

class SetDarkModeUseCase {
  final SettingsRepository _repo;
  SetDarkModeUseCase(this._repo);

  Future<void> execute(bool value) => _repo.setDarkMode(value);
}

class ToggleDarkModeUseCase {
  final SettingsRepository _repo;
  ToggleDarkModeUseCase(this._repo);

  Future<bool> execute(bool current) async {
    final next = !current;
    await _repo.setDarkMode(next);
    return next;
  }
}

class GetUserNameUseCase {
  final SettingsRepository _repo;
  GetUserNameUseCase(this._repo);

  Future<String> execute() => _repo.getUserName();
}

class SetUserNameUseCase {
  final SettingsRepository _repo;
  SetUserNameUseCase(this._repo);

  Future<void> execute(String name) {
    if (name.trim().isEmpty) {
      throw ArgumentError('Имя не может быть пустым');
    }
    return _repo.setUserName(name.trim());
  }
}
