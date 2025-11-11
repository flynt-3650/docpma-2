import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../di/service_locator.dart';

class TaskListScreenGetIt extends StatefulWidget {
  const TaskListScreenGetIt({super.key});

  @override
  State<TaskListScreenGetIt> createState() => _TaskListScreenGetItState();
}

class _TaskListScreenGetItState extends State<TaskListScreenGetIt> {
  @override
  Widget build(BuildContext context) {
    if (!locator.isRegistered<TasksStore>()) {
      return Scaffold(
        appBar: AppBar(title: const Text('Ошибка')),
        body: const Center(
          child: Text('TasksStore не зарегистрирован в контейнере'),
        ),
      );
    }

    final tasksStore = locator.get<TasksStore>();
    final tasks = tasksStore.tasks;

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
                      onPressed: () {
                        tasksStore.deleteTask(task.id);
                        setState(() {});
                      },
                    ),
                    onTap: () => context.push('/task/${task.id}'),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await context.push('/task/new');
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
