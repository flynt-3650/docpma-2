# 🚀 Flutter Riverpod - Практическое руководство

## 📋 Содержание

1. [О проекте](#о-проекте)
2. [Что такое Riverpod?](#что-такое-riverpod)
3. [Установка](#установка)
4. [Запуск приложения](#запуск-приложения)
5. [Структура проекта](#структура-проекта)
6. [5 примеров использования](#5-примеров-использования)
7. [Скриншоты](#скриншоты)
8. [Документация](#документация)

---

## 📖 О проекте

Это учебный проект, демонстрирующий **5 различных способов использования Riverpod** для управления состоянием в Flutter приложении. Проект представляет собой приложение для управления задачами с полным набором функций.

### ✨ Особенности

- ✅ **5 типов провайдеров Riverpod** в реальных сценариях
- ✅ **Современный UI** с Material Design 3
- ✅ **Навигация** через GoRouter
- ✅ **Полный CRUD** для задач
- ✅ **Статистика** с визуализацией
- ✅ **Настройки** с изменяемым состоянием
- ✅ **Детальные комментарии** в коде

---

## 🤔 Что такое Riverpod?

**Riverpod** - это современная библиотека управления состоянием для Flutter, которая является эволюцией Provider.

### Преимущества Riverpod:

| Преимущество | Описание |
|--------------|----------|
| 🔒 **Типобезопасность** | Все ошибки на этапе компиляции |
| 🚫 **Без BuildContext** | Провайдеры доступны везде |
| 🧩 **Модульность** | Легко комбинировать и переиспользовать |
| 🧪 **Тестируемость** | Простое мокирование |
| ⚡ **Производительность** | Оптимальные перестройки |
| 🎯 **Множество типов** | Для каждой задачи свой провайдер |

---

## 💾 Установка

### 1. Клонирование репозитория
```bash
git clone <your-repo-url>
cd proj
```

### 2. Установка зависимостей
```bash
flutter pub get
```

### 3. Проверка установки
```bash
flutter doctor
```

---

## ▶️ Запуск приложения

### Windows
```bash
flutter run lib/main_riverpod.dart -d windows
```

### Android
```bash
flutter run lib/main_riverpod.dart -d <device-id>
```

### iOS
```bash
flutter run lib/main_riverpod.dart -d <device-id>
```

### Web
```bash
flutter run lib/main_riverpod.dart -d chrome
```

---

## 📁 Структура проекта

```
lib/
├── main_riverpod.dart                         # 🚀 Точка входа
│
├── riverpod/
│   └── task_providers.dart                    # 🎯 Все провайдеры
│
└── features/
    └── tasks/
        ├── models/
        │   └── task.dart                      # 📦 Модель Task
        │
        └── screens/
            ├── task_list_screen_riverpod.dart      # 📱 Пример 1
            ├── task_form_screen_riverpod.dart      # 📝 Пример 2
            ├── task_details_screen_riverpod.dart   # 📄 Пример 3
            ├── statistics_screen_riverpod.dart     # 📊 Пример 4
            └── settings_screen_riverpod.dart       # ⚙️  Пример 5
```

---

## 🎓 5 примеров использования

### 1️⃣ StateNotifierProvider - Список задач

**Файл:** `task_list_screen_riverpod.dart`

```dart
// Провайдер
final tasksProvider = StateNotifierProvider<TasksNotifier, List<Task>>((ref) {
  return TasksNotifier();
});

// Использование
class TaskListScreen extends ConsumerWidget {
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(tasksProvider);
    return ListView.builder(/* ... */);
  }
}
```

**Что демонстрирует:**
- ✅ Управление списком задач
- ✅ CRUD операции (Create, Read, Update, Delete)
- ✅ Автоматическое обновление UI

---

### 2️⃣ Provider.family - Форма задачи

**Файл:** `task_form_screen_riverpod.dart`

```dart
// Провайдер с параметром
final taskByIdProvider = Provider.family<Task?, String>((ref, id) {
  final tasks = ref.watch(tasksProvider);
  return tasks.firstWhere((task) => task.id == id);
});

// Использование
final task = ref.watch(taskByIdProvider('123'));
```

**Что демонстрирует:**
- ✅ Параметризованные провайдеры
- ✅ Получение задачи по ID
- ✅ Создание и редактирование

---

### 3️⃣ StreamProvider - Детали задачи

**Файл:** `task_details_screen_riverpod.dart`

```dart
// Провайдер потока
final timeStreamProvider = StreamProvider<DateTime>((ref) {
  return Stream.periodic(Duration(seconds: 1), (_) => DateTime.now());
});

// Использование
final timeAsync = ref.watch(timeStreamProvider);
timeAsync.when(
  data: (time) => Text('$time'),
  loading: () => CircularProgressIndicator(),
  error: (err, stack) => Text('Error: $err'),
);
```

**Что демонстрирует:**
- ✅ Работа с потоками (Stream)
- ✅ Обновление UI в реальном времени
- ✅ Обработка состояний (data/loading/error)

---

### 4️⃣ FutureProvider - Статистика

**Файл:** `statistics_screen_riverpod.dart`

```dart
// Асинхронный провайдер
final asyncTasksCountProvider = FutureProvider<int>((ref) async {
  await Future.delayed(Duration(seconds: 2));
  return ref.watch(tasksProvider).length;
});

// Computed провайдеры
final completedTasksProvider = Provider<List<Task>>((ref) {
  final tasks = ref.watch(tasksProvider);
  return tasks.where((t) => t.status == TaskStatus.completed).toList();
});
```

**Что демонстрирует:**
- ✅ Асинхронные операции
- ✅ Computed провайдеры (вычисляемые значения)
- ✅ Статистика с визуализацией

---

### 5️⃣ StateProvider - Настройки

**Файл:** `settings_screen_riverpod.dart`

```dart
// Простые провайдеры
final counterProvider = StateProvider<int>((ref) => 0);
final isDarkModeProvider = StateProvider<bool>((ref) => false);
final appVersionProvider = Provider<String>((ref) => '1.0.0');

// Использование
final counter = ref.watch(counterProvider);
ref.read(counterProvider.notifier).state++; // Увеличение
```

**Что демонстрирует:**
- ✅ Простое состояние (int, bool, String)
- ✅ Неизменяемые значения (версия)
- ✅ Счетчики и переключатели

---

## 📸 Скриншоты

### Экран 1: Список задач
```
┌──────────────────────────────────────┐
│  Список задач (Riverpod)     ⚙️  📊  │
├──────────────────────────────────────┤
│                                      │
│  ┌────────────────────────────────┐ │
│  │ 1  Купить продукты        🗑️  │ │
│  │    Молоко, хлеб, яйца          │ │
│  └────────────────────────────────┘ │
│                                      │
│  ┌────────────────────────────────┐ │
│  │ 2  Позвонить маме         🗑️  │ │
│  │    Узнать как дела             │ │
│  └────────────────────────────────┘ │
│                                      │
│  ┌────────────────────────────────┐ │
│  │ 3  Закончить отчет        🗑️  │ │
│  │    Отчет по проекту X          │ │
│  └────────────────────────────────┘ │
│                                      │
└──────────────────────────────────────┘
                    [+]
```

### Экран 2: Форма задачи
```
┌──────────────────────────────────────┐
│  ← Новая задача                      │
├──────────────────────────────────────┤
│                                      │
│  ┌────────────────────────────────┐ │
│  │ 📝 Название                    │ │
│  │                                │ │
│  └────────────────────────────────┘ │
│                                      │
│  ┌────────────────────────────────┐ │
│  │ 📄 Описание                    │ │
│  │                                │ │
│  │                                │ │
│  └────────────────────────────────┘ │
│                                      │
│  ┌────────────────────────────────┐ │
│  │ ⚠️ Приоритет: Средний ▼       │ │
│  └────────────────────────────────┘ │
│                                      │
│  ┌────────────────────────────────┐ │
│  │      💾 Сохранить              │ │
│  └────────────────────────────────┘ │
│                                      │
└──────────────────────────────────────┘
```

### Экран 3: Детали задачи
```
┌──────────────────────────────────────┐
│  ← Детали задачи           ✏️  🗑️   │
├──────────────────────────────────────┤
│                                      │
│  ┌────────────────────────────────┐ │
│  │ 🕐 Текущее время: 14:30:45     │ │
│  └────────────────────────────────┘ │
│                                      │
│  Купить продукты                     │
│                                      │
│  ┌────────────────────────────────┐ │
│  │ 📄 Описание                    │ │
│  │    Молоко, хлеб, яйца          │ │
│  │                                │ │
│  │ ⚠️ Приоритет                   │ │
│  │    Средний                     │ │
│  │                                │ │
│  │ ℹ️ Статус                      │ │
│  │    Запланирована               │ │
│  │                                │ │
│  │ 🏷️ ID задачи                   │ │
│  │    1                           │ │
│  └────────────────────────────────┘ │
│                                      │
│  [✏️ Редактировать] [🗑️ Удалить]   │
│                                      │
└──────────────────────────────────────┘
```

### Экран 4: Статистика
```
┌──────────────────────────────────────┐
│  ← Статистика (Riverpod)             │
├──────────────────────────────────────┤
│                                      │
│  ┌────────────────────────────────┐ │
│  │ Асинхронная загрузка...  ⏳    │ │
│  │ Загружено задач: 3             │ │
│  └────────────────────────────────┘ │
│                                      │
│  Общая статистика                    │
│                                      │
│  ┌────────────────────────────────┐ │
│  │ 📋 Всего задач                 │ │
│  │    3                           │ │
│  └────────────────────────────────┘ │
│                                      │
│  По статусам                         │
│                                      │
│  ┌──────────────┐ ┌──────────────┐ │
│  │ ✅ Завершено │ │ ⏳ В работе  │ │
│  │    0         │ │    1         │ │
│  └──────────────┘ └──────────────┘ │
│                                      │
│  ┌────────────────────────────────┐ │
│  │ 📅 Запланировано               │ │
│  │    2                           │ │
│  └────────────────────────────────┘ │
│                                      │
│  Прогресс: ▓░░░░░░░░░░ 0%           │
│                                      │
│  [⚙️ Перейти в настройки]           │
│                                      │
└──────────────────────────────────────┘
```

### Экран 5: Настройки
```
┌──────────────────────────────────────┐
│  ← Настройки (Riverpod)              │
├──────────────────────────────────────┤
│                                      │
│  ┌────────────────────────────────┐ │
│  │ ℹ️ Версия приложения            │ │
│  │    1.0.0                       │ │
│  └────────────────────────────────┘ │
│                                      │
│  Профиль пользователя                │
│                                      │
│  ┌────────────────────────────────┐ │
│  │ 👤  Гость                 ✏️   │ │
│  └────────────────────────────────┘ │
│                                      │
│  Внешний вид                         │
│                                      │
│  ┌────────────────────────────────┐ │
│  │ 🌙 Темная тема        ⚪️➡️🔵  │ │
│  │    Выключена                   │ │
│  └────────────────────────────────┘ │
│                                      │
│  Счетчик действий                    │
│                                      │
│  ┌────────────────────────────────┐ │
│  │ Количество нажатий:            │ │
│  │           0                    │ │
│  │                                │ │
│  │ [➕ Увеличить] [🔄 Сбросить]   │ │
│  └────────────────────────────────┘ │
│                                      │
│  [🏠 Вернуться на главную]          │
│  [📊 Открыть статистику]            │
│                                      │
└──────────────────────────────────────┘
```

---

## 📚 Документация

### Основные файлы документации:

1. **RIVERPOD_REPORT.md** - Полный отчет с описанием всех 5 примеров
2. **RIVERPOD_SUMMARY.md** - Краткое резюме
3. **RIVERPOD_ARCHITECTURE.md** - Архитектура и схемы
4. **RIVERPOD_README.md** - Это руководство

### Навигация по коду:

- 🎯 **Провайдеры:** `lib/riverpod/task_providers.dart`
- 📱 **Экраны:** `lib/features/tasks/screens/*_riverpod.dart`
- 📦 **Модели:** `lib/features/tasks/models/task.dart`
- 🚀 **Точка входа:** `lib/main_riverpod.dart`

---

## 🔗 Навигация в приложении

| Путь | Экран | Провайдер |
|------|-------|-----------|
| `/riverpod` | Список задач | StateNotifierProvider |
| `/riverpod/task/new` | Новая задача | Provider.family |
| `/riverpod/task/:id` | Детали | StreamProvider |
| `/riverpod/task/edit/:id` | Редактирование | Provider.family |
| `/riverpod/statistics` | Статистика | FutureProvider |
| `/riverpod/settings` | Настройки | StateProvider |

---

## 🎯 Ключевые концепции

### ProviderScope
Корневой виджет приложения, необходимый для Riverpod:
```dart
void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
```

### ConsumerWidget
Виджет с доступом к провайдерам:
```dart
class MyScreen extends ConsumerWidget {
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(myProvider);
    return Text(data);
  }
}
```

### ref.watch() vs ref.read()
- `ref.watch()` - подписка на изменения, перестройка UI
- `ref.read()` - одноразовое чтение без подписки

---

## 🧪 Тестирование

Пример теста для провайдера:
```dart
test('TasksNotifier добавляет задачу', () {
  final container = ProviderContainer();
  final notifier = container.read(tasksProvider.notifier);
  
  notifier.addTask('Тест', 'Описание', TaskPriority.high);
  
  final tasks = container.read(tasksProvider);
  expect(tasks.length, 4); // 3 начальные + 1 новая
});
```

---

## 🤝 Вклад

Если вы хотите внести вклад в проект:

1. Fork репозиторий
2. Создайте ветку (`git checkout -b feature/amazing-feature`)
3. Commit изменения (`git commit -m 'Add amazing feature'`)
4. Push в ветку (`git push origin feature/amazing-feature`)
5. Откройте Pull Request

---

## 📄 Лицензия

Этот проект создан в учебных целях.

---

## 📞 Контакты

Если у вас есть вопросы или предложения, создайте Issue в репозитории.

---

## 🎓 Дополнительные ресурсы

- [Официальная документация Riverpod](https://riverpod.dev/)
- [Flutter документация](https://flutter.dev/docs)
- [GoRouter документация](https://pub.dev/packages/go_router)

---

**Удачи в изучении Riverpod! 🚀**

