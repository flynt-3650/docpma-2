import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../models/task.dart';
import '../state/task_provider.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tasks = context.watch<TaskProvider>().tasks;
    final total = tasks.length;
    final completed = tasks
        .where((t) => t.status == TaskStatus.completed)
        .length;
    final inProgress = tasks
        .where((t) => t.status == TaskStatus.inProgress)
        .length;

    return Scaffold(
      appBar: AppBar(title: const Text('Статистика')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Всего задач: $total', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Завершено: $completed', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('В работе: $inProgress', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.replace('/settings');
              },
              child: const Text('Перейти в настройки'),
            ),
          ],
        ),
      ),
    );
  }
}
