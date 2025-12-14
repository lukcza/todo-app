import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_client/todo_app_client.dart';
import 'package:todo_app_flutter/features/tasks/bloc/task_bloc.dart' show TaskBloc;
import 'package:todo_app_flutter/features/tasks/bloc/task_event.dart';
import 'package:todo_app_flutter/features/tasks/bloc/task_state.dart';

class TaskItemAddPage extends StatefulWidget {
  const TaskItemAddPage({Key? key}) : super(key: key);

  @override
  State<TaskItemAddPage> createState() => _TaskItemAddPageState();
}

class _TaskItemAddPageState extends State<TaskItemAddPage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
      ),
      body: BlocListener<TaskBloc, TaskState>(
        listenWhen: (previous, current) {
          return current.tasks.length > previous.tasks.length;
        },
        listener: (context, state) {
          Navigator.of(context).pop();
        },
        child: BlocBuilder<TaskBloc, TaskState>(
          builder: (context, state) {
            return Column(
              children: [
                TextField(
                  controller: _titleController,
                  enabled: state.status != TaskStatus.loading,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                  ),
                ),
                TextField(
                  controller: _descriptionController,
                  enabled: state.status != TaskStatus.loading,
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                  ),
                ),
                IconButton(
                  icon: state.status == TaskStatus.loading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.check, color: Colors.green),
                  onPressed: state.status == TaskStatus.loading
                      ? null
                      : () {
                          context.read<TaskBloc>().add(AddTaskEvent(
                            Task(
                              title: _titleController.text,
                              description: _descriptionController.text,
                              isCompleted: false,
                              createdAt: DateTime.now(),
                              sortOrder: state.tasks.length,
                            ),
                          ));
                        },
                ),
              ],
            );
          },
        ),
      )
    );
  }
}