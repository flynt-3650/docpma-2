import '../../core/models/task_entity.dart';

class LocalTaskDataSource {
  final List<TaskEntity> _tasks = [
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

  int _idCounter = 6;

  Future<List<TaskEntity>> getAllTasks() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return List.unmodifiable(_tasks);
  }

  Future<TaskEntity?> getTaskById(String id) async {
    await Future.delayed(const Duration(milliseconds: 50));
    try {
      return _tasks.firstWhere((task) => task.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> addTask(TaskEntity task) async {
    await Future.delayed(const Duration(milliseconds: 50));
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
  }

  Future<void> updateTask(TaskEntity task) async {
    await Future.delayed(const Duration(milliseconds: 50));
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
    }
  }

  Future<void> deleteTask(String id) async {
    await Future.delayed(const Duration(milliseconds: 50));
    _tasks.removeWhere((task) => task.id == id);
  }

  Future<List<TaskEntity>> getTasksByStatus(TaskStatus status) async {
    await Future.delayed(const Duration(milliseconds: 50));
    return _tasks.where((task) => task.status == status).toList();
  }

  Future<List<TaskEntity>> getTasksByCategory(TaskCategory category) async {
    await Future.delayed(const Duration(milliseconds: 50));
    return _tasks.where((task) => task.category == category).toList();
  }

  Future<List<TaskEntity>> getOverdueTasks() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return _tasks.where((task) => task.isOverdue).toList();
  }

  Future<List<TaskEntity>> getTodayTasks() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return _tasks.where((task) => task.isDueToday).toList();
  }
}
