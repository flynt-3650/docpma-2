import '../../core/models/task_entity.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/file_task_datasource.dart';
import '../datasources/prefs_task_datasource.dart';

class TaskRepositoryImpl implements TaskRepository {
  TaskRepositoryImpl({
    required FileTaskDataSource secureDataSource,
    required PrefsTaskDataSource prefsDataSource,
  }) : _secure = secureDataSource,
       _prefs = prefsDataSource;

  final FileTaskDataSource _secure;
  final PrefsTaskDataSource _prefs;

  List<TaskEntity>? _cache;

  @override
  Future<List<TaskEntity>> getAllTasks() async {
    await _ensureLoaded();
    return List.unmodifiable(_cache!);
  }

  @override
  Future<TaskEntity?> getTaskById(String id) async {
    await _ensureLoaded();
    try {
      return _cache!.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> addTask(TaskEntity task) async {
    await _ensureLoaded();
    final id = _dedupeId(task.id);
    final finalTask = id == task.id
        ? task
        : TaskEntity(
            id: id,
            title: task.title,
            description: task.description,
            priority: task.priority,
            status: task.status,
            category: task.category,
            createdAt: task.createdAt,
            dueDate: task.dueDate,
            completedAt: task.completedAt,
          );
    _cache!.add(finalTask);
    await _persist();
  }

  @override
  Future<void> updateTask(TaskEntity task) async {
    await _ensureLoaded();
    final idx = _cache!.indexWhere((t) => t.id == task.id);
    if (idx == -1) return;
    _cache![idx] = task;
    await _persist();
  }

  @override
  Future<void> deleteTask(String id) async {
    await _ensureLoaded();
    _cache!.removeWhere((t) => t.id == id);
    await _persist();
  }

  @override
  Future<List<TaskEntity>> getTasksByStatus(TaskStatus status) async {
    await _ensureLoaded();
    return _cache!.where((t) => t.status == status).toList(growable: false);
  }

  @override
  Future<List<TaskEntity>> getTasksByCategory(TaskCategory category) async {
    await _ensureLoaded();
    return _cache!.where((t) => t.category == category).toList(growable: false);
  }

  @override
  Future<List<TaskEntity>> getOverdueTasks() async {
    await _ensureLoaded();
    return _cache!.where((t) => t.isOverdue).toList(growable: false);
  }

  @override
  Future<List<TaskEntity>> getTodayTasks() async {
    await _ensureLoaded();
    return _cache!.where((t) => t.isDueToday).toList(growable: false);
  }

  Future<void> _ensureLoaded() async {
    if (_cache != null) return;

    // Read both sources and pick a "source of truth".
    final secureTasks = await _secure.readAll();
    final prefsTasks = await _prefs.readAll();

    if (secureTasks.isNotEmpty) {
      _cache = secureTasks.toList();
      // Keep both storages in sync.
      await _prefs.writeAll(_cache!);
      return;
    }

    if (prefsTasks.isNotEmpty) {
      _cache = prefsTasks.toList();
      // Migrate to secure storage and keep in sync.
      await _secure.writeAll(_cache!);
      return;
    }

    // No data anywhere -> seed initial demo dataset (business models).
    _cache = _seedInitialTasks();
    await _persist();
  }

  Future<void> _persist() async {
    final data = List<TaskEntity>.from(_cache ?? const []);
    await _secure.writeAll(data);
    await _prefs.writeAll(data);
  }

  String _dedupeId(String preferred) {
    final used = _cache!.any((t) => t.id == preferred);
    if (!used && preferred.isNotEmpty) return preferred;

    final maxId = _cache!
        .map((t) => int.tryParse(t.id) ?? 0)
        .fold<int>(0, (a, b) => a > b ? a : b);
    return (maxId + 1).toString();
  }

  List<TaskEntity> _seedInitialTasks() {
    return [
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
  }
}
