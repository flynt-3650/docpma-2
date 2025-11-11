import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../state/app_state.dart';
import '../models/task.dart';

import 'package:get_it/get_it.dart';

final locator = GetIt.instance;



class TaskFormScreenInherited extends StatefulWidget {
  final Task? task;

  const TaskFormScreenInherited({super.key, this.task});

  @override
  State<TaskFormScreenInherited> createState() =>
      _TaskFormScreenInheritedState();
      
}

class _TaskFormScreenInheritedState extends State<TaskFormScreenInherited> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  TaskPriority _priority = TaskPriority.medium;
  TaskStatus _status = TaskStatus.planned;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController = TextEditingController(
      text: widget.task?.description ?? '',
    );
    _priority = widget.task?.priority ?? TaskPriority.medium;
    _status = widget.task?.status ?? TaskStatus.planned;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      final appState = AppStateScope.of(context);

      if (widget.task == null) {
        appState?.addTask(
          _titleController.text,
          _descriptionController.text,
          _priority,
        );
      } else {
        final updatedTask = widget.task!.copyWith(
          title: _titleController.text,
          description: _descriptionController.text,
          priority: _priority,
          status: _status,
        );
        appState?.updateTask(updatedTask);
      }

      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Новая задача' : 'Редактировать'),
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
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<TaskPriority>(
              value: _priority,
              decoration: const InputDecoration(
                labelText: 'Приоритет',
                border: OutlineInputBorder(),
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
            if (widget.task != null) ...[
              const SizedBox(height: 16),
              DropdownButtonFormField<TaskStatus>(
                value: _status,
                decoration: const InputDecoration(
                  labelText: 'Статус',
                  border: OutlineInputBorder(),
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
            ElevatedButton(
              onPressed: _saveTask,
              child: const Text('Сохранить'),
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
