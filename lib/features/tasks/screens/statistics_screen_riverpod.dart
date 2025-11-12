import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../riverpod/task_providers.dart';
import '../models/task.dart';

class StatisticsScreenRiverpod extends ConsumerWidget {
  const StatisticsScreenRiverpod({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(tasksProvider);
    final completedTasks = ref.watch(completedTasksProvider);
    final inProgressTasks = ref.watch(inProgressTasksProvider);
    final asyncCount = ref.watch(asyncTasksCountProvider);

    final total = tasks.length;
    final completed = completedTasks.length;
    final inProgress = inProgressTasks.length;
    final planned = tasks.where((t) => t.status == TaskStatus.planned).length;

    final highPriority = tasks
        .where((t) => t.priority == TaskPriority.high)
        .length;
    final mediumPriority = tasks
        .where((t) => t.priority == TaskPriority.medium)
        .length;
    final lowPriority = tasks
        .where((t) => t.priority == TaskPriority.low)
        .length;

    return Scaffold(
      appBar: AppBar(title: const Text('Статистика (Riverpod)')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.purple.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Асинхронная загрузка (FutureProvider)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    asyncCount.when(
                      data: (count) => Text(
                        'Загружено задач: $count',
                        style: const TextStyle(fontSize: 18),
                      ),
                      loading: () => const Row(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(width: 16),
                          Text('Загрузка данных...'),
                        ],
                      ),
                      error: (err, stack) => Text('Ошибка: $err'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Общая статистика',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            _buildStatCard(
              icon: Icons.list,
              title: 'Всего задач',
              value: total.toString(),
              color: Colors.blue,
            ),
            const SizedBox(height: 12),
            Text(
              'По статусам',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.check_circle,
                    title: 'Завершено',
                    value: completed.toString(),
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.pending,
                    title: 'В работе',
                    value: inProgress.toString(),
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            _buildStatCard(
              icon: Icons.schedule,
              title: 'Запланировано',
              value: planned.toString(),
              color: Colors.blue,
            ),
            const SizedBox(height: 24),
            Text(
              'По приоритетам',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            _buildStatCard(
              icon: Icons.priority_high,
              title: 'Высокий приоритет',
              value: highPriority.toString(),
              color: Colors.red,
            ),
            const SizedBox(height: 12),

            _buildStatCard(
              icon: Icons.priority_high,
              title: 'Средний приоритет',
              value: mediumPriority.toString(),
              color: Colors.orange,
            ),
            const SizedBox(height: 12),

            _buildStatCard(
              icon: Icons.low_priority,
              title: 'Низкий приоритет',
              value: lowPriority.toString(),
              color: Colors.green,
            ),
            const SizedBox(height: 24),
            if (total > 0) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Прогресс выполнения',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      LinearProgressIndicator(
                        value: completed / total,
                        minHeight: 10,
                        backgroundColor: Colors.grey.shade300,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.green,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${(completed / total * 100).toStringAsFixed(1)}% завершено',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),

            ElevatedButton.icon(
              onPressed: () => context.push('/riverpod/settings'),
              icon: const Icon(Icons.settings),
              label: const Text('Перейти в настройки'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
