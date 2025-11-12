import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/tasks/models/task.dart';

final counterProvider = StateProvider<int>((ref) => 0);
final appVersionProvider = Provider<String>((ref) => '1.0.0');
final isDarkModeProvider = StateProvider<bool>((ref) => false);
final userNameProvider = StateProvider<String>((ref) => 'Гость');

class TasksNotifier extends StateNotifier<List<Task>> {
  TasksNotifier()
    : super([
        Task(
          id: '1',
          title: 'Купить продукты',
          description: 'Молоко, хлеб, яйца',
          priority: TaskPriority.medium,
          status: TaskStatus.planned,
        ),
        Task(
          id: '2',
          title: 'Позвонить маме',
          description: 'Узнать как дела',
          priority: TaskPriority.high,
          status: TaskStatus.inProgress,
        ),
        Task(
          id: '3',
          title: 'Закончить отчет',
          description: 'Отчет по проекту X',
          priority: TaskPriority.high,
          status: TaskStatus.planned,
        ),
      ]);

  int _counter = 3;

  void addTask(String title, String description, TaskPriority priority) {
    _counter++;
    state = [
      ...state,
      Task(
        id: _counter.toString(),
        title: title,
        description: description,
        priority: priority,
        status: TaskStatus.planned,
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



final timeStreamProvider = StreamProvider<DateTime>((ref) {
  return Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now());
});

final asyncTasksCountProvider = FutureProvider<int>((ref) async {
  await Future.delayed(const Duration(seconds: 2));
  final tasks = ref.watch(tasksProvider);
  return tasks.length;
});

final completedTasksProvider = Provider<List<Task>>((ref) {
  final tasks = ref.watch(tasksProvider);
  return tasks.where((task) => task.status == TaskStatus.completed).toList();
});

final inProgressTasksProvider = Provider<List<Task>>((ref) {
  final tasks = ref.watch(tasksProvider);
  return tasks.where((task) => task.status == TaskStatus.inProgress).toList();
});

final taskByIdProvider = Provider.family<Task?, String>((ref, id) {
  final tasks = ref.watch(tasksProvider);
  try {
    return tasks.firstWhere((task) => task.id == id);
  } catch (e) {
    return null;
  }
});


