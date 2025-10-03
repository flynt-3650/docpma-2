import 'package:flutter/material.dart';

class GradesScreen extends StatefulWidget {
  const GradesScreen({
    super.key,
    required this.tasks,
    required this.onAddTask,
    required this.onRemoveTask,
  });

  final List<String> tasks;
  final Function(String) onAddTask;
  final Function(int) onRemoveTask;

  @override
  State<GradesScreen> createState() => _GradesScreenState();
}

class _GradesScreenState extends State<GradesScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addTask() {
    if (_controller.text.isNotEmpty) {
      widget.onAddTask(_controller.text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Задачи'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Введите задачу',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addTask,
                  child: const Text('Добавить'),
                ),
              ],
            ),
          ),
          Expanded(
            child: widget.tasks.isEmpty
                ? const Center(child: Text('Нет задач'))
                : ListView.builder(
                    itemCount: widget.tasks.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const Icon(Icons.task_alt),
                        title: Text(widget.tasks[index]),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => widget.onRemoveTask(index),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
