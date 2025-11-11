import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../state/app_state.dart';
import '../models/task.dart';

class TaskListScreenInherited extends StatelessWidget {
  const TaskListScreenInherited({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final tasks = appState?.tasks ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Список задач'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () => context.push('/statistics'),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: tasks.isEmpty
          ? const Center(child: Text('Задач пока нет'))
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    title: Text(task.title),
                    subtitle: Text(task.description),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => appState?.deleteTask(task.id),
                    ),
                    onTap: () => context.push('/task/${task.id}'),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/task/new'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
