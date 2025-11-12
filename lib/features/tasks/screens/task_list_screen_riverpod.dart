import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../riverpod/task_providers.dart';
import '../models/task.dart';

class TaskListScreenRiverpod extends ConsumerWidget {
  const TaskListScreenRiverpod({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(tasksProvider);
    final tasksNotifier = ref.read(tasksProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Список задач (Riverpod)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () => context.push('/riverpod/statistics'),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/riverpod/settings'),
          ),
        ],
      ),
      body: tasks.isEmpty
          ? const Center(
              child: Text('Задач пока нет', style: TextStyle(fontSize: 18)),
            )
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  elevation: 2,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _getPriorityColor(task.priority),
                      child: Text(
                        task.id,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      task.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(task.description),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => tasksNotifier.deleteTask(task.id),
                    ),
                    onTap: () => context.push('/riverpod/task/${task.id}'),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/riverpod/task/new'),
        child: const Icon(Icons.add),
      ),
    );
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
}
