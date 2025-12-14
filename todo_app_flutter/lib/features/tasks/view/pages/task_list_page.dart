import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_client/todo_app_client.dart';
import 'package:todo_app_flutter/features/tasks/bloc/task_bloc.dart';
import 'package:todo_app_flutter/features/tasks/bloc/task_event.dart';
import 'package:todo_app_flutter/features/tasks/bloc/task_state.dart';
import 'package:todo_app_flutter/features/tasks/view/pages/task_item_add_page.dart';
import 'package:todo_app_flutter/features/tasks/view/pages/task_item_edit_dialog.dart';
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
                key: ValueKey(task.id),
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
                  showDialog(
                    context: context,
                    builder: (context) => TaskItemEditDialog(task: task),
                  );
                  context.read<TaskBloc>().add(LoadTasksEvent());
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
              final reorderedTasks = <Task>[];
              for (int i = 0; i < tasks.length; i++) {
                reorderedTasks.add(tasks[i].copyWith(sortOrder: i));
              }
              context.read<TaskBloc>().add(ReorderTasksEvent(reorderedTasks, oldIndex, newIndex));
            }
          );
        },
      ),
      floatingActionButton: OpenContainer(
        transitionDuration: const Duration(milliseconds: 500),
        closedShape: const CircleBorder(),
        transitionType: ContainerTransitionType.fade,
        closedBuilder: (context,action)=> FloatingActionButton(
          onPressed: action,
          child: const Icon(Icons.add),
        ),
        openBuilder: (context, action) => const TaskItemAddPage(),
      ),
    );
  }
}