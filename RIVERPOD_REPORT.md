# Отчет по использованию Riverpod в Flutter приложении

## Выбор способа управления состоянием

В рамках выполнения практики был выбран способ управления состоянием **Riverpod**. 

Riverpod - это современная библиотека управления состоянием для Flutter, которая является эволюцией Provider. Она предлагает:
- Компилируемую безопасность
- Отсутствие зависимости от BuildContext в большинстве случаев
- Простое тестирование
- Поддержку множества типов провайдеров для разных задач

## Добавление зависимости

Первым шагом была добавлена зависимость в файл `pubspec.yaml`:

```yaml
dependencies:
  flutter_riverpod: ^2.4.0
```

После этого была выполнена команда для установки зависимости:

```bash
flutter pub get
```

---

## Пример 1: StateNotifierProvider - Список задач

**Файл:** `lib/features/tasks/screens/task_list_screen_riverpod.dart`

### Описание
В первом примере был выбран экран списка задач для демонстрации использования **StateNotifierProvider**. Это наиболее мощный способ управления сложным состоянием с бизнес-логикой.

### Созданные файлы

**1. Провайдер задач** - `lib/riverpod/task_providers.dart`:

```dart
// StateNotifier для управления списком задач
class TasksNotifier extends StateNotifier<List<Task>> {
  TasksNotifier() : super([/* начальные задачи */]);

  void addTask(String title, String description, TaskPriority priority) {
    // Добавление задачи
  }

  void updateTask(Task updatedTask) {
    // Обновление задачи
  }

  void deleteTask(String id) {
    // Удаление задачи
  }
}

// Регистрация провайдера
final tasksProvider = StateNotifierProvider<TasksNotifier, List<Task>>((ref) {
  return TasksNotifier();
});
```

**2. Экран списка задач:**

```dart
class TaskListScreenRiverpod extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Наблюдаем за списком задач
    final tasks = ref.watch(tasksProvider);
    
    // Получаем notifier для вызова методов
    final tasksNotifier = ref.read(tasksProvider.notifier);

    return Scaffold(
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return ListTile(
            title: Text(task.title),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => tasksNotifier.deleteTask(task.id),
            ),
          );
        },
      ),
    );
  }
}
```

### Ключевые особенности:
- `ConsumerWidget` вместо `StatelessWidget` для доступа к `WidgetRef`
- `ref.watch()` для отслеживания изменений и автоматической перестройки UI
- `ref.read()` для одноразового чтения значения без подписки
- Автоматическое обновление UI при изменении списка задач

### Демонстрация экрана:
Экран отображает список задач с возможностью:
- Просмотра всех задач
- Удаления задачи по нажатию на иконку корзины
- Перехода к деталям задачи по нажатию на карточку
- Добавления новой задачи через FloatingActionButton
- Навигации к статистике и настройкам

---

## Пример 2: Provider.family - Форма задачи

**Файл:** `lib/features/tasks/screens/task_form_screen_riverpod.dart`

### Описание
Во втором примере был выбран экран формы создания/редактирования задачи для демонстрации использования **Provider.family** - параметризованного провайдера.

### Созданный провайдер

```dart
// Provider с параметром (Family) для получения задачи по ID
final taskByIdProvider = Provider.family<Task?, String>((ref, id) {
  final tasks = ref.watch(tasksProvider);
  try {
    return tasks.firstWhere((task) => task.id == id);
  } catch (e) {
    return null;
  }
});
```

### Использование в экране

```dart
class TaskFormScreenRiverpod extends ConsumerStatefulWidget {
  final String? taskId;
  const TaskFormScreenRiverpod({super.key, this.taskId});
}

class _TaskFormScreenRiverpodState extends ConsumerState<TaskFormScreenRiverpod> {
  @override
  Widget build(BuildContext context) {
    // Используем Provider.family для получения задачи по ID
    final task = widget.taskId != null
        ? ref.watch(taskByIdProvider(widget.taskId!))
        : null;

    // Если задача найдена, заполняем форму
    if (task != null && _titleController.text.isEmpty) {
      _titleController.text = task.title;
      _descriptionController.text = task.description;
      _priority = task.priority;
      _status = task.status;
    }

    return Scaffold(
      body: Form(
        child: Column(
          children: [
            TextFormField(controller: _titleController),
            TextFormField(controller: _descriptionController),
            DropdownButtonFormField<TaskPriority>(/*...*/),
            ElevatedButton(onPressed: _saveTask),
          ],
        ),
      ),
    );
  }
}
```

### Ключевые особенности:
- `Provider.family` позволяет передать параметр (ID задачи) в провайдер
- Один провайдер может создавать множество экземпляров для разных параметров
- Автоматическое кеширование результатов для каждого уникального параметра
- `ConsumerStatefulWidget` для виджетов с внутренним состоянием

### Демонстрация экрана:
Экран формы позволяет:
- Создать новую задачу (если taskId == null)
- Редактировать существующую задачу (если taskId != null)
- Заполнять поля: название, описание, приоритет, статус
- Сохранять изменения в StateNotifier
- Автоматически получать данные задачи через Provider.family

---

## Пример 3: StreamProvider - Детали задачи

**Файл:** `lib/features/tasks/screens/task_details_screen_riverpod.dart`

### Описание
В третьем примере был выбран экран деталей задачи для демонстрации использования **StreamProvider** - провайдера для работы с потоками данных.

### Созданный провайдер

```dart
// StreamProvider для отображения текущего времени в реальном времени
final timeStreamProvider = StreamProvider<DateTime>((ref) {
  return Stream.periodic(
    const Duration(seconds: 1),
    (_) => DateTime.now(),
  );
});
```

### Использование в экране

```dart
class TaskDetailsScreenRiverpod extends ConsumerWidget {
  final String taskId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Получаем задачу через Provider.family
    final task = ref.watch(taskByIdProvider(taskId));
    
    // Получаем поток времени через StreamProvider
    final timeAsync = ref.watch(timeStreamProvider);

    return Scaffold(
      body: Column(
        children: [
          // Карточка с текущим временем
          Card(
            child: Row(
              children: [
                Icon(Icons.access_time),
                Text('Текущее время: '),
                timeAsync.when(
                  data: (time) => Text(
                    '${time.hour}:${time.minute}:${time.second}',
                  ),
                  loading: () => CircularProgressIndicator(),
                  error: (err, stack) => Text('Ошибка: $err'),
                ),
              ],
            ),
          ),
          
          // Информация о задаче
          Text(task?.title ?? 'Не найдено'),
          Text(task?.description ?? ''),
        ],
      ),
    );
  }
}
```

### Ключевые особенности:
- `StreamProvider` автоматически подписывается на поток при монтировании виджета
- Метод `.when()` для обработки трех состояний: данные, загрузка, ошибка
- Автоматическая отписка от потока при удалении виджета
- Комбинирование нескольких провайдеров в одном экране

### Демонстрация экрана:
Экран деталей задачи отображает:
- Текущее время, обновляющееся каждую секунду (StreamProvider)
- Полную информацию о задаче (Provider.family)
- Приоритет задачи с цветовой индикацией
- Статус задачи
- Кнопки для редактирования и удаления задачи
- Красивый дизайн с карточками и иконками

---

## Пример 4: FutureProvider и Computed Providers - Статистика

**Файл:** `lib/features/tasks/screens/statistics_screen_riverpod.dart`

### Описание
В четвертом примере был выбран экран статистики для демонстрации **FutureProvider** (для асинхронных операций) и **Computed Providers** (для вычисляемых значений).

### Созданные провайдеры

```dart
// FutureProvider для асинхронной загрузки данных
final asyncTasksCountProvider = FutureProvider<int>((ref) async {
  await Future.delayed(const Duration(seconds: 2));
  final tasks = ref.watch(tasksProvider);
  return tasks.length;
});

// Computed providers - зависимые провайдеры
final completedTasksProvider = Provider<List<Task>>((ref) {
  final tasks = ref.watch(tasksProvider);
  return tasks.where((task) => task.status == TaskStatus.completed).toList();
});

final inProgressTasksProvider = Provider<List<Task>>((ref) {
  final tasks = ref.watch(tasksProvider);
  return tasks.where((task) => task.status == TaskStatus.inProgress).toList();
});
```

### Использование в экране

```dart
class StatisticsScreenRiverpod extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Основной провайдер
    final tasks = ref.watch(tasksProvider);
    
    // Computed providers
    final completedTasks = ref.watch(completedTasksProvider);
    final inProgressTasks = ref.watch(inProgressTasksProvider);
    
    // FutureProvider
    final asyncCount = ref.watch(asyncTasksCountProvider);

    return Scaffold(
      body: Column(
        children: [
          // Асинхронная загрузка
          asyncCount.when(
            data: (count) => Text('Загружено задач: $count'),
            loading: () => CircularProgressIndicator(),
            error: (err, stack) => Text('Ошибка: $err'),
          ),
          
          // Статистика из computed providers
          Text('Всего задач: ${tasks.length}'),
          Text('Завершено: ${completedTasks.length}'),
          Text('В работе: ${inProgressTasks.length}'),
          
          // Прогресс бар
          LinearProgressIndicator(
            value: completedTasks.length / tasks.length,
          ),
        ],
      ),
    );
  }
}
```

### Ключевые особенности:
- `FutureProvider` для симуляции асинхронной загрузки с задержкой
- Computed providers автоматически пересчитываются при изменении зависимостей
- Метод `.when()` для FutureProvider обрабатывает состояния загрузки
- Комбинирование нескольких типов провайдеров для сложной статистики

### Демонстрация экрана:
Экран статистики показывает:
- Асинхронную загрузку данных с индикатором прогресса (FutureProvider)
- Общее количество задач
- Статистику по статусам (запланированные, в работе, завершенные)
- Статистику по приоритетам (высокий, средний, низкий)
- Процент выполнения с прогресс-баром
- Красивые карточки с иконками и цветовой индикацией

---

## Пример 5: StateProvider - Настройки

**Файл:** `lib/features/tasks/screens/settings_screen_riverpod.dart`

### Описание
В пятом примере был выбран экран настроек для демонстрации **StateProvider** (для простого состояния) и обычного **Provider** (для неизменяемых значений).

### Созданные провайдеры

```dart
// StateProvider для управления простым состоянием
final counterProvider = StateProvider<int>((ref) => 0);
final isDarkModeProvider = StateProvider<bool>((ref) => false);
final userNameProvider = StateProvider<String>((ref) => 'Гость');

// Обычный Provider для неизменяемых значений
final appVersionProvider = Provider<String>((ref) => '1.0.0');
```

### Использование в экране

```dart
class SettingsScreenRiverpod extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Читаем состояние из StateProvider
    final isDarkMode = ref.watch(isDarkModeProvider);
    final userName = ref.watch(userNameProvider);
    final counter = ref.watch(counterProvider);
    
    // Читаем неизменяемое значение из Provider
    final appVersion = ref.watch(appVersionProvider);

    return Scaffold(
      body: Column(
        children: [
          // Версия приложения (Provider)
          Text('Версия: $appVersion'),
          
          // Имя пользователя (StateProvider)
          Text('Пользователь: $userName'),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => _showEditNameDialog(context, ref),
          ),
          
          // Переключатель темы (StateProvider)
          SwitchListTile(
            title: Text('Темная тема'),
            value: isDarkMode,
            onChanged: (value) {
              ref.read(isDarkModeProvider.notifier).state = value;
            },
          ),
          
          // Счетчик (StateProvider)
          Text('Счетчик: $counter'),
          ElevatedButton(
            onPressed: () {
              ref.read(counterProvider.notifier).state++;
            },
            child: Text('Увеличить'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(counterProvider.notifier).state = 0;
            },
            child: Text('Сбросить'),
          ),
        ],
      ),
    );
  }
}
```

### Ключевые особенности:
- `StateProvider` для простых типов данных (int, bool, String)
- Изменение состояния через `.notifier.state = newValue`
- Обычный `Provider` для неизменяемых значений (версия приложения)
- Простота использования для базовых сценариев

### Демонстрация экрана:
Экран настроек содержит:
- Информацию о версии приложения (неизменяемый Provider)
- Профиль пользователя с возможностью редактирования имени (StateProvider)
- Переключатель темной темы с визуальной индикацией (StateProvider)
- Счетчик действий с кнопками увеличения и сброса (StateProvider)
- Навигацию на главную страницу и к статистике
- Современный дизайн с карточками и иконками

---

## Запуск проекта

Для запуска проекта с Riverpod необходимо:

1. Изменить точку входа в `main_riverpod.dart`:
```dart
void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
```

2. Обернуть приложение в `ProviderScope` - это обязательный корневой виджет для Riverpod.

3. Запустить приложение:
```bash
flutter run lib/main_riverpod.dart
```

---

## Преимущества Riverpod

По результатам реализации можно выделить следующие преимущества Riverpod:

1. **Компилируемая безопасность** - все ошибки обнаруживаются на этапе компиляции
2. **Независимость от BuildContext** - провайдеры можно использовать где угодно
3. **Множество типов провайдеров** - для разных задач свой оптимальный провайдер
4. **Автоматическое управление жизненным циклом** - провайдеры автоматически очищаются
5. **Простое тестирование** - легко мокировать провайдеры в тестах
6. **Модульность** - провайдеры легко комбинируются и переиспользуются
7. **Производительность** - оптимальная перестройка виджетов только при необходимости

---

## Заключение

В рамках данной практики были успешно продемонстрированы **5 различных способов использования Riverpod**:

1. ✅ **StateNotifierProvider** - для сложного состояния с бизнес-логикой (список задач)
2. ✅ **Provider.family** - для параметризованных провайдеров (форма редактирования)
3. ✅ **StreamProvider** - для работы с потоками данных (детали задачи с текущим временем)
4. ✅ **FutureProvider и Computed Providers** - для асинхронных операций и вычисляемых значений (статистика)
5. ✅ **StateProvider и Provider** - для простого состояния и неизменяемых значений (настройки)

Каждый пример включает:
- Создание соответствующих провайдеров
- Реализацию экрана с использованием провайдера
- Подробные комментарии и объяснения
- Демонстрацию работы на скриншотах

Все примеры работают в едином приложении и демонстрируют различные аспекты работы с Riverpod в реальных сценариях использования.

