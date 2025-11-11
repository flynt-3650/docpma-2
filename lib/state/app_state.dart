import 'package:flutter/material.dart';
import '../features/tasks/models/task.dart';

class AppStateScope extends InheritedWidget {
  final List<Task> tasks;
  final Function(String, String, TaskPriority) addTask;
  final Function(Task) updateTask;
  final Function(String) deleteTask;
  final int version;

  const AppStateScope({
    super.key,
    required this.tasks,
    required this.addTask,
    required this.updateTask,
    required this.deleteTask,
    required this.version,
    required super.child,
  });

  static AppStateScope? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppStateScope>();
  }

  @override
  bool updateShouldNotify(AppStateScope oldWidget) {
    return version != oldWidget.version;
  }
}

class AppStateRoot extends StatefulWidget {
  final Widget child;

  const AppStateRoot({super.key, required this.child});

  @override
  State<AppStateRoot> createState() => _AppStateRootState();
}

class _AppStateRootState extends State<AppStateRoot> {
  final List<Task> _tasks = [];
  int _counter = 0;
  int _version = 0;

  void _addTask(String title, String description, TaskPriority priority) {
    setState(() {
      _counter++;
      _version++;
      final task = Task(
        id: _counter.toString(),
        title: title,
        description: description,
        priority: priority,
        status: TaskStatus.planned,
      );
      _tasks.add(task);
    });
  }

  void _updateTask(Task updatedTask) {
    setState(() {
      _version++;
      final index = _tasks.indexWhere((task) => task.id == updatedTask.id);
      if (index != -1) {
        _tasks[index] = updatedTask;
      }
    });
  }

  void _deleteTask(String id) {
    setState(() {
      _version++;
      _tasks.removeWhere((task) => task.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppStateScope(
      tasks: _tasks,
      addTask: _addTask,
      updateTask: _updateTask,
      deleteTask: _deleteTask,
      version: _version,
      child: widget.child,
    );
  }
}
