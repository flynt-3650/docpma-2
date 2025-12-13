import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../presentation/providers/task_providers.dart';
import '../../../core/theme/app_theme.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(isDarkModeProvider);
    final userName = ref.watch(userNameProvider);
    final appVersion = ref.watch(appVersionProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Настройки')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryDark],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.task_alt_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'TaskMaster Pro',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Версия $appVersion',
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          _buildSectionHeader(context, 'Профиль'),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.primary,
                radius: 24,
                child: Text(
                  userName.isNotEmpty ? userName[0].toUpperCase() : '?',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              title: Text(
                userName,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: const Text('Нажмите, чтобы изменить'),
              trailing: const Icon(Icons.edit_rounded),
              onTap: () => _showEditNameDialog(context, ref),
            ),
          ),

          const SizedBox(height: 24),

          _buildSectionHeader(context, 'Внешний вид'),
          const SizedBox(height: 12),
          Card(
            child: SwitchListTile(
              secondary: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: (isDarkMode ? AppColors.primaryDark : AppColors.accent)
                      .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  isDarkMode
                      ? Icons.dark_mode_rounded
                      : Icons.light_mode_rounded,
                  color: isDarkMode ? AppColors.primaryDark : AppColors.accent,
                ),
              ),
              title: const Text(
                'Тёмная тема',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(isDarkMode ? 'Включена' : 'Выключена'),
              value: isDarkMode,
              onChanged: (value) {
                ref.read(isDarkModeProvider.notifier).setValue(value);
              },
            ),
          ),

          const SizedBox(height: 24),

          _buildSectionHeader(context, 'Навигация'),
          const SizedBox(height: 12),

          Card(
            child: Column(
              children: [
                _NavigationTile(
                  icon: Icons.person_rounded,
                  title: 'Профиль',
                  subtitle: 'Достижения и статистика',
                  onTap: () => context.push('/profile'),
                ),
                const Divider(height: 1),
                _NavigationTile(
                  icon: Icons.bar_chart_rounded,
                  title: 'Статистика',
                  subtitle: 'Аналитика задач',
                  onTap: () => context.push('/statistics'),
                ),
                const Divider(height: 1),
                _NavigationTile(
                  icon: Icons.calendar_month_rounded,
                  title: 'Календарь',
                  subtitle: 'Планирование по дням',
                  onTap: () => context.push('/calendar'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          _buildSectionHeader(context, 'О приложении'),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.code_rounded),
                  title: const Text('Технологии'),
                  subtitle: const Text('Flutter + Riverpod'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(
                    Icons.favorite_rounded,
                    color: AppColors.error,
                  ),
                  title: const Text('Сделано с любовью'),
                  subtitle: const Text('Для демонстрации DI паттернов'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          ElevatedButton.icon(
            onPressed: () => context.go('/'),
            icon: const Icon(Icons.home_rounded),
            label: const Text('На главную'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 56),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  void _showEditNameDialog(BuildContext context, WidgetRef ref) {
    final currentName = ref.read(userNameProvider);
    final controller = TextEditingController(text: currentName);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Изменить имя'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Имя пользователя',
            hintText: 'Введите ваше имя',
            prefixIcon: Icon(Icons.person_rounded),
          ),
          autofocus: true,
          textCapitalization: TextCapitalization.words,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                ref.read(userNameProvider.notifier).setName(controller.text);
              }
              Navigator.pop(context);
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }
}

class _NavigationTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _NavigationTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.primary),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
    );
  }
}
