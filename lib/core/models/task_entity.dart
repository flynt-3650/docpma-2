enum TaskStatus { planned, inProgress, completed }

enum TaskPriority { low, medium, high }

enum TaskCategory {
  work,
  personal,
  shopping,
  health,
  education,
  finance,
  other,
}

typedef Task = TaskEntity;

class TaskEntity {
  final String id;
  final String title;
  final String description;
  final TaskPriority priority;
  final TaskStatus status;
  final TaskCategory category;
  final DateTime createdAt;
  final DateTime? dueDate;
  final DateTime? completedAt;

  TaskEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    this.category = TaskCategory.other,
    DateTime? createdAt,
    this.dueDate,
    this.completedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  TaskEntity copyWith({
    String? title,
    String? description,
    TaskPriority? priority,
    TaskStatus? status,
    TaskCategory? category,
    DateTime? dueDate,
    DateTime? completedAt,
    bool clearDueDate = false,
    bool clearCompletedAt = false,
  }) {
    return TaskEntity(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      category: category ?? this.category,
      createdAt: createdAt,
      dueDate: clearDueDate ? null : (dueDate ?? this.dueDate),
      completedAt: clearCompletedAt ? null : (completedAt ?? this.completedAt),
    );
  }

  bool get isOverdue {
    if (dueDate == null || status == TaskStatus.completed) return false;
    return DateTime.now().isAfter(dueDate!);
  }

  bool get isDueToday {
    if (dueDate == null) return false;
    final now = DateTime.now();
    return dueDate!.year == now.year &&
        dueDate!.month == now.month &&
        dueDate!.day == now.day;
  }

  bool get isDueTomorrow {
    if (dueDate == null) return false;
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return dueDate!.year == tomorrow.year &&
        dueDate!.month == tomorrow.month &&
        dueDate!.day == tomorrow.day;
  }
}

extension TaskCategoryExtension on TaskCategory {
  String get displayName {
    switch (this) {
      case TaskCategory.work:
        return 'Работа';
      case TaskCategory.personal:
        return 'Личное';
      case TaskCategory.shopping:
        return 'Покупки';
      case TaskCategory.health:
        return 'Здоровье';
      case TaskCategory.education:
        return 'Обучение';
      case TaskCategory.finance:
        return 'Финансы';
      case TaskCategory.other:
        return 'Другое';
    }
  }

  String get emoji {
    switch (this) {
      case TaskCategory.work:
        return '💼';
      case TaskCategory.personal:
        return '🏠';
      case TaskCategory.shopping:
        return '🛒';
      case TaskCategory.health:
        return '💪';
      case TaskCategory.education:
        return '📚';
      case TaskCategory.finance:
        return '💰';
      case TaskCategory.other:
        return '📌';
    }
  }
}

extension TaskPriorityExtension on TaskPriority {
  String get displayName {
    switch (this) {
      case TaskPriority.low:
        return 'Низкий';
      case TaskPriority.medium:
        return 'Средний';
      case TaskPriority.high:
        return 'Высокий';
    }
  }
}

extension TaskStatusExtension on TaskStatus {
  String get displayName {
    switch (this) {
      case TaskStatus.planned:
        return 'Запланирована';
      case TaskStatus.inProgress:
        return 'В работе';
      case TaskStatus.completed:
        return 'Завершена';
    }
  }
}
