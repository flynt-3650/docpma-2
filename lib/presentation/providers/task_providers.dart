import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/task_entity.dart';
import '../../dependency_container.dart';
import '../../domain/usecases/task_usecases.dart';
import '../../domain/usecases/settings_usecases.dart';

final getAllTasksUseCaseProvider = Provider<GetAllTasksUseCase>((ref) {
  return di.getAllTasksUseCase;
});

final addTaskUseCaseProvider = Provider<AddTaskUseCase>((ref) {
  return di.addTaskUseCase;
});

final updateTaskUseCaseProvider = Provider<UpdateTaskUseCase>((ref) {
  return di.updateTaskUseCase;
});

final deleteTaskUseCaseProvider = Provider<DeleteTaskUseCase>((ref) {
  return di.deleteTaskUseCase;
});

final toggleTaskStatusUseCaseProvider = Provider<ToggleTaskStatusUseCase>((
  ref,
) {
  return di.toggleTaskStatusUseCase;
});

class TasksUiState {
  final bool isLoading;
  final String? error;
  final List<TaskEntity> tasks;

  const TasksUiState({
    this.isLoading = false,
    this.error,
    this.tasks = const [],
  });

  TasksUiState copyWith({
    bool? isLoading,
    String? error,
    List<TaskEntity>? tasks,
    bool clearError = false,
  }) {
    return TasksUiState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      tasks: tasks ?? this.tasks,
    );
  }
}

class TasksNotifier extends StateNotifier<TasksUiState> {
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
       super(const TasksUiState()) {
    _loadTasks();
  }

  Future<void> reload() => _loadTasks();

  Future<void> _loadTasks() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final tasks = await _getAllTasksUseCase.execute();
      state = state.copyWith(isLoading: false, tasks: tasks);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: asErrorMessage(e));
    }
  }

  Future<void> addTask({
    required String title,
    required String description,
    required TaskPriority priority,
    TaskCategory category = TaskCategory.other,
    DateTime? dueDate,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _addTaskUseCase.execute(
        title: title,
        description: description,
        priority: priority,
        category: category,
        dueDate: dueDate,
      );
      await _loadTasks();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: asErrorMessage(e));
    }
  }

  Future<void> updateTask(TaskEntity task) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _updateTaskUseCase.execute(task);
      await _loadTasks();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: asErrorMessage(e));
    }
  }

  Future<void> deleteTask(String id) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _deleteTaskUseCase.execute(id);
      await _loadTasks();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: asErrorMessage(e));
    }
  }

  Future<void> toggleTaskStatus(String id) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _toggleTaskStatusUseCase.execute(id);
      await _loadTasks();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: asErrorMessage(e));
    }
  }

  TaskEntity? getTaskById(String id) {
    try {
      return state.tasks.firstWhere((task) => task.id == id);
    } catch (_) {
      return null;
    }
  }
}

final tasksProvider = StateNotifierProvider<TasksNotifier, TasksUiState>((ref) {
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
  final tasks = ref.watch(tasksProvider).tasks;
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
  final tasks = ref.watch(tasksProvider).tasks;
  return tasks.where((task) => task.status == TaskStatus.completed).toList();
});

final inProgressTasksProvider = Provider<List<TaskEntity>>((ref) {
  final tasks = ref.watch(tasksProvider).tasks;
  return tasks.where((task) => task.status == TaskStatus.inProgress).toList();
});

final plannedTasksProvider = Provider<List<TaskEntity>>((ref) {
  final tasks = ref.watch(tasksProvider).tasks;
  return tasks.where((task) => task.status == TaskStatus.planned).toList();
});

final overdueTasksProvider = Provider<List<TaskEntity>>((ref) {
  final tasks = ref.watch(tasksProvider).tasks;
  return tasks.where((task) => task.isOverdue).toList();
});

final todayTasksProvider = Provider<List<TaskEntity>>((ref) {
  final tasks = ref.watch(tasksProvider).tasks;
  return tasks.where((task) => task.isDueToday).toList();
});

final tasksByCategoryProvider = Provider<Map<TaskCategory, List<TaskEntity>>>((
  ref,
) {
  final tasks = ref.watch(tasksProvider).tasks;
  final map = <TaskCategory, List<TaskEntity>>{};
  for (final category in TaskCategory.values) {
    map[category] = tasks.where((t) => t.category == category).toList();
  }
  return map;
});

final taskByIdProvider = Provider.family<TaskEntity?, String>((ref, id) {
  final tasks = ref.watch(tasksProvider).tasks;
  try {
    return tasks.firstWhere((task) => task.id == id);
  } catch (e) {
    return null;
  }
});

final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

final tasksForSelectedDateProvider = Provider<List<TaskEntity>>((ref) {
  final tasks = ref.watch(tasksProvider).tasks;
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
  final tasks = ref.watch(tasksProvider).tasks;
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
  return await di.getDarkModeUseCase.execute();
});

final isDarkModeProvider = StateNotifierProvider<DarkModeNotifier, bool>((ref) {
  return DarkModeNotifier(
    getDarkModeUseCase: di.getDarkModeUseCase,
    setDarkModeUseCase: di.setDarkModeUseCase,
    toggleDarkModeUseCase: di.toggleDarkModeUseCase,
  );
});

class DarkModeNotifier extends StateNotifier<bool> {
  final GetDarkModeUseCase _getDarkModeUseCase;
  final SetDarkModeUseCase _setDarkModeUseCase;
  final ToggleDarkModeUseCase _toggleDarkModeUseCase;

  DarkModeNotifier({
    required GetDarkModeUseCase getDarkModeUseCase,
    required SetDarkModeUseCase setDarkModeUseCase,
    required ToggleDarkModeUseCase toggleDarkModeUseCase,
  }) : _getDarkModeUseCase = getDarkModeUseCase,
       _setDarkModeUseCase = setDarkModeUseCase,
       _toggleDarkModeUseCase = toggleDarkModeUseCase,
       super(true) {
    _loadSavedValue();
  }

  Future<void> _loadSavedValue() async {
    state = await _getDarkModeUseCase.execute();
  }

  Future<void> toggle() async {
    state = await _toggleDarkModeUseCase.execute(state);
  }

  Future<void> setValue(bool value) async {
    state = value;
    await _setDarkModeUseCase.execute(value);
  }
}

final userNameAsyncProvider = FutureProvider<String>((ref) async {
  return await di.getUserNameUseCase.execute();
});

final userNameProvider = StateNotifierProvider<UserNameNotifier, String>((ref) {
  return UserNameNotifier(
    getUserNameUseCase: di.getUserNameUseCase,
    setUserNameUseCase: di.setUserNameUseCase,
  );
});

class UserNameNotifier extends StateNotifier<String> {
  final GetUserNameUseCase _getUserNameUseCase;
  final SetUserNameUseCase _setUserNameUseCase;

  UserNameNotifier({
    required GetUserNameUseCase getUserNameUseCase,
    required SetUserNameUseCase setUserNameUseCase,
  }) : _getUserNameUseCase = getUserNameUseCase,
       _setUserNameUseCase = setUserNameUseCase,
       super('Гость') {
    _loadSavedValue();
  }

  Future<void> _loadSavedValue() async {
    state = await _getUserNameUseCase.execute();
  }

  Future<void> setName(String name) async {
    state = name;
    await _setUserNameUseCase.execute(name);
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
  final tasks = ref.watch(tasksProvider).tasks;
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
  final tasks = ref.watch(tasksProvider).tasks;
  return tasks.length;
});
