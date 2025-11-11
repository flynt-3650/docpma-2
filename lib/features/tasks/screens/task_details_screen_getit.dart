import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../di/service_locator.dart';
import '../models/task.dart';

class TaskDetailsScreenGetIt extends StatelessWidget {
  final String taskId;

  const TaskDetailsScreenGetIt({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    if (!locator.isRegistered<TasksStore>()) {
      return Scaffold(
        appBar: AppBar(title: const Text('Ошибка')),
        body: const Center(
          child: Text('TasksStore не зарегистрирован в контейнере'),
        ),
      );
    }

    final tasksStore = locator.get<TasksStore>();
    final task = tasksStore.getTaskById(taskId);

    if (task == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Задача не найдена')),
        body: const Center(child: Text('Задача не найдена')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Детали задачи'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.push('/task/${task.id}/edit', extra: task),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              tasksStore.deleteTask(task.id);
              context.pop();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.title, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),
            Text(
              task.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            _buildInfoRow('Приоритет', _getPriorityName(task.priority)),
            const SizedBox(height: 8),
            _buildInfoRow('Статус', _getStatusName(task.status)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(value),
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
}
