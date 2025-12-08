import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../riverpod/task_providers.dart';
import '../../../core/theme/app_theme.dart';
import '../models/task.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userName = ref.watch(userNameProvider);
    final stats = ref.watch(userStatsProvider);
    final tasksByCategory = ref.watch(tasksByCategoryProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary,
                      AppColors.primaryDark,
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      // Avatar
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          child: Text(
                            userName.isNotEmpty ? userName[0].toUpperCase() : '?',
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        userName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.stars_rounded,
                              color: Colors.amber,
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${stats.points} очков',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings_rounded),
                onPressed: () => context.push('/settings'),
              ),
            ],
          ),

          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Stats row
                Row(
                  children: [
                    Expanded(
                      child: _StatBox(
                        icon: Icons.assignment_turned_in_rounded,
                        value: stats.completedTasks.toString(),
                        label: 'Выполнено',
                        color: AppColors.success,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatBox(
                        icon: Icons.local_fire_department_rounded,
                        value: '${stats.streak}',
                        label: 'Дней подряд',
                        color: AppColors.accent,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatBox(
                        icon: Icons.percent_rounded,
                        value: '${stats.completionRate.toStringAsFixed(0)}%',
                        label: 'Успешность',
                        color: AppColors.info,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Achievements section
                Row(
                  children: [
                    const Icon(Icons.emoji_events_rounded, color: AppColors.accent),
                    const SizedBox(width: 8),
                    const Text(
                      'Достижения',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Все'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 110,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _AchievementCard(
                        icon: Icons.rocket_launch_rounded,
                        title: 'Первые шаги',
                        description: 'Создай первую задачу',
                        isUnlocked: stats.totalTasks > 0,
                        color: AppColors.info,
                      ),
                      _AchievementCard(
                        icon: Icons.check_circle_rounded,
                        title: 'На старт!',
                        description: 'Выполни 5 задач',
                        isUnlocked: stats.completedTasks >= 5,
                        color: AppColors.success,
                      ),
                      _AchievementCard(
                        icon: Icons.local_fire_department_rounded,
                        title: 'В огне!',
                        description: '7 дней подряд',
                        isUnlocked: stats.streak >= 7,
                        color: AppColors.accent,
                      ),
                      _AchievementCard(
                        icon: Icons.star_rounded,
                        title: 'Мастер',
                        description: '100 очков',
                        isUnlocked: stats.points >= 100,
                        color: AppColors.warning,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Activity by category
                const Row(
                  children: [
                    Icon(Icons.donut_large_rounded, color: AppColors.primary),
                    SizedBox(width: 8),
                    Text(
                      'Активность по категориям',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                ...TaskCategory.values.where((cat) {
                  final tasks = tasksByCategory[cat] ?? [];
                  return tasks.isNotEmpty;
                }).map((category) {
                  final tasks = tasksByCategory[category] ?? [];
                  final completed = tasks
                      .where((t) => t.status == TaskStatus.completed)
                      .length;
                  return _CategoryProgressTile(
                    category: category,
                    completed: completed,
                    total: tasks.length,
                  );
                }),

                const SizedBox(height: 24),

                // Recent activity
                const Row(
                  children: [
                    Icon(Icons.history_rounded, color: AppColors.primary),
                    SizedBox(width: 8),
                    Text(
                      'Недавняя активность',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                Card(
                  child: Column(
                    children: [
                      _ActivityTile(
                        icon: Icons.add_task_rounded,
                        title: 'Создана новая задача',
                        time: 'Сегодня',
                        color: AppColors.success,
                      ),
                      const Divider(height: 1),
                      _ActivityTile(
                        icon: Icons.check_rounded,
                        title: 'Задача выполнена',
                        time: 'Вчера',
                        color: AppColors.info,
                      ),
                      const Divider(height: 1),
                      _ActivityTile(
                        icon: Icons.edit_rounded,
                        title: 'Задача отредактирована',
                        time: '2 дня назад',
                        color: AppColors.warning,
                      ),
                    ],
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
}

class _StatBox extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatBox({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool isUnlocked;
  final Color color;

  const _AchievementCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.isUnlocked,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isUnlocked
            ? color.withOpacity(0.1)
            : Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUnlocked ? color.withOpacity(0.3) : Colors.transparent,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: isUnlocked ? color : Colors.grey,
                size: 24,
              ),
              const Spacer(),
              if (isUnlocked)
                const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.success,
                  size: 18,
                )
              else
                Icon(
                  Icons.lock_rounded,
                  color: Colors.grey.withOpacity(0.5),
                  size: 18,
                ),
            ],
          ),
          const Spacer(),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isUnlocked ? null : Colors.grey,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            description,
            style: TextStyle(
              fontSize: 11,
              color: isUnlocked
                  ? Theme.of(context).colorScheme.onSurface.withOpacity(0.6)
                  : Colors.grey.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryProgressTile extends StatelessWidget {
  final TaskCategory category;
  final int completed;
  final int total;

  const _CategoryProgressTile({
    required this.category,
    required this.completed,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final progress = total > 0 ? completed / total : 0.0;
    final color = _getCategoryColor(category);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              category.emoji,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      category.displayName,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '$completed/$total',
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: color.withOpacity(0.1),
                    valueColor: AlwaysStoppedAnimation(color),
                  ),
                ),
              ],
            ),
          ),
        ],
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

class _ActivityTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String time;
  final Color color;

  const _ActivityTile({
    required this.icon,
    required this.title,
    required this.time,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(title),
      trailing: Text(
        time,
        style: TextStyle(
          fontSize: 13,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
        ),
      ),
    );
  }
}

