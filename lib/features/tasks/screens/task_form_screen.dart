import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../dependency_container.dart';
import '../../../presentation/providers/task_providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/models/task_entity.dart';

typedef Task = TaskEntity;

class TaskFormScreen extends ConsumerStatefulWidget {
  final String? taskId;

  const TaskFormScreen({super.key, this.taskId});

  @override
  ConsumerState<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends ConsumerState<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  TaskPriority _priority = TaskPriority.medium;
  TaskStatus _status = TaskStatus.planned;
  TaskCategory _category = TaskCategory.other;
  DateTime? _dueDate;
  bool _isInitialized = false;

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

  void _initializeFromTask(Task task) {
    if (!_isInitialized) {
      _titleController.text = task.title;
      _descriptionController.text = task.description;
      _priority = task.priority;
      _status = task.status;
      _category = task.category;
      _dueDate = task.dueDate;
      _isInitialized = true;
    }
  }

  Future<void> _saveTask() async {
    if (_formKey.currentState!.validate()) {
      final tasksNotifier = ref.read(tasksProvider.notifier);

      try {
        if (widget.taskId == null) {
          await tasksNotifier.addTask(
            title: _titleController.text,
            description: _descriptionController.text,
            priority: _priority,
            category: _category,
            dueDate: _dueDate,
          );
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Задача создана'),
                backgroundColor: AppColors.success,
              ),
            );
            context.pop();
          }
          return;
        } else {
          final task = ref.read(taskByIdProvider(widget.taskId!));
          if (task != null) {
            final updatedTask = task.copyWith(
              title: _titleController.text,
              description: _descriptionController.text,
              priority: _priority,
              status: _status,
              category: _category,
              dueDate: _dueDate,
              clearDueDate: _dueDate == null && task.dueDate != null,
            );
            await tasksNotifier.updateTask(updatedTask);
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Задача обновлена'),
                  backgroundColor: AppColors.success,
                ),
              );
            }
          }
        }

        if (mounted) {
          context.pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Ошибка: ${asErrorMessage(e)}'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }

  Future<void> _selectDueDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? now,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365 * 2)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppColors.primary,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_dueDate ?? now),
      );

      setState(() {
        _dueDate = DateTime(
          picked.year,
          picked.month,
          picked.day,
          time?.hour ?? 23,
          time?.minute ?? 59,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.taskId != null;
    final task = isEditing ? ref.watch(taskByIdProvider(widget.taskId!)) : null;

    if (task != null) {
      _initializeFromTask(task);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Редактировать' : 'Новая задача'),
        actions: [
          TextButton.icon(
            onPressed: _saveTask,
            icon: const Icon(Icons.check_rounded),
            label: const Text('Сохранить'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Название задачи',
                hintText: 'Введите название...',
                prefixIcon: const Icon(Icons.title_rounded),
                suffixIcon: _titleController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _titleController.clear();
                          setState(() {});
                        },
                      )
                    : null,
              ),
              textCapitalization: TextCapitalization.sentences,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Введите название задачи';
                }
                return null;
              },
              onChanged: (_) => setState(() {}),
            ),

            const SizedBox(height: 20),

            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Описание',
                hintText: 'Добавьте описание...',
                prefixIcon: Icon(Icons.description_rounded),
                alignLabelWithHint: true,
              ),
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
            ),

            const SizedBox(height: 24),

            Text(
              'Категория',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: TaskCategory.values.map((category) {
                final isSelected = _category == category;
                return GestureDetector(
                  onTap: () => setState(() => _category = category),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? _getCategoryColor(category)
                          : _getCategoryColor(category).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: isSelected
                          ? null
                          : Border.all(
                              color: _getCategoryColor(
                                category,
                              ).withOpacity(0.3),
                            ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(category.emoji),
                        const SizedBox(width: 8),
                        Text(
                          category.displayName,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? Colors.white
                                : _getCategoryColor(category),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            Text(
              'Приоритет',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: TaskPriority.values.map((priority) {
                final isSelected = _priority == priority;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _priority = priority),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: EdgeInsets.only(
                        right: priority != TaskPriority.high ? 8 : 0,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? _getPriorityColor(priority)
                            : _getPriorityColor(priority).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: isSelected
                            ? null
                            : Border.all(
                                color: _getPriorityColor(
                                  priority,
                                ).withOpacity(0.3),
                              ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.flag_rounded,
                            color: isSelected
                                ? Colors.white
                                : _getPriorityColor(priority),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            priority.displayName,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : _getPriorityColor(priority),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            if (isEditing) ...[
              const SizedBox(height: 24),

              Text(
                'Статус',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: TaskStatus.values.map((status) {
                  final isSelected = _status == status;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _status = status),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: EdgeInsets.only(
                          right: status != TaskStatus.completed ? 8 : 0,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? _getStatusColor(status)
                              : _getStatusColor(status).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: isSelected
                              ? null
                              : Border.all(
                                  color: _getStatusColor(
                                    status,
                                  ).withOpacity(0.3),
                                ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              _getStatusIcon(status),
                              size: 20,
                              color: isSelected
                                  ? Colors.white
                                  : _getStatusColor(status),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              status.displayName,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? Colors.white
                                    : _getStatusColor(status),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],

            const SizedBox(height: 24),

            Text(
              'Срок выполнения',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: _selectDueDate,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).inputDecorationTheme.fillColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.event_rounded,
                      color: _dueDate != null ? AppColors.primary : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _dueDate != null
                            ? _formatDateTime(_dueDate!)
                            : 'Выберите дату и время',
                        style: TextStyle(
                          fontSize: 16,
                          color: _dueDate != null
                              ? null
                              : Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                    ),
                    if (_dueDate != null)
                      GestureDetector(
                        onTap: () => setState(() => _dueDate = null),
                        child: const Icon(Icons.close_rounded),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),
            Row(
              children: [
                _QuickDateButton(
                  label: 'Сегодня',
                  icon: Icons.today_rounded,
                  onTap: () {
                    final now = DateTime.now();
                    setState(() {
                      _dueDate = DateTime(now.year, now.month, now.day, 23, 59);
                    });
                  },
                ),
                const SizedBox(width: 8),
                _QuickDateButton(
                  label: 'Завтра',
                  icon: Icons.event_rounded,
                  onTap: () {
                    final tomorrow = DateTime.now().add(
                      const Duration(days: 1),
                    );
                    setState(() {
                      _dueDate = DateTime(
                        tomorrow.year,
                        tomorrow.month,
                        tomorrow.day,
                        23,
                        59,
                      );
                    });
                  },
                ),
                const SizedBox(width: 8),
                _QuickDateButton(
                  label: 'Неделя',
                  icon: Icons.date_range_rounded,
                  onTap: () {
                    final nextWeek = DateTime.now().add(
                      const Duration(days: 7),
                    );
                    setState(() {
                      _dueDate = DateTime(
                        nextWeek.year,
                        nextWeek.month,
                        nextWeek.day,
                        23,
                        59,
                      );
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 32),

            ElevatedButton.icon(
              onPressed: _saveTask,
              icon: Icon(isEditing ? Icons.save_rounded : Icons.add_rounded),
              label: Text(isEditing ? 'Сохранить изменения' : 'Создать задачу'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
              ),
            ),

            const SizedBox(height: 16),

            if (isEditing)
              OutlinedButton.icon(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.close_rounded),
                label: const Text('Отменить'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                ),
              ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.year} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Color _getCategoryColor(TaskCategory category) {
    switch (category) {
      case TaskCategory.work:
        return AppColors.categoryWork;
      case TaskCategory.personal:
        return AppColors.categoryPersonal;
      case TaskCategory.shopping:
        return AppColors.categoryShopping;
      case TaskCategory.health:
        return AppColors.categoryHealth;
      case TaskCategory.education:
        return AppColors.categoryEducation;
      case TaskCategory.finance:
        return AppColors.categoryFinance;
      case TaskCategory.other:
        return AppColors.categoryOther;
    }
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return AppColors.priorityLow;
      case TaskPriority.medium:
        return AppColors.priorityMedium;
      case TaskPriority.high:
        return AppColors.priorityHigh;
    }
  }

  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.planned:
        return AppColors.info;
      case TaskStatus.inProgress:
        return AppColors.warning;
      case TaskStatus.completed:
        return AppColors.success;
    }
  }

  IconData _getStatusIcon(TaskStatus status) {
    switch (status) {
      case TaskStatus.planned:
        return Icons.schedule_rounded;
      case TaskStatus.inProgress:
        return Icons.play_arrow_rounded;
      case TaskStatus.completed:
        return Icons.check_rounded;
    }
  }
}

class _QuickDateButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _QuickDateButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: AppColors.primary),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
