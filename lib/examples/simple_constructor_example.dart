// Пример простого класса с одним параметром в конструкторе
// Этот файл используется только для демонстрации концепции

class User {
  final String name;

  User(this.name);

  void greet() {
    print('Привет, $name!');
  }
}

void main() {
  User user = User('Иван');
  user.greet();
}
