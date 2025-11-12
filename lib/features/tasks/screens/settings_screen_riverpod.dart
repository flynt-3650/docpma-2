import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../riverpod/task_providers.dart';

class SettingsScreenRiverpod extends ConsumerWidget {
  const SettingsScreenRiverpod({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(isDarkModeProvider);
    final userName = ref.watch(userNameProvider);
    final appVersion = ref.watch(appVersionProvider);
    final counter = ref.watch(counterProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Настройки (Riverpod)')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: Colors.blue.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.info, color: Colors.blue, size: 32),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Версия приложения',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      Text(
                        appVersion,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Профиль пользователя',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.blue,
                        radius: 30,
                        child: Text(
                          userName.isNotEmpty ? userName[0].toUpperCase() : 'Г',
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Имя пользователя',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              userName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showEditNameDialog(context, ref),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Внешний вид',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          Card(
            child: SwitchListTile(
              title: const Text('Темная тема'),
              subtitle: Text(isDarkMode ? 'Включена' : 'Выключена'),
              secondary: Icon(
                isDarkMode ? Icons.dark_mode : Icons.light_mode,
                color: isDarkMode ? Colors.indigo : Colors.amber,
              ),
              value: isDarkMode,
              onChanged: (value) {
                ref.read(isDarkModeProvider.notifier).state = value;
              },
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Счетчик действий',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    'Количество нажатий:',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$counter',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          ref.read(counterProvider.notifier).state++;
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Увеличить'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          ref.read(counterProvider.notifier).state = 0;
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Сбросить'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.go('/riverpod'),
            icon: const Icon(Icons.home),
            label: const Text('Вернуться на главную'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
          const SizedBox(height: 12),

          OutlinedButton.icon(
            onPressed: () => context.push('/riverpod/statistics'),
            icon: const Icon(Icons.bar_chart),
            label: const Text('Открыть статистику'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditNameDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController(text: ref.read(userNameProvider));

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Изменить имя'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Имя пользователя',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                ref.read(userNameProvider.notifier).state = controller.text;
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
