import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_client/todo_app_client.dart';
import 'package:todo_app_flutter/features/tasks/bloc/task_bloc.dart';
import 'package:todo_app_flutter/features/tasks/bloc/task_event.dart';
import 'package:todo_app_flutter/features/tasks/bloc/task_state.dart';

class TaskItemEditDialog extends StatefulWidget {
  const TaskItemEditDialog({super.key, required this.task});
  final Task task;
  @override
  State<TaskItemEditDialog> createState() => _TaskItemEditDialogState();
}

class _TaskItemEditDialogState extends State<TaskItemEditDialog> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  @override
  void initState() {
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController =
        TextEditingController(text: widget.task.description);
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(builder: (context, state) {
      return AlertDialog(
        title: const Text('Edit Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
              maxLines: 5,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<TaskBloc>().add(UpdateTaskEvent(Task(
                    id: widget.task.id,
                    title: _titleController.text,
                    description: _descriptionController.text,
                    isCompleted: widget.task.isCompleted,
                    sortOrder: widget.task.sortOrder,
                    createdAt: widget.task.createdAt,
                  )));
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      );
    });
  }
}
