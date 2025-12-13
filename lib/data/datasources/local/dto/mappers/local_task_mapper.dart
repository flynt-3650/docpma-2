import '../../../../../core/models/task.dart';
import '../local_task_dto.dart';

extension LocalTaskDtoToModelMapper on LocalTaskDTO {
  TaskEntity toModel() {
    return TaskEntity(
      id: id,
      title: title,
      description: description,
      priority: TaskPriority.values[priority],
      status: TaskStatus.values[status],
      category: TaskCategory.values[category],
      createdAt: DateTime.parse(createdAt),
      dueDate: dueDate == null ? null : DateTime.parse(dueDate!),
      completedAt: completedAt == null ? null : DateTime.parse(completedAt!),
    );
  }
}

extension LocalTaskModelToDtoMapper on TaskEntity {
  LocalTaskDTO toLocalDto() {
    return LocalTaskDTO(
      id: id,
      title: title,
      description: description,
      priority: priority.index,
      status: status.index,
      category: category.index,
      createdAt: createdAt.toIso8601String(),
      dueDate: dueDate?.toIso8601String(),
      completedAt: completedAt?.toIso8601String(),
    );
  }
}
