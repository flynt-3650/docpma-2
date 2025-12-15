import '../../core/models/task_entity.dart';
import '../repositories/task_repository.dart';

class GetAllTasksUseCase {
  final TaskRepository _repository;

  GetAllTasksUseCase(this._repository);

  Future<List<TaskEntity>> execute() async {
    return await _repository.getAllTasks();
  }
}

class GetTaskByIdUseCase {
  final TaskRepository _repository;

  GetTaskByIdUseCase(this._repository);

  Future<TaskEntity?> execute(String id) async {
    if (id.isEmpty) {
      throw ArgumentError('ID задачи не может быть пустым');
    }
    return await _repository.getTaskById(id);
  }
}

class AddTaskUseCase {
  final TaskRepository _repository;

  AddTaskUseCase(this._repository);

  Future<void> execute({
    required String title,
    required String description,
    required TaskPriority priority,
    TaskCategory category = TaskCategory.other,
    DateTime? dueDate,
  }) async {
    if (title.isEmpty) {
      throw ArgumentError('Название задачи не может быть пустым');
    }

    final task = TaskEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      priority: priority,
      status: TaskStatus.planned,
      category: category,
      dueDate: dueDate,
    );

    await _repository.addTask(task);
  }
}

class UpdateTaskUseCase {
  final TaskRepository _repository;

  UpdateTaskUseCase(this._repository);

  Future<void> execute(TaskEntity task) async {
    if (task.title.isEmpty) {
      throw ArgumentError('Название задачи не может быть пустым');
    }
    await _repository.updateTask(task);
  }
}

class DeleteTaskUseCase {
  final TaskRepository _repository;

  DeleteTaskUseCase(this._repository);

  Future<void> execute(String id) async {
    if (id.isEmpty) {
      throw ArgumentError('ID задачи не может быть пустым');
    }
    await _repository.deleteTask(id);
  }
}

class ToggleTaskStatusUseCase {
  final TaskRepository _repository;

  ToggleTaskStatusUseCase(this._repository);

  Future<void> execute(String id) async {
    final task = await _repository.getTaskById(id);
    if (task == null) {
      throw ArgumentError('Задача не найдена');
    }

    final updatedTask = task.copyWith(
      status: task.status == TaskStatus.completed
          ? TaskStatus.planned
          : TaskStatus.completed,
      completedAt: task.status != TaskStatus.completed ? DateTime.now() : null,
      clearCompletedAt: task.status == TaskStatus.completed,
    );

    await _repository.updateTask(updatedTask);
  }
}

class GetTasksByStatusUseCase {
  final TaskRepository _repository;

  GetTasksByStatusUseCase(this._repository);

  Future<List<TaskEntity>> execute(TaskStatus status) async {
    return await _repository.getTasksByStatus(status);
  }
}

class GetOverdueTasksUseCase {
  final TaskRepository _repository;

  GetOverdueTasksUseCase(this._repository);

  Future<List<TaskEntity>> execute() async {
    return await _repository.getOverdueTasks();
  }
}

class GetTodayTasksUseCase {
  final TaskRepository _repository;

  GetTodayTasksUseCase(this._repository);

  Future<List<TaskEntity>> execute() async {
    return await _repository.getTodayTasks();
  }
}
