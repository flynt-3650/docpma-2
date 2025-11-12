import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../riverpod/task_providers.dart';
import '../models/task.dart';

class TaskFormScreenRiverpod extends ConsumerStatefulWidget {
  final String? taskId;

  const TaskFormScreenRiverpod({super.key, this.taskId});

  @override
  ConsumerState<TaskFormScreenRiverpod> createState() =>
      _TaskFormScreenRiverpodState();
}

class _TaskFormScreenRiverpodState
    extends ConsumerState<TaskFormScreenRiverpod> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  TaskPriority _priority = TaskPriority.medium;
  TaskStatus _status = TaskStatus.planned;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      final tasksNotifier = ref.read(tasksProvider.notifier);

      if (widget.taskId == null) {
        tasksNotifier.addTask(
          _titleController.text,
          _descriptionController.text,
          _priority,
        );
      } else {
        final task = ref.read(taskByIdProvider(widget.taskId!));
        if (task != null) {
          final updatedTask = task.copyWith(
            title: _titleController.text,
            description: _descriptionController.text,
            priority: _priority,
            status: _status,
          );
          tasksNotifier.updateTask(updatedTask);
        }
      }

      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.taskId != null
        ? ref.watch(taskByIdProvider(widget.taskId!))
        : null;

    if (task != null && _titleController.text.isEmpty) {
      _titleController.text = task.title;
      _descriptionController.text = task.description;
      _priority = task.priority;
      _status = task.status;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.taskId == null ? 'Новая задача' : 'Редактировать задачу',
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Название',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Введите название';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Описание',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<TaskPriority>(
              value: _priority,
              decoration: const InputDecoration(
                labelText: 'Приоритет',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.priority_high),
              ),
              items: TaskPriority.values.map((priority) {
                return DropdownMenuItem(
                  value: priority,
                  child: Text(_getPriorityName(priority)),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _priority = value!;
                });
              },
            ),
            if (widget.taskId != null) ...[
              const SizedBox(height: 16),
              DropdownButtonFormField<TaskStatus>(
                value: _status,
                decoration: const InputDecoration(
                  labelText: 'Статус',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.info),
                ),
                items: TaskStatus.values.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(_getStatusName(status)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _status = value!;
                  });
                },
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _saveTask,
              icon: const Icon(Icons.save),
              label: const Text('Сохранить'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getPriorityName(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return 'Низкий';
      case TaskPriority.medium:
        return 'Средний';
      case TaskPriority.high:
        return 'Высокий';
    }
  }

  String _getStatusName(TaskStatus status) {
    switch (status) {
      case TaskStatus.planned:
        return 'Запланирована';
      case TaskStatus.inProgress:
        return 'В работе';
      case TaskStatus.completed:
        return 'Завершена';
    }
  }
}
