import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../state/task_provider.dart';
import '../widgets/task_card.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Задачи'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              context.push('/statistics');
            },
          ),
        ],
      ),
      body: Consumer<TaskProvider>(
        builder: (context, provider, child) {
          if (provider.tasks.isEmpty) {
            return const Center(child: Text('Нет задач'));
          }

          return ListView.builder(
            itemCount: provider.tasks.length,
            itemBuilder: (context, index) {
              final task = provider.tasks[index];
              return TaskCard(
                task: task,
                onTap: () {
                  context.push('/task/${task.id}');
                },
                onDelete: () {
                  provider.deleteTask(task.id);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/task/new');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
