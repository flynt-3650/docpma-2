import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../state/task_provider.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? task;
  const TaskFormScreen({super.key, this.task});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  TaskPriority _priority = TaskPriority.medium;
  TaskStatus _status = TaskStatus.planned;

  @override
  void initState() {
    super.initState();
    final task = widget.task;
    if (task != null) {
      _titleController.text = task.title;
      _descriptionController.text = task.description;
      _priority = task.priority;
      _status = task.status;
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final provider = Provider.of<TaskProvider>(context, listen: false);

    if (widget.task == null) {
      provider.addTask(
        _titleController.text,
        _descriptionController.text,
        _priority,
      );
    } else {
      provider.updateTask(
        widget.task!.copyWith(
          title: _titleController.text,
          description: _descriptionController.text,
          priority: _priority,
          status: _status,
        ),
      );
    }
    Navigator.pop(context);
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
              decoration: const InputDecoration(labelText: 'Название'),
              validator: (v) => v?.isEmpty ?? true ? 'Введите название' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Описание'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<TaskPriority>(
              value: _priority,
              decoration: const InputDecoration(labelText: 'Приоритет'),
              items: const [
                DropdownMenuItem(
                  value: TaskPriority.low,
                  child: Text('Низкий'),
                ),
                DropdownMenuItem(
                  value: TaskPriority.medium,
                  child: Text('Средний'),
                ),
                DropdownMenuItem(
                  value: TaskPriority.high,
                  child: Text('Высокий'),
                ),
              ],
              onChanged: (v) => setState(() => _priority = v!),
            ),
            if (widget.task != null) ...[
              const SizedBox(height: 16),
              DropdownButtonFormField<TaskStatus>(
                value: _status,
                decoration: const InputDecoration(labelText: 'Статус'),
                items: const [
                  DropdownMenuItem(
                    value: TaskStatus.planned,
                    child: Text('Запланировано'),
                  ),
                  DropdownMenuItem(
                    value: TaskStatus.inProgress,
                    child: Text('В работе'),
                  ),
                  DropdownMenuItem(
                    value: TaskStatus.completed,
                    child: Text('Завершено'),
                  ),
                ],
                onChanged: (v) => setState(() => _status = v!),
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton(onPressed: _save, child: const Text('Сохранить')),
          ],
        ),
      ),
    );
  }
}
