import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../riverpod/task_providers.dart';
import '../models/task.dart';

class TaskDetailsScreenRiverpod extends ConsumerWidget {
  final String taskId;

  const TaskDetailsScreenRiverpod({super.key, required this.taskId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final task = ref.watch(taskByIdProvider(taskId));
    final timeAsync = ref.watch(timeStreamProvider);

    if (task == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Задача не найдена')),
        body: const Center(
          child: Text('Задача не найдена', style: TextStyle(fontSize: 18)),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Детали задачи (Riverpod)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.push('/riverpod/task/edit/$taskId'),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              ref.read(tasksProvider.notifier).deleteTask(task.id);
              context.pop();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.access_time, color: Colors.blue),
                    const SizedBox(width: 8),
                    const Text(
                      'Текущее время: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    timeAsync.when(
                      data: (time) => Text(
                        '${time.hour.toString().padLeft(2, '0')}:'
                        '${time.minute.toString().padLeft(2, '0')}:'
                        '${time.second.toString().padLeft(2, '0')}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      loading: () => const CircularProgressIndicator(),
                      error: (err, stack) => Text('Ошибка: $err'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              task.title,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(
                      Icons.description,
                      'Описание',
                      task.description,
                    ),
                    const Divider(height: 24),
                    _buildInfoRow(
                      Icons.priority_high,
                      'Приоритет',
                      _getPriorityName(task.priority),
                      color: _getPriorityColor(task.priority),
                    ),
                    const Divider(height: 24),
                    _buildInfoRow(
                      Icons.info,
                      'Статус',
                      _getStatusName(task.status),
                      color: _getStatusColor(task.status),
                    ),
                    const Divider(height: 24),
                    _buildInfoRow(Icons.tag, 'ID задачи', task.id),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () =>
                        context.push('/riverpod/task/edit/$taskId'),
                    icon: const Icon(Icons.edit),
                    label: const Text('Редактировать'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ref.read(tasksProvider.notifier).deleteTask(task.id);
                      context.pop();
                    },
                    icon: const Icon(Icons.delete, color: Colors.red),
                    label: const Text(
                      'Удалить',
                      style: TextStyle(color: Colors.red),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      side: const BorderSide(color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    Color? color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color ?? Colors.grey),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getPriorityName(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return 'Низкий';
      case TaskPriority.medium:
        return 'Средний';
      case TaskPriority.high:
        return 'Высокий';
    }
  }

  String _getStatusName(TaskStatus status) {
    switch (status) {
      case TaskStatus.planned:
        return 'Запланирована';
      case TaskStatus.inProgress:
        return 'В работе';
      case TaskStatus.completed:
        return 'Завершена';
    }
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return Colors.green;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.high:
        return Colors.red;
    }
  }

  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.planned:
        return Colors.blue;
      case TaskStatus.inProgress:
        return Colors.orange;
      case TaskStatus.completed:
        return Colors.green;
    }
  }
}
