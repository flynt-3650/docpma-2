import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
    required this.currentStep,
    required this.onStepChanged,
  });

  final int currentStep;
  final Function(int) onStepChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Текущий шаг: $currentStep',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              children: [1, 2, 5, 10].map((step) {
                return ElevatedButton(
                  onPressed: () => onStepChanged(step),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: currentStep == step
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.secondary,
                  ),
                  child: Text('$step'),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
