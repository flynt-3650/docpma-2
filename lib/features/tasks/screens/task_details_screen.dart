import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../presentation/providers/task_providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/models/task_entity.dart';

typedef Task = TaskEntity;

class TaskDetailsScreen extends ConsumerWidget {
  final String taskId;

  const TaskDetailsScreen({super.key, required this.taskId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksState = ref.watch(tasksProvider);
    final task = ref.watch(taskByIdProvider(taskId));
    final timeAsync = ref.watch(timeStreamProvider);

    if (task == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (tasksState.error != null) ...[
                Icon(
                  Icons.error_outline,
                  size: 80,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    tasksState.error!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.read(tasksProvider.notifier).reload(),
                  child: const Text('Повторить'),
                ),
              ] else ...[
                Icon(
                  Icons.search_off_rounded,
                  size: 80,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.3),
                ),
                const SizedBox(height: 16),
                Text(
                  'Задача не найдена',
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      _getCategoryColor(task.category),
                      _getCategoryColor(task.category).withOpacity(0.6),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              task.category.emoji,
                              style: const TextStyle(fontSize: 32),
                            ),
                            const Spacer(),
                            _buildStatusChip(task.status),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          task.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_rounded),
                onPressed: () => context.push('/task/edit/$taskId'),
              ),
              PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: const Row(
                      children: [
                        Icon(Icons.delete_rounded, color: AppColors.error),
                        SizedBox(width: 8),
                        Text(
                          'Удалить',
                          style: TextStyle(color: AppColors.error),
                        ),
                      ],
                    ),
                    onTap: () {
                      Future.delayed(Duration.zero, () {
                        _showDeleteConfirmation(context, ref, task);
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.access_time_rounded,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Текущее время',
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ),
                            const SizedBox(height: 4),
                            timeAsync.when(
                              data: (time) => Text(
                                '${time.hour.toString().padLeft(2, '0')}:'
                                '${time.minute.toString().padLeft(2, '0')}:'
                                '${time.second.toString().padLeft(2, '0')}',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  fontFeatures: [FontFeature.tabularFigures()],
                                ),
                              ),
                              loading: () => const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                              error: (_, __) => const Text('--:--:--'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.description_rounded, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Описание',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          task.description.isEmpty
                              ? 'Описание не указано'
                              : task.description,
                          style: TextStyle(
                            fontSize: 16,
                            color: task.description.isEmpty
                                ? Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withOpacity(0.4)
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildDetailRow(
                          context,
                          icon: Icons.flag_rounded,
                          label: 'Приоритет',
                          value: task.priority.displayName,
                          valueColor: _getPriorityColor(task.priority),
                        ),
                        const Divider(height: 24),
                        _buildDetailRow(
                          context,
                          icon: Icons.category_rounded,
                          label: 'Категория',
                          value:
                              '${task.category.emoji} ${task.category.displayName}',
                        ),
                        const Divider(height: 24),
                        _buildDetailRow(
                          context,
                          icon: Icons.calendar_today_rounded,
                          label: 'Создана',
                          value: _formatDateTime(task.createdAt),
                        ),
                        if (task.dueDate != null) ...[
                          const Divider(height: 24),
                          _buildDetailRow(
                            context,
                            icon: Icons.event_rounded,
                            label: 'Срок выполнения',
                            value: _formatDateTime(task.dueDate!),
                            valueColor: task.isOverdue ? AppColors.error : null,
                            trailing: task.isOverdue
                                ? Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.error.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text(
                                      'Просрочено',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.error,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                        ],
                        if (task.completedAt != null) ...[
                          const Divider(height: 24),
                          _buildDetailRow(
                            context,
                            icon: Icons.check_circle_rounded,
                            label: 'Выполнена',
                            value: _formatDateTime(task.completedAt!),
                            valueColor: AppColors.success,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ref
                              .read(tasksProvider.notifier)
                              .toggleTaskStatus(task.id);
                        },
                        icon: Icon(
                          task.status == TaskStatus.completed
                              ? Icons.refresh_rounded
                              : Icons.check_rounded,
                        ),
                        label: Text(
                          task.status == TaskStatus.completed
                              ? 'Вернуть в работу'
                              : 'Завершить задачу',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: task.status == TaskStatus.completed
                              ? AppColors.warning
                              : AppColors.success,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                OutlinedButton.icon(
                  onPressed: () => context.push('/task/edit/$taskId'),
                  icon: const Icon(Icons.edit_rounded),
                  label: const Text('Редактировать'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),

                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(TaskStatus status) {
    IconData icon;

    switch (status) {
      case TaskStatus.planned:
        icon = Icons.schedule_rounded;
        break;
      case TaskStatus.inProgress:
        icon = Icons.play_arrow_rounded;
        break;
      case TaskStatus.completed:
        icon = Icons.check_rounded;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            status.displayName,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
    Widget? trailing,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: AppColors.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: valueColor,
                ),
              ),
            ],
          ),
        ),
        if (trailing != null) trailing,
      ],
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref, Task task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить задачу?'),
        content: Text('Вы уверены, что хотите удалить задачу "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(tasksProvider.notifier).deleteTask(task.id);
              Navigator.pop(context);
              context.go('/');
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.year} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Color _getCategoryColor(TaskCategory category) {
    switch (category) {
      case TaskCategory.work:
        return AppColors.categoryWork;
      case TaskCategory.personal:
        return AppColors.categoryPersonal;
      case TaskCategory.shopping:
        return AppColors.categoryShopping;
      case TaskCategory.health:
        return AppColors.categoryHealth;
      case TaskCategory.education:
        return AppColors.categoryEducation;
      case TaskCategory.finance:
        return AppColors.categoryFinance;
      case TaskCategory.other:
        return AppColors.categoryOther;
    }
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return AppColors.priorityLow;
      case TaskPriority.medium:
        return AppColors.priorityMedium;
      case TaskPriority.high:
        return AppColors.priorityHigh;
    }
  }
}
