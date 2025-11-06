import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Настройки')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Настройки приложения', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.go('/');
              },
              child: const Text('Вернуться на главную'),
            ),
          ],
        ),
      ),
    );
  }
}
