# Краткое резюме по Riverpod

## Что было сделано

В рамках выполнения практики был выбран способ управления состоянием **Riverpod** и реализованы **5 различных примеров** его использования.

---

## 1. Зависимость

Добавлена зависимость в `pubspec.yaml`:
```yaml
dependencies:
  flutter_riverpod: ^2.4.0
```

---

## 2. Пять примеров использования

### Пример 1: StateNotifierProvider - Список задач
- **Экран:** `task_list_screen_riverpod.dart`
- **Провайдер:** `TasksNotifier` с методами add/update/delete
- **Демонстрирует:** Управление сложным состоянием со списком задач
- **Ключевые особенности:** 
  - `ConsumerWidget`
  - `ref.watch()` для отслеживания изменений
  - `ref.read()` для вызова методов

### Пример 2: Provider.family - Форма задачи
- **Экран:** `task_form_screen_riverpod.dart`
- **Провайдер:** `taskByIdProvider.family<Task?, String>`
- **Демонстрирует:** Параметризованные провайдеры для получения задачи по ID
- **Ключевые особенности:**
  - `ConsumerStatefulWidget`
  - Передача параметра в провайдер
  - Создание/редактирование задач

### Пример 3: StreamProvider - Детали задачи
- **Экран:** `task_details_screen_riverpod.dart`
- **Провайдер:** `timeStreamProvider` - поток с текущим временем
- **Демонстрирует:** Работа с потоками данных (Stream)
- **Ключевые особенности:**
  - `StreamProvider` с обновлением каждую секунду
  - Метод `.when()` для обработки состояний
  - Отображение времени в реальном времени

### Пример 4: FutureProvider и Computed Providers - Статистика
- **Экран:** `statistics_screen_riverpod.dart`
- **Провайдеры:** 
  - `asyncTasksCountProvider` (FutureProvider)
  - `completedTasksProvider` (Computed)
  - `inProgressTasksProvider` (Computed)
- **Демонстрирует:** Асинхронные операции и вычисляемые значения
- **Ключевые особенности:**
  - Симуляция асинхронной загрузки с задержкой
  - Автоматический пересчет зависимых значений
  - Статистика по статусам и приоритетам

### Пример 5: StateProvider - Настройки
- **Экран:** `settings_screen_riverpod.dart`
- **Провайдеры:**
  - `counterProvider` (StateProvider<int>)
  - `isDarkModeProvider` (StateProvider<bool>)
  - `userNameProvider` (StateProvider<String>)
  - `appVersionProvider` (Provider<String>)
- **Демонстрирует:** Простое состояние и неизменяемые значения
- **Ключевые особенности:**
  - Счетчик с кнопками увеличения/сброса
  - Переключатель темной темы
  - Редактирование имени пользователя
  - Отображение версии приложения

---

## 3. Структура файлов

```
lib/
├── main_riverpod.dart                    # Точка входа с ProviderScope
├── riverpod/
│   └── task_providers.dart               # Все провайдеры
└── features/tasks/screens/
    ├── task_list_screen_riverpod.dart    # Пример 1
    ├── task_form_screen_riverpod.dart    # Пример 2
    ├── task_details_screen_riverpod.dart # Пример 3
    ├── statistics_screen_riverpod.dart   # Пример 4
    └── settings_screen_riverpod.dart     # Пример 5
```

---

## 4. Запуск приложения

```bash
flutter run lib/main_riverpod.dart
```

Или для Windows:
```bash
flutter run lib/main_riverpod.dart -d windows
```

---

## 5. Навигация в приложении

- **Главная:** Список задач (`/riverpod`)
- **Новая задача:** `/riverpod/task/new`
- **Детали:** `/riverpod/task/:id`
- **Редактирование:** `/riverpod/task/edit/:id`
- **Статистика:** `/riverpod/statistics`
- **Настройки:** `/riverpod/settings`

---

## 6. Типы провайдеров Riverpod

| Тип провайдера | Использование | Пример |
|----------------|---------------|---------|
| **Provider** | Неизменяемые значения | Версия приложения |
| **StateProvider** | Простое состояние | Счетчик, булевы флаги |
| **StateNotifierProvider** | Сложное состояние | Список задач с CRUD |
| **FutureProvider** | Асинхронные операции | Загрузка данных |
| **StreamProvider** | Потоки данных | Текущее время |
| **Provider.family** | Параметризованные | Задача по ID |

---

## 7. Ключевые концепции

### ConsumerWidget
```dart
class MyScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(myProvider);
    return Text(data);
  }
}
```

### ref.watch() vs ref.read()
- **ref.watch()** - подписка на изменения, перестройка UI
- **ref.read()** - одноразовое чтение без подписки

### ProviderScope
```dart
void main() {
  runApp(
    const ProviderScope(  // Обязательный корневой виджет
      child: MyApp(),
    ),
  );
}
```

---

## 8. Преимущества Riverpod

✅ Компилируемая безопасность  
✅ Независимость от BuildContext  
✅ Множество типов провайдеров  
✅ Автоматическое управление жизненным циклом  
✅ Простое тестирование  
✅ Модульность и переиспользование  
✅ Оптимальная производительность  

---

## 9. Документация

Полное описание с примерами кода: **RIVERPOD_REPORT.md**

