import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/task_repository.dart';
import '../../domain/usecases/task_usecases.dart';
import '../../data/repositories/task_repository_impl.dart';
import '../../data/datasources/file_task_datasource.dart';
import '../../data/datasources/settings_local_datasource.dart';

final fileTaskDataSourceProvider = Provider<FileTaskDataSource>((ref) {
  return FileTaskDataSource();
});

final settingsDataSourceProvider = Provider<SettingsLocalDataSource>((ref) {
  return SettingsLocalDataSource();
});

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final fileDataSource = ref.watch(fileTaskDataSourceProvider);
  return TaskRepositoryImpl(localDataSource: fileDataSource);
});

final getAllTasksUseCaseProvider = Provider<GetAllTasksUseCase>((ref) {
  return GetAllTasksUseCase(ref.watch(taskRepositoryProvider));
});

final addTaskUseCaseProvider = Provider<AddTaskUseCase>((ref) {
  return AddTaskUseCase(ref.watch(taskRepositoryProvider));
});

final updateTaskUseCaseProvider = Provider<UpdateTaskUseCase>((ref) {
  return UpdateTaskUseCase(ref.watch(taskRepositoryProvider));
});

final deleteTaskUseCaseProvider = Provider<DeleteTaskUseCase>((ref) {
  return DeleteTaskUseCase(ref.watch(taskRepositoryProvider));
});

final toggleTaskStatusUseCaseProvider = Provider<ToggleTaskStatusUseCase>((
  ref,
) {
  return ToggleTaskStatusUseCase(ref.watch(taskRepositoryProvider));
});

class TasksNotifier extends StateNotifier<List<TaskEntity>> {
  final GetAllTasksUseCase _getAllTasksUseCase;
  final AddTaskUseCase _addTaskUseCase;
  final UpdateTaskUseCase _updateTaskUseCase;
  final DeleteTaskUseCase _deleteTaskUseCase;
  final ToggleTaskStatusUseCase _toggleTaskStatusUseCase;

  TasksNotifier({
    required GetAllTasksUseCase getAllTasksUseCase,
    required AddTaskUseCase addTaskUseCase,
    required UpdateTaskUseCase updateTaskUseCase,
    required DeleteTaskUseCase deleteTaskUseCase,
    required ToggleTaskStatusUseCase toggleTaskStatusUseCase,
  }) : _getAllTasksUseCase = getAllTasksUseCase,
       _addTaskUseCase = addTaskUseCase,
       _updateTaskUseCase = updateTaskUseCase,
       _deleteTaskUseCase = deleteTaskUseCase,
       _toggleTaskStatusUseCase = toggleTaskStatusUseCase,
       super([]) {
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    state = await _getAllTasksUseCase.execute();
  }

  Future<void> addTask({
    required String title,
    required String description,
    required TaskPriority priority,
    TaskCategory category = TaskCategory.other,
    DateTime? dueDate,
  }) async {
    await _addTaskUseCase.execute(
      title: title,
      description: description,
      priority: priority,
      category: category,
      dueDate: dueDate,
    );
    await _loadTasks();
  }

  Future<void> updateTask(TaskEntity task) async {
    await _updateTaskUseCase.execute(task);
    await _loadTasks();
  }

  Future<void> deleteTask(String id) async {
    await _deleteTaskUseCase.execute(id);
    await _loadTasks();
  }

  Future<void> toggleTaskStatus(String id) async {
    await _toggleTaskStatusUseCase.execute(id);
    await _loadTasks();
  }

  TaskEntity? getTaskById(String id) {
    try {
      return state.firstWhere((task) => task.id == id);
    } catch (e) {
      return null;
    }
  }
}

final tasksProvider = StateNotifierProvider<TasksNotifier, List<TaskEntity>>((
  ref,
) {
  return TasksNotifier(
    getAllTasksUseCase: ref.watch(getAllTasksUseCaseProvider),
    addTaskUseCase: ref.watch(addTaskUseCaseProvider),
    updateTaskUseCase: ref.watch(updateTaskUseCaseProvider),
    deleteTaskUseCase: ref.watch(deleteTaskUseCaseProvider),
    toggleTaskStatusUseCase: ref.watch(toggleTaskStatusUseCaseProvider),
  );
});

enum TaskSortBy { createdAt, dueDate, priority, title }

enum TaskFilter { all, today, overdue, completed }

final taskSortByProvider = StateProvider<TaskSortBy>(
  (ref) => TaskSortBy.createdAt,
);
final taskFilterProvider = StateProvider<TaskFilter>((ref) => TaskFilter.all);
final selectedCategoryProvider = StateProvider<TaskCategory?>((ref) => null);
final searchQueryProvider = StateProvider<String>((ref) => '');

final filteredTasksProvider = Provider<List<TaskEntity>>((ref) {
  final tasks = ref.watch(tasksProvider);
  final filter = ref.watch(taskFilterProvider);
  final category = ref.watch(selectedCategoryProvider);
  final searchQuery = ref.watch(searchQueryProvider).toLowerCase();
  final sortBy = ref.watch(taskSortByProvider);

  var filtered = tasks.where((task) {
    if (category != null && task.category != category) return false;

    if (searchQuery.isNotEmpty) {
      final matchesTitle = task.title.toLowerCase().contains(searchQuery);
      final matchesDescription = task.description.toLowerCase().contains(
        searchQuery,
      );
      if (!matchesTitle && !matchesDescription) return false;
    }

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

final completedTasksProvider = Provider<List<TaskEntity>>((ref) {
  final tasks = ref.watch(tasksProvider);
  return tasks.where((task) => task.status == TaskStatus.completed).toList();
});

final inProgressTasksProvider = Provider<List<TaskEntity>>((ref) {
  final tasks = ref.watch(tasksProvider);
  return tasks.where((task) => task.status == TaskStatus.inProgress).toList();
});

final plannedTasksProvider = Provider<List<TaskEntity>>((ref) {
  final tasks = ref.watch(tasksProvider);
  return tasks.where((task) => task.status == TaskStatus.planned).toList();
});

final overdueTasksProvider = Provider<List<TaskEntity>>((ref) {
  final tasks = ref.watch(tasksProvider);
  return tasks.where((task) => task.isOverdue).toList();
});

final todayTasksProvider = Provider<List<TaskEntity>>((ref) {
  final tasks = ref.watch(tasksProvider);
  return tasks.where((task) => task.isDueToday).toList();
});

final tasksByCategoryProvider = Provider<Map<TaskCategory, List<TaskEntity>>>((
  ref,
) {
  final tasks = ref.watch(tasksProvider);
  final map = <TaskCategory, List<TaskEntity>>{};
  for (final category in TaskCategory.values) {
    map[category] = tasks.where((t) => t.category == category).toList();
  }
  return map;
});

final taskByIdProvider = Provider.family<TaskEntity?, String>((ref, id) {
  final tasks = ref.watch(tasksProvider);
  try {
    return tasks.firstWhere((task) => task.id == id);
  } catch (e) {
    return null;
  }
});

final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

final tasksForSelectedDateProvider = Provider<List<TaskEntity>>((ref) {
  final tasks = ref.watch(tasksProvider);
  final selectedDate = ref.watch(selectedDateProvider);

  return tasks.where((task) {
    if (task.dueDate == null) return false;
    return task.dueDate!.year == selectedDate.year &&
        task.dueDate!.month == selectedDate.month &&
        task.dueDate!.day == selectedDate.day;
  }).toList();
});

final tasksWithDueDatesProvider = Provider<Map<DateTime, List<TaskEntity>>>((
  ref,
) {
  final tasks = ref.watch(tasksProvider);
  final map = <DateTime, List<TaskEntity>>{};

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

final appVersionProvider = Provider<String>((ref) => '2.0.0');

final isDarkModeAsyncProvider = FutureProvider<bool>((ref) async {
  final settingsDataSource = ref.watch(settingsDataSourceProvider);
  return await settingsDataSource.getDarkMode();
});

final isDarkModeProvider = StateNotifierProvider<DarkModeNotifier, bool>((ref) {
  final settingsDataSource = ref.watch(settingsDataSourceProvider);
  return DarkModeNotifier(settingsDataSource);
});

class DarkModeNotifier extends StateNotifier<bool> {
  final SettingsLocalDataSource _settingsDataSource;

  DarkModeNotifier(this._settingsDataSource) : super(true) {
    _loadSavedValue();
  }

  Future<void> _loadSavedValue() async {
    state = await _settingsDataSource.getDarkMode();
  }

  Future<void> toggle() async {
    state = !state;
    await _settingsDataSource.setDarkMode(state);
  }

  Future<void> setValue(bool value) async {
    state = value;
    await _settingsDataSource.setDarkMode(value);
  }
}

final userNameAsyncProvider = FutureProvider<String>((ref) async {
  final settingsDataSource = ref.watch(settingsDataSourceProvider);
  return await settingsDataSource.getUserName();
});

final userNameProvider = StateNotifierProvider<UserNameNotifier, String>((ref) {
  final settingsDataSource = ref.watch(settingsDataSourceProvider);
  return UserNameNotifier(settingsDataSource);
});

class UserNameNotifier extends StateNotifier<String> {
  final SettingsLocalDataSource _settingsDataSource;

  UserNameNotifier(this._settingsDataSource) : super('Гость') {
    _loadSavedValue();
  }

  Future<void> _loadSavedValue() async {
    state = await _settingsDataSource.getUserName();
  }

  Future<void> setName(String name) async {
    state = name;
    await _settingsDataSource.setUserName(name);
  }
}

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

final timeStreamProvider = StreamProvider<DateTime>((ref) {
  return Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now());
});

final asyncTasksCountProvider = FutureProvider<int>((ref) async {
  await Future.delayed(const Duration(seconds: 1));
  final tasks = ref.watch(tasksProvider);
  return tasks.length;
});
