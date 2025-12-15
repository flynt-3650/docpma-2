import '../../core/models/task_entity.dart';

abstract class TaskRepository {
  Future<List<TaskEntity>> getAllTasks();

  Future<TaskEntity?> getTaskById(String id);

  Future<void> addTask(TaskEntity task);

  Future<void> updateTask(TaskEntity task);

  Future<void> deleteTask(String id);

  Future<List<TaskEntity>> getTasksByStatus(TaskStatus status);

  Future<List<TaskEntity>> getTasksByCategory(TaskCategory category);

  Future<List<TaskEntity>> getOverdueTasks();

  Future<List<TaskEntity>> getTodayTasks();
}
