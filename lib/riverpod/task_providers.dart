import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/tasks/models/task.dart';

final counterProvider = StateProvider<int>((ref) => 0);
final appVersionProvider = Provider<String>((ref) => '2.0.0');
final isDarkModeProvider = StateProvider<bool>((ref) => true);
final userNameProvider = StateProvider<String>((ref) => 'Гость');
final userAvatarProvider = StateProvider<String?>((ref) => null);

enum TaskSortBy { createdAt, dueDate, priority, title }

enum TaskFilter { all, today, overdue, completed }

final taskSortByProvider = StateProvider<TaskSortBy>((ref) => TaskSortBy.createdAt);
final taskFilterProvider = StateProvider<TaskFilter>((ref) => TaskFilter.all);
final selectedCategoryProvider = StateProvider<TaskCategory?>((ref) => null);
final searchQueryProvider = StateProvider<String>((ref) => '');

class TasksNotifier extends StateNotifier<List<Task>> {
  TasksNotifier() : super(_initialTasks);

  static final _initialTasks = [
    Task(
      id: '1',
      title: 'Завершить проект Flutter',
      description: 'Создать полноценное приложение с 7 экранами',
      priority: TaskPriority.high,
      status: TaskStatus.inProgress,
      category: TaskCategory.work,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      dueDate: DateTime.now().add(const Duration(days: 1)),
    ),
    Task(
      id: '2',
      title: 'Купить продукты',
      description: 'Молоко, хлеб, яйца, овощи',
      priority: TaskPriority.medium,
      status: TaskStatus.planned,
      category: TaskCategory.shopping,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      dueDate: DateTime.now(),
    ),
    Task(
      id: '3',
      title: 'Тренировка',
      description: 'Пробежка 5км в парке',
      priority: TaskPriority.medium,
      status: TaskStatus.planned,
      category: TaskCategory.health,
      createdAt: DateTime.now(),
      dueDate: DateTime.now().add(const Duration(days: 2)),
    ),
    Task(
      id: '4',
      title: 'Прочитать книгу',
      description: 'Clean Code - Роберт Мартин',
      priority: TaskPriority.low,
      status: TaskStatus.inProgress,
      category: TaskCategory.education,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Task(
      id: '5',
      title: 'Оплатить счета',
      description: 'Интернет, коммунальные услуги',
      priority: TaskPriority.high,
      status: TaskStatus.completed,
      category: TaskCategory.finance,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      completedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Task(
      id: '6',
      title: 'Позвонить родителям',
      description: 'Узнать как дела, договориться о встрече',
      priority: TaskPriority.high,
      status: TaskStatus.planned,
      category: TaskCategory.personal,
      createdAt: DateTime.now(),
      dueDate: DateTime.now(),
    ),
  ];

  int _counter = 6;

  void addTask({
    required String title,
    required String description,
    required TaskPriority priority,
    TaskCategory category = TaskCategory.other,
    DateTime? dueDate,
    List<String> tags = const [],
  }) {
    _counter++;
    state = [
      ...state,
      Task(
        id: _counter.toString(),
        title: title,
        description: description,
        priority: priority,
        status: TaskStatus.planned,
        category: category,
        dueDate: dueDate,
        tags: tags,
      ),
    ];
  }

  void updateTask(Task updatedTask) {
    state = [
      for (final task in state)
        if (task.id == updatedTask.id) updatedTask else task,
    ];
  }

  void deleteTask(String id) {
    state = state.where((task) => task.id != id).toList();
  }

  void toggleTaskStatus(String id) {
    state = [
      for (final task in state)
        if (task.id == id)
          task.copyWith(
            status: task.status == TaskStatus.completed
                ? TaskStatus.planned
                : TaskStatus.completed,
            completedAt: task.status != TaskStatus.completed
                ? DateTime.now()
                : null,
            clearCompletedAt: task.status == TaskStatus.completed,
          )
        else
          task,
    ];
  }

  Task? getTaskById(String id) {
    try {
      return state.firstWhere((task) => task.id == id);
    } catch (e) {
      return null;
    }
  }
}

final tasksProvider = StateNotifierProvider<TasksNotifier, List<Task>>((ref) {
  return TasksNotifier();
});

final filteredTasksProvider = Provider<List<Task>>((ref) {
  final tasks = ref.watch(tasksProvider);
  final filter = ref.watch(taskFilterProvider);
  final category = ref.watch(selectedCategoryProvider);
  final searchQuery = ref.watch(searchQueryProvider).toLowerCase();
  final sortBy = ref.watch(taskSortByProvider);

  var filtered = tasks.where((task) {
    // Filter by category
    if (category != null && task.category != category) return false;

    // Filter by search query
    if (searchQuery.isNotEmpty) {
      final matchesTitle = task.title.toLowerCase().contains(searchQuery);
      final matchesDescription = task.description.toLowerCase().contains(searchQuery);
      if (!matchesTitle && !matchesDescription) return false;
    }

    // Filter by status/date
    switch (filter) {
      case TaskFilter.all:
        return task.status != TaskStatus.completed;
      case TaskFilter.today:
        return task.isDueToday && task.status != TaskStatus.completed;
      case TaskFilter.overdue:
        return task.isOverdue;
      case TaskFilter.completed:
        return task.status == TaskStatus.completed;
    }
  }).toList();

  // Sort
  filtered.sort((a, b) {
    switch (sortBy) {
      case TaskSortBy.createdAt:
        return b.createdAt.compareTo(a.createdAt);
      case TaskSortBy.dueDate:
        if (a.dueDate == null && b.dueDate == null) return 0;
        if (a.dueDate == null) return 1;
        if (b.dueDate == null) return -1;
        return a.dueDate!.compareTo(b.dueDate!);
      case TaskSortBy.priority:
        return b.priority.index.compareTo(a.priority.index);
      case TaskSortBy.title:
        return a.title.compareTo(b.title);
    }
  });

  return filtered;
});

// ==================== Statistics Providers ====================

final completedTasksProvider = Provider<List<Task>>((ref) {
  final tasks = ref.watch(tasksProvider);
  return tasks.where((task) => task.status == TaskStatus.completed).toList();
});

final inProgressTasksProvider = Provider<List<Task>>((ref) {
  final tasks = ref.watch(tasksProvider);
  return tasks.where((task) => task.status == TaskStatus.inProgress).toList();
});

final plannedTasksProvider = Provider<List<Task>>((ref) {
  final tasks = ref.watch(tasksProvider);
  return tasks.where((task) => task.status == TaskStatus.planned).toList();
});

final overdueTasksProvider = Provider<List<Task>>((ref) {
  final tasks = ref.watch(tasksProvider);
  return tasks.where((task) => task.isOverdue).toList();
});

final todayTasksProvider = Provider<List<Task>>((ref) {
  final tasks = ref.watch(tasksProvider);
  return tasks.where((task) => task.isDueToday).toList();
});

final tasksByCategoryProvider = Provider<Map<TaskCategory, List<Task>>>((ref) {
  final tasks = ref.watch(tasksProvider);
  final map = <TaskCategory, List<Task>>{};
  for (final category in TaskCategory.values) {
    map[category] = tasks.where((t) => t.category == category).toList();
  }
  return map;
});

final taskByIdProvider = Provider.family<Task?, String>((ref, id) {
  final tasks = ref.watch(tasksProvider);
  try {
    return tasks.firstWhere((task) => task.id == id);
  } catch (e) {
    return null;
  }
});

// ==================== Calendar Providers ====================

final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

final tasksForSelectedDateProvider = Provider<List<Task>>((ref) {
  final tasks = ref.watch(tasksProvider);
  final selectedDate = ref.watch(selectedDateProvider);

  return tasks.where((task) {
    if (task.dueDate == null) return false;
    return task.dueDate!.year == selectedDate.year &&
        task.dueDate!.month == selectedDate.month &&
        task.dueDate!.day == selectedDate.day;
  }).toList();
});

final tasksWithDueDatesProvider = Provider<Map<DateTime, List<Task>>>((ref) {
  final tasks = ref.watch(tasksProvider);
  final map = <DateTime, List<Task>>{};

  for (final task in tasks) {
    if (task.dueDate != null) {
      final dateOnly = DateTime(
        task.dueDate!.year,
        task.dueDate!.month,
        task.dueDate!.day,
      );
      map.putIfAbsent(dateOnly, () => []).add(task);
    }
  }

  return map;
});

// ==================== Async Providers ====================

final timeStreamProvider = StreamProvider<DateTime>((ref) {
  return Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now());
});

final asyncTasksCountProvider = FutureProvider<int>((ref) async {
  await Future.delayed(const Duration(seconds: 1));
  final tasks = ref.watch(tasksProvider);
  return tasks.length;
});

// ==================== User Stats Provider ====================

class UserStats {
  final int totalTasks;
  final int completedTasks;
  final int streak;
  final int points;

  UserStats({
    required this.totalTasks,
    required this.completedTasks,
    required this.streak,
    required this.points,
  });

  double get completionRate =>
      totalTasks == 0 ? 0 : (completedTasks / totalTasks) * 100;
}

final userStatsProvider = Provider<UserStats>((ref) {
  final tasks = ref.watch(tasksProvider);
  final completed = tasks.where((t) => t.status == TaskStatus.completed).length;

  return UserStats(
    totalTasks: tasks.length,
    completedTasks: completed,
    streak: 7,
    points: completed * 10,
  );
});
