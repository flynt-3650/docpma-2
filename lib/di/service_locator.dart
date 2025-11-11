import 'package:get_it/get_it.dart';
import '../features/tasks/models/task.dart';

final locator = GetIt.instance;

class TasksStore {
  final List<Task> _tasks = [];
  int _counter = 0;

  List<Task> get tasks => _tasks;

  void addTask(String title, String description, TaskPriority priority) {
    _counter++;
    final task = Task(
      id: _counter.toString(),
      title: title,
      description: description,
      priority: priority,
      status: TaskStatus.planned,
    );
    _tasks.add(task);
  }

  void updateTask(Task updatedTask) {
    final index = _tasks.indexWhere((task) => task.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
    }
  }

  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
  }

  Task? getTaskById(String id) {
    try {
      return _tasks.firstWhere((task) => task.id == id);
    } catch (e) {
      return null;
    }
  }
}

class SettingsStore {
  String appTheme = 'light';
  bool notificationsEnabled = true;

  void updateTheme(String theme) {
    appTheme = theme;
  }

  void toggleNotifications() {
    notificationsEnabled = !notificationsEnabled;
  }
}

void setupLocator() {
  locator.registerSingleton<TasksStore>(TasksStore());
  locator.registerSingleton<SettingsStore>(SettingsStore());
}
