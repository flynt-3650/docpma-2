# ⚡ Riverpod - Быстрый старт

## 🎯 Что сделано?

Реализовано **5 примеров** использования Riverpod в Flutter приложении для управления задачами.

---

## 🚀 Запуск за 3 шага

```bash
# 1. Установить зависимости
flutter pub get

# 2. Запустить приложение
flutter run lib/main_riverpod.dart -d windows

# 3. Готово! 🎉
```

---

## 📦 5 примеров в одной таблице

| № | Экран | Провайдер | Что показывает |
|---|-------|-----------|----------------|
| **1** | Список задач | `StateNotifierProvider` | CRUD операции, управление списком |
| **2** | Форма | `Provider.family` | Параметризованные провайдеры, получение по ID |
| **3** | Детали | `StreamProvider` | Потоки данных, реального времени обновления |
| **4** | Статистика | `FutureProvider` + `Computed` | Async операции, вычисляемые значения |
| **5** | Настройки | `StateProvider` + `Provider` | Простое состояние, константы |

---

## 📂 Файлы примеров

```
lib/features/tasks/screens/
├── task_list_screen_riverpod.dart      ← Пример 1
├── task_form_screen_riverpod.dart      ← Пример 2
├── task_details_screen_riverpod.dart   ← Пример 3
├── statistics_screen_riverpod.dart     ← Пример 4
└── settings_screen_riverpod.dart       ← Пример 5
```

---

## 💡 Ключевые концепции

### 1. Обертка приложения
```dart
void main() {
  runApp(
    ProviderScope(child: MyApp()),  // ← Обязательно!
  );
}
```

### 2. ConsumerWidget
```dart
class MyScreen extends ConsumerWidget {
  Widget build(BuildContext context, WidgetRef ref) {
    // ref - доступ к провайдерам
  }
}
```

### 3. Чтение данных
```dart
// Подписка (UI обновляется)
final tasks = ref.watch(tasksProvider);

// Одноразовое чтение (без подписки)
final notifier = ref.read(tasksProvider.notifier);
```

---

## 🎨 Типы провайдеров

| Тип | Когда использовать | Пример кода |
|-----|-------------------|-------------|
| **Provider** | Константы | `Provider<String>((ref) => '1.0.0')` |
| **StateProvider** | Простые значения | `StateProvider<int>((ref) => 0)` |
| **StateNotifierProvider** | Сложная логика | `StateNotifierProvider<TasksNotifier, List<Task>>` |
| **FutureProvider** | Async операции | `FutureProvider<int>((ref) async => ...)` |
| **StreamProvider** | Потоки | `StreamProvider<DateTime>((ref) => ...)` |
| **Provider.family** | С параметрами | `Provider.family<Task?, String>((ref, id) => ...)` |

---

## 📱 Навигация

- **Главная:** `/riverpod` → Список задач
- **Создать:** `/riverpod/task/new` → Форма создания
- **Детали:** `/riverpod/task/:id` → Детали задачи
- **Редактировать:** `/riverpod/task/edit/:id` → Форма редактирования
- **Статистика:** `/riverpod/statistics` → Статистика
- **Настройки:** `/riverpod/settings` → Настройки

---

## 🔥 Примеры кода

### Пример 1: StateNotifierProvider
```dart
// Определение
class TasksNotifier extends StateNotifier<List<Task>> {
  void addTask(...) { state = [...state, newTask]; }
}

final tasksProvider = StateNotifierProvider<TasksNotifier, List<Task>>(...);

// Использование
final tasks = ref.watch(tasksProvider);
ref.read(tasksProvider.notifier).addTask(...);
```

### Пример 2: Provider.family
```dart
// Определение
final taskByIdProvider = Provider.family<Task?, String>((ref, id) {
  return ref.watch(tasksProvider).firstWhere((t) => t.id == id);
});

// Использование
final task = ref.watch(taskByIdProvider('123'));
```

### Пример 3: StreamProvider
```dart
// Определение
final timeStreamProvider = StreamProvider<DateTime>((ref) {
  return Stream.periodic(Duration(seconds: 1), (_) => DateTime.now());
});

// Использование
final timeAsync = ref.watch(timeStreamProvider);
timeAsync.when(
  data: (time) => Text('$time'),
  loading: () => CircularProgressIndicator(),
  error: (err, _) => Text('Error'),
);
```

### Пример 4: FutureProvider
```dart
// Определение
final asyncCountProvider = FutureProvider<int>((ref) async {
  await Future.delayed(Duration(seconds: 2));
  return ref.watch(tasksProvider).length;
});

// Использование
final countAsync = ref.watch(asyncCountProvider);
countAsync.when(
  data: (count) => Text('Count: $count'),
  loading: () => CircularProgressIndicator(),
  error: (err, _) => Text('Error'),
);
```

### Пример 5: StateProvider
```dart
// Определение
final counterProvider = StateProvider<int>((ref) => 0);

// Использование
final counter = ref.watch(counterProvider);
ref.read(counterProvider.notifier).state++; // Изменение
```

---

## 🎓 Полная документация

- **RIVERPOD_README.md** - Полное руководство с описанием и скриншотами
- **RIVERPOD_REPORT.md** - Детальный отчет по всем 5 примерам
- **RIVERPOD_ARCHITECTURE.md** - Архитектура и схемы
- **RIVERPOD_SUMMARY.md** - Краткое резюме

---

## ✅ Чек-лист проверки

- ✅ Установлена зависимость `flutter_riverpod: ^2.4.0`
- ✅ Создан файл провайдеров `task_providers.dart`
- ✅ Реализовано 5 экранов с разными провайдерами
- ✅ Приложение обернуто в `ProviderScope`
- ✅ Используется `ConsumerWidget` для доступа к провайдерам
- ✅ Все провайдеры работают корректно
- ✅ Создана документация

---

## 🎉 Готово!

Теперь у вас есть полноценное приложение с **5 примерами использования Riverpod**!

### Что дальше?

1. 📖 Прочитайте полную документацию в **RIVERPOD_REPORT.md**
2. 🔍 Изучите код примеров в папке `lib/features/tasks/screens/`
3. 🧪 Попробуйте создать свой провайдер
4. 🚀 Запустите приложение и протестируйте все функции

**Удачи! 🚀**

