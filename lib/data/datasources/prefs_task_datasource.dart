import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../core/exceptions/storage_exceptions.dart';
import '../../core/models/task_entity.dart';

/// Local tasks storage backed by SharedPreferences.
///
/// Stores tasks as JSON string under [_storageKey].
class PrefsTaskDataSource {
  /// Kept as `tasks_data` to support migration from previous versions.
  static const String _storageKey = 'tasks_data';

  SharedPreferences? _prefs;

  Future<SharedPreferences> _getPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<List<TaskEntity>> readAll() async {
    try {
      final prefs = await _getPrefs();
      final raw = prefs.getString(_storageKey);
      if (raw == null || raw.isEmpty) return const [];

      final decoded = json.decode(raw);
      if (decoded is! List) {
        throw const StorageCorruptedDataException(
          'Некорректный формат задач в SharedPreferences (ожидался список)',
        );
      }

      return decoded
          .cast<dynamic>()
          .map(
            (e) => _TaskLocalDto.fromJson(e as Map<String, dynamic>).toModel(),
          )
          .toList(growable: false);
    } on StorageException {
      rethrow;
    } catch (e) {
      throw StorageReadException(
        'Ошибка чтения задач из SharedPreferences',
        cause: e,
      );
    }
  }

  Future<void> writeAll(List<TaskEntity> tasks) async {
    try {
      final prefs = await _getPrefs();
      final list = tasks
          .map((t) => _TaskLocalDto.fromModel(t).toJson())
          .toList();
      await prefs.setString(_storageKey, json.encode(list));
    } catch (e) {
      throw StorageWriteException(
        'Ошибка сохранения задач в SharedPreferences',
        cause: e,
      );
    }
  }

  Future<void> clearAll() async {
    try {
      final prefs = await _getPrefs();
      await prefs.remove(_storageKey);
    } catch (e) {
      throw StorageWriteException(
        'Ошибка очистки задач в SharedPreferences',
        cause: e,
      );
    }
  }
}

/// DTO for local persistence (SharedPreferences).
///
/// Intentionally kept private to avoid leaking outside datasource.
class _TaskLocalDto {
  const _TaskLocalDto({
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

  final String id;
  final String title;
  final String description;
  final int priority;
  final int status;
  final int category;
  final String createdAt;
  final String? dueDate;
  final String? completedAt;

  factory _TaskLocalDto.fromModel(TaskEntity task) {
    return _TaskLocalDto(
      id: task.id,
      title: task.title,
      description: task.description,
      priority: task.priority.index,
      status: task.status.index,
      category: task.category.index,
      createdAt: task.createdAt.toIso8601String(),
      dueDate: task.dueDate?.toIso8601String(),
      completedAt: task.completedAt?.toIso8601String(),
    );
  }

  factory _TaskLocalDto.fromJson(Map<String, dynamic> json) {
    return _TaskLocalDto(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      priority: (json['priority'] as num?)?.toInt() ?? 0,
      status: (json['status'] as num?)?.toInt() ?? 0,
      category: (json['category'] as num?)?.toInt() ?? 0,
      createdAt: (json['createdAt'] ?? '').toString(),
      dueDate: json['dueDate']?.toString(),
      completedAt: json['completedAt']?.toString(),
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

  TaskEntity toModel() {
    return TaskEntity(
      id: id,
      title: title,
      description: description,
      priority: TaskPriority
          .values[priority.clamp(0, TaskPriority.values.length - 1)],
      status: TaskStatus.values[status.clamp(0, TaskStatus.values.length - 1)],
      category: TaskCategory
          .values[category.clamp(0, TaskCategory.values.length - 1)],
      createdAt: DateTime.tryParse(createdAt) ?? DateTime.now(),
      dueDate: dueDate == null ? null : DateTime.tryParse(dueDate!),
      completedAt: completedAt == null ? null : DateTime.tryParse(completedAt!),
    );
  }
}
