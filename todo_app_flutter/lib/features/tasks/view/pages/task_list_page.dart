import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_flutter/features/tasks/bloc/task_bloc.dart';
import 'package:todo_app_flutter/features/tasks/bloc/task_event.dart';
import 'package:todo_app_flutter/features/tasks/bloc/task_state.dart';
import 'package:todo_app_flutter/features/tasks/view/pages/task_item_add_page.dart';
import 'package:todo_app_flutter/features/tasks/view/widgets/task_list_item.dart';

class TaskListPage extends StatelessWidget {
  const TaskListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task List'),
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state.status == TaskStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == TaskStatus.failure) {
            return const Center(child: Text('Failed to load tasks'));
          } else if (state.tasks.isEmpty) {
            return const Center(child: Text('No tasks available'));
          }

          return ReorderableListView.builder(
            itemCount: state.tasks.length,
            itemBuilder: (context, index) {
              final task = state.tasks[index];
              return TaskListItem(
                id: task.id!,
                title: task.title,
                description: task.description,
                isCompleted: task.isCompleted,
                onToggle: () {
                  final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
                  context.read<TaskBloc>().add(UpdateTaskEvent(updatedTask));
                },
                onDelete: () {
                  context.read<TaskBloc>().add(DeleteTaskEvent(task));
                },
                onEdit: () {
                  // Navigate to edit page (not implemented here)
                },
              );
              
            },
            onReorder: (oldIndex, newIndex) {
              if (newIndex > oldIndex) {
                newIndex -= 1;
              }
              final tasks = List.of(state.tasks);
              final task = tasks.removeAt(oldIndex);
              tasks.insert(newIndex, task);
              context.read<TaskBloc>().add(ReorderTasksEvent(tasks, oldIndex, newIndex));
            }
          );
        },
      ),
      floatingActionButton: OpenContainer(
        transitionDuration: const Duration(milliseconds: 500),
        closedShape: const CircleBorder(),
        closedBuilder: (context,action)=> FloatingActionButton(
          onPressed: action,
          child: const Icon(Icons.add),
        ),
        openBuilder: (context, action) => const TaskItemAddPage(),
      ),
    );
  }
}