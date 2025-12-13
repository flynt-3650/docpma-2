/// DTO for local storage representation of a task.
///
/// Stored as JSON in a file.
class LocalTaskDTO {
  final String id;
  final String title;
  final String description;

  /// Enum index: TaskPriority.index
  final int priority;

  /// Enum index: TaskStatus.index
  final int status;

  /// Enum index: TaskCategory.index
  final int category;

  /// ISO string
  final String createdAt;

  /// ISO string
  final String? dueDate;

  /// ISO string
  final String? completedAt;

  const LocalTaskDTO({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    required this.category,
    required this.createdAt,
    this.dueDate,
    this.completedAt,
  });

  factory LocalTaskDTO.fromJson(Map<String, dynamic> json) {
    return LocalTaskDTO(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      priority: json['priority'] as int,
      status: json['status'] as int,
      category: json['category'] as int,
      createdAt: json['createdAt'] as String,
      dueDate: json['dueDate'] as String?,
      completedAt: json['completedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority,
      'status': status,
      'category': category,
      'createdAt': createdAt,
      'dueDate': dueDate,
      'completedAt': completedAt,
    };
  }
}
