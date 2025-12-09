import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_client/todo_app_client.dart';
import 'package:todo_app_flutter/features/tasks/data/task_repository.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState>{
  TaskBloc():super(TaskState()){
    on<AddTaskEvent>((event, emit) {
      final updatedTasks = List<Task>.from(state.tasks)..add(event.task);
      emit(state.copyWith(updatedTasks, state.status));
    });

    on<DeleteTaskEvent>((event, emit) {
      final updatedTasks = List<Task>.from(state.tasks)..remove(event.task);
      emit(state.copyWith(updatedTasks, state.status));
    });
    on<UpdateTaskEvent>((event, emit) {
      final updatedTasks = state.tasks.map((task) {
        return task.id == event.task.id ? event.task : task;
      }).toList();
      emit(state.copyWith(updatedTasks, state.status));
    });
    on<LoadTasksEvent>((event, emit) async {
      emit(state.copyWith(state.tasks, TaskStatus.loading));
      try {
        final Client client = Client('baseUrl');
        final TaskRepository repository = TaskRepository(client);
        final tasks = await repository.getAllTasks();
        emit(state.copyWith(tasks, TaskStatus.success));
      } catch (_) {
        emit(state.copyWith(state.tasks, TaskStatus.failure));
      }
    });
  }
}