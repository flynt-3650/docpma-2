import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/file_task_datasource.dart';

class TaskRepositoryImpl implements TaskRepository {
  final FileTaskDataSource _localDataSource;

  TaskRepositoryImpl({required FileTaskDataSource localDataSource})
    : _localDataSource = localDataSource;

  @override
  Future<List<TaskEntity>> getAllTasks() async {
    return await _localDataSource.getAllTasks();
  }

  @override
  Future<TaskEntity?> getTaskById(String id) async {
    return await _localDataSource.getTaskById(id);
  }

  @override
  Future<void> addTask(TaskEntity task) async {
    await _localDataSource.addTask(task);
  }

  @override
  Future<void> updateTask(TaskEntity task) async {
    await _localDataSource.updateTask(task);
  }

  @override
  Future<void> deleteTask(String id) async {
    await _localDataSource.deleteTask(id);
  }

  @override
  Future<List<TaskEntity>> getTasksByStatus(TaskStatus status) async {
    return await _localDataSource.getTasksByStatus(status);
  }

  @override
  Future<List<TaskEntity>> getTasksByCategory(TaskCategory category) async {
    return await _localDataSource.getTasksByCategory(category);
  }

  @override
  Future<List<TaskEntity>> getOverdueTasks() async {
    return await _localDataSource.getOverdueTasks();
  }

  @override
  Future<List<TaskEntity>> getTodayTasks() async {
    return await _localDataSource.getTodayTasks();
  }
}
