class TaskDTO {
  final String id;
  final String title;
  final String description;
  final int priority;
  final int status;
  final int category;
  final String createdAt;
  final String? dueDate;
  final String? completedAt;

  const TaskDTO({
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

  factory TaskDTO.fromJson(Map<String, dynamic> json) {
    return TaskDTO(
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
