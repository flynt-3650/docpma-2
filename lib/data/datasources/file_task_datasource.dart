import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/task_entity.dart';

class FileTaskDataSource {
  static const String _storageKey = 'tasks_data';

  List<TaskEntity> _tasks = [];
  bool _isInitialized = false;
  int _idCounter = 0;

  Future<void> init() async {
    if (_isInitialized) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final contents = prefs.getString(_storageKey);
      if (contents != null && contents.isNotEmpty) {
        final List<dynamic> jsonList = json.decode(contents);
        _tasks = jsonList.map((json) => _taskFromJson(json)).toList();

        if (_tasks.isNotEmpty) {
          _idCounter = _tasks
              .map((t) => int.tryParse(t.id) ?? 0)
              .reduce((a, b) => a > b ? a : b);
        }
      } else {
        await _createInitialData();
      }
    } catch (e) {
      await _createInitialData();
    }

    _isInitialized = true;
  }

  Future<void> _createInitialData() async {
    _tasks = [
      TaskEntity(
        id: '1',
        title: 'Завершить проект Flutter',
        description: 'Создать полноценное приложение с 7 экранами',
        priority: TaskPriority.high,
        status: TaskStatus.inProgress,
        category: TaskCategory.work,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        dueDate: DateTime.now().add(const Duration(days: 1)),
      ),
      TaskEntity(
        id: '2',
        title: 'Купить продукты',
        description: 'Молоко, хлеб, яйца, овощи',
        priority: TaskPriority.medium,
        status: TaskStatus.planned,
        category: TaskCategory.shopping,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        dueDate: DateTime.now(),
      ),
      TaskEntity(
        id: '3',
        title: 'Тренировка',
        description: 'Пробежка 5км в парке',
        priority: TaskPriority.medium,
        status: TaskStatus.planned,
        category: TaskCategory.health,
        createdAt: DateTime.now(),
        dueDate: DateTime.now().add(const Duration(days: 2)),
      ),
      TaskEntity(
        id: '4',
        title: 'Прочитать книгу',
        description: 'Clean Code - Роберт Мартин',
        priority: TaskPriority.low,
        status: TaskStatus.inProgress,
        category: TaskCategory.education,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      TaskEntity(
        id: '5',
        title: 'Оплатить счета',
        description: 'Интернет, коммунальные услуги',
        priority: TaskPriority.high,
        status: TaskStatus.completed,
        category: TaskCategory.finance,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        completedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      TaskEntity(
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
    _idCounter = 6;
    await _saveToFile();
  }

  Future<void> _saveToFile() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = _tasks.map((task) => _taskToJson(task)).toList();
    await prefs.setString(_storageKey, json.encode(jsonList));
  }

  Map<String, dynamic> _taskToJson(TaskEntity task) {
    return {
      'id': task.id,
      'title': task.title,
      'description': task.description,
      'priority': task.priority.index,
      'status': task.status.index,
      'category': task.category.index,
      'createdAt': task.createdAt.toIso8601String(),
      'dueDate': task.dueDate?.toIso8601String(),
      'completedAt': task.completedAt?.toIso8601String(),
    };
  }

  TaskEntity _taskFromJson(Map<String, dynamic> json) {
    return TaskEntity(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      priority: TaskPriority.values[json['priority']],
      status: TaskStatus.values[json['status']],
      category: TaskCategory.values[json['category']],
      createdAt: DateTime.parse(json['createdAt']),
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
    );
  }

  Future<List<TaskEntity>> getAllTasks() async {
    await init();
    return List.unmodifiable(_tasks);
  }

  Future<TaskEntity?> getTaskById(String id) async {
    await init();
    try {
      return _tasks.firstWhere((task) => task.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> addTask(TaskEntity task) async {
    await init();
    _idCounter++;
    final newTask = TaskEntity(
      id: _idCounter.toString(),
      title: task.title,
      description: task.description,
      priority: task.priority,
      status: task.status,
      category: task.category,
      createdAt: task.createdAt,
      dueDate: task.dueDate,
      completedAt: task.completedAt,
    );
    _tasks.add(newTask);
    await _saveToFile();
  }

  Future<void> updateTask(TaskEntity task) async {
    await init();
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      await _saveToFile();
    }
  }

  Future<void> deleteTask(String id) async {
    await init();
    _tasks.removeWhere((task) => task.id == id);
    await _saveToFile();
  }

  Future<List<TaskEntity>> getTasksByStatus(TaskStatus status) async {
    await init();
    return _tasks.where((task) => task.status == status).toList();
  }

  Future<List<TaskEntity>> getTasksByCategory(TaskCategory category) async {
    await init();
    return _tasks.where((task) => task.category == category).toList();
  }

  Future<List<TaskEntity>> getOverdueTasks() async {
    await init();
    return _tasks.where((task) => task.isOverdue).toList();
  }

  Future<List<TaskEntity>> getTodayTasks() async {
    await init();
    return _tasks.where((task) => task.isDueToday).toList();
  }

  Future<String> exportToJson() async {
    await init();
    final jsonList = _tasks.map((task) => _taskToJson(task)).toList();
    return json.encode(jsonList);
  }

  Future<void> importFromJson(String jsonString) async {
    final List<dynamic> jsonList = json.decode(jsonString);
    _tasks = jsonList.map((json) => _taskFromJson(json)).toList();

    if (_tasks.isNotEmpty) {
      _idCounter = _tasks
          .map((t) => int.tryParse(t.id) ?? 0)
          .reduce((a, b) => a > b ? a : b);
    }

    await _saveToFile();
  }

  Future<void> clearAll() async {
    _tasks.clear();
    _idCounter = 0;
    await _saveToFile();
  }
}
