import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../riverpod/task_providers.dart';
import '../../../core/theme/app_theme.dart';
import '../models/task.dart';

class TaskListScreen extends ConsumerWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(filteredTasksProvider);
    final filter = ref.watch(taskFilterProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context, ref),
          SliverToBoxAdapter(
            child: _buildFilterChips(context, ref, filter),
          ),
          if (selectedCategory != null)
            SliverToBoxAdapter(
              child: _buildCategoryBanner(context, ref, selectedCategory),
            ),
          SliverToBoxAdapter(
            child: _buildSearchBar(context, ref),
          ),
          if (tasks.isEmpty)
            SliverFillRemaining(
              child: _buildEmptyState(context, filter),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final task = tasks[index];
                    return _TaskCard(task: task);
                  },
                  childCount: tasks.length,
                ),
              ),
            ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/task/new'),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Новая задача'),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, WidgetRef ref) {
    final overdueCount = ref.watch(overdueTasksProvider).length;

    return SliverAppBar(
      expandedHeight: 120,
      floating: true,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
        title: Row(
          children: [
            const Text(
              'Мои задачи',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            if (overdueCount > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$overdueCount',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary.withOpacity(0.2),
                AppColors.accent.withOpacity(0.1),
              ],
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.calendar_month_rounded),
          onPressed: () => context.push('/calendar'),
          tooltip: 'Календарь',
        ),
        IconButton(
          icon: const Icon(Icons.bar_chart_rounded),
          onPressed: () => context.push('/statistics'),
          tooltip: 'Статистика',
        ),
        IconButton(
          icon: const Icon(Icons.person_rounded),
          onPressed: () => context.push('/profile'),
          tooltip: 'Профиль',
        ),
      ],
    );
  }

  Widget _buildFilterChips(BuildContext context, WidgetRef ref, TaskFilter filter) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _FilterChip(
            label: 'Все',
            icon: Icons.list_rounded,
            isSelected: filter == TaskFilter.all,
            onTap: () => ref.read(taskFilterProvider.notifier).state = TaskFilter.all,
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Сегодня',
            icon: Icons.today_rounded,
            isSelected: filter == TaskFilter.today,
            onTap: () => ref.read(taskFilterProvider.notifier).state = TaskFilter.today,
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Просрочено',
            icon: Icons.warning_rounded,
            isSelected: filter == TaskFilter.overdue,
            onTap: () => ref.read(taskFilterProvider.notifier).state = TaskFilter.overdue,
            color: AppColors.error,
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Выполнено',
            icon: Icons.check_circle_rounded,
            isSelected: filter == TaskFilter.completed,
            onTap: () => ref.read(taskFilterProvider.notifier).state = TaskFilter.completed,
            color: AppColors.success,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBanner(BuildContext context, WidgetRef ref, TaskCategory category) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: _getCategoryColor(category).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _getCategoryColor(category).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Text(
            '${category.emoji} ${category.displayName}',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: _getCategoryColor(category),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => ref.read(selectedCategoryProvider.notifier).state = null,
            child: Icon(
              Icons.close_rounded,
              size: 20,
              color: _getCategoryColor(category),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Поиск задач...',
          prefixIcon: const Icon(Icons.search_rounded),
          suffixIcon: IconButton(
            icon: const Icon(Icons.tune_rounded),
            onPressed: () => _showSortBottomSheet(context, ref),
          ),
        ),
        onChanged: (value) {
          ref.read(searchQueryProvider.notifier).state = value;
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, TaskFilter filter) {
    String message;
    IconData icon;

    switch (filter) {
      case TaskFilter.all:
        message = 'Нет активных задач\nСоздайте новую задачу!';
        icon = Icons.task_alt_rounded;
        break;
      case TaskFilter.today:
        message = 'На сегодня задач нет\nОтличный день для отдыха!';
        icon = Icons.wb_sunny_rounded;
        break;
      case TaskFilter.overdue:
        message = 'Нет просроченных задач\nТак держать!';
        icon = Icons.celebration_rounded;
        break;
      case TaskFilter.completed:
        message = 'Нет выполненных задач\nПора начать!';
        icon = Icons.rocket_launch_rounded;
        break;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: AppColors.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  void _showSortBottomSheet(BuildContext context, WidgetRef ref) {
    final currentSort = ref.read(taskSortByProvider);

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardTheme.color,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Сортировка',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _SortOption(
              icon: Icons.access_time_rounded,
              label: 'По дате создания',
              isSelected: currentSort == TaskSortBy.createdAt,
              onTap: () {
                ref.read(taskSortByProvider.notifier).state = TaskSortBy.createdAt;
                Navigator.pop(context);
              },
            ),
            _SortOption(
              icon: Icons.event_rounded,
              label: 'По сроку выполнения',
              isSelected: currentSort == TaskSortBy.dueDate,
              onTap: () {
                ref.read(taskSortByProvider.notifier).state = TaskSortBy.dueDate;
                Navigator.pop(context);
              },
            ),
            _SortOption(
              icon: Icons.priority_high_rounded,
              label: 'По приоритету',
              isSelected: currentSort == TaskSortBy.priority,
              onTap: () {
                ref.read(taskSortByProvider.notifier).state = TaskSortBy.priority;
                Navigator.pop(context);
              },
            ),
            _SortOption(
              icon: Icons.sort_by_alpha_rounded,
              label: 'По названию',
              isSelected: currentSort == TaskSortBy.title,
              onTap: () {
                ref.read(taskSortByProvider.notifier).state = TaskSortBy.title;
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
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
}

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? color;

  const _FilterChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? AppColors.primary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? chipColor : chipColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : chipColor,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : chipColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SortOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SortOption({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppColors.primary : null,
      ),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          color: isSelected ? AppColors.primary : null,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check_rounded, color: AppColors.primary)
          : null,
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

class _TaskCard extends ConsumerWidget {
  final Task task;

  const _TaskCard({required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_rounded, color: Colors.white),
      ),
      onDismissed: (_) {
        ref.read(tasksProvider.notifier).deleteTask(task.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Задача "${task.title}" удалена'),
            action: SnackBarAction(
              label: 'Отменить',
              onPressed: () {
                // TODO: Implement undo
              },
            ),
          ),
        );
      },
      child: GestureDetector(
        onTap: () => context.push('/task/${task.id}'),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(16),
            border: task.isOverdue
                ? Border.all(color: AppColors.error.withOpacity(0.5), width: 2)
                : null,
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  ref.read(tasksProvider.notifier).toggleTaskStatus(task.id);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: task.status == TaskStatus.completed
                        ? AppColors.success
                        : Colors.transparent,
                    border: Border.all(
                      color: task.status == TaskStatus.completed
                          ? AppColors.success
                          : _getPriorityColor(task.priority),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: task.status == TaskStatus.completed
                      ? const Icon(Icons.check_rounded, size: 18, color: Colors.white)
                      : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          task.category.emoji,
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            task.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              decoration: task.status == TaskStatus.completed
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: task.status == TaskStatus.completed
                                  ? Theme.of(context).colorScheme.onSurface.withOpacity(0.5)
                                  : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (task.description.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        task.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildPriorityBadge(task.priority),
                        if (task.dueDate != null) ...[
                          const SizedBox(width: 8),
                          _buildDueDateBadge(context, task),
                        ],
                        if (task.status == TaskStatus.inProgress) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.info.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.play_arrow_rounded, size: 14, color: AppColors.info),
                                SizedBox(width: 4),
                                Text(
                                  'В работе',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.info,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityBadge(TaskPriority priority) {
    final color = _getPriorityColor(priority);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.flag_rounded, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            priority.displayName,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDueDateBadge(BuildContext context, Task task) {
    Color color;
    String text;

    if (task.isOverdue) {
      color = AppColors.error;
      text = 'Просрочено';
    } else if (task.isDueToday) {
      color = AppColors.warning;
      text = 'Сегодня';
    } else if (task.isDueTomorrow) {
      color = AppColors.info;
      text = 'Завтра';
    } else {
      color = Theme.of(context).colorScheme.onSurface.withOpacity(0.6);
      text = _formatDate(task.dueDate!);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.event_rounded, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month.toString().padLeft(2, '0')}';
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
