import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_client/todo_app_client.dart';
import 'package:todo_app_flutter/features/tasks/data/task_repository.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository _taskRepository;
  TaskBloc({required TaskRepository taskRepository})
      : _taskRepository = taskRepository,
        super(TaskState()) {
    on<AddTaskEvent>((event, emit) async {
      try {
        final savedTask = await _taskRepository.addTask(event.task);
        final updatedTasks = List<Task>.from(state.tasks)..add(savedTask);
        emit(state.copyWith(updatedTasks, TaskStatus.initial));
      } catch (e) {
        print(e);
        emit(state.copyWith(state.tasks, TaskStatus.failure));
      }
    });

    on<DeleteTaskEvent>((event, emit) async {
      final updatedTasks = List<Task>.from(state.tasks)..remove(event.task);
      try {
        await _taskRepository.deleteTask(event.task);
        emit(state.copyWith(updatedTasks, state.status));
      } catch (e) {
        print(e);
        emit(state.copyWith(state.tasks, TaskStatus.failure));
      }
    });
    on<UpdateTaskEvent>((event, emit) async {
      final updatedTasks = state.tasks.map((task) {
        return task.id == event.task.id ? event.task : task;
      }).toList();
      try {
        await _taskRepository.updateTask(event.task);
        emit(state.copyWith(updatedTasks, TaskStatus.initial));
      } catch (e) {
        print(e);
        emit(state.copyWith(state.tasks, TaskStatus.failure));
      }
    });
    on<LoadTasksEvent>((event, emit) async {
      emit(state.copyWith(state.tasks, TaskStatus.loading));
      try {
        final tasks = await _taskRepository.getAllTasks();
        emit(state.copyWith(tasks, TaskStatus.success));
      } catch (_) {
        emit(state.copyWith(state.tasks, TaskStatus.failure));
      }
    });
    on<ReorderTasksEvent>((event, emit) async {
      emit(state.copyWith(event.tasks, state.status));
      try {
        await _taskRepository.reorderTasks(event.tasks);
      } catch (e) {
        print('Error reordering tasks: $e');
        emit(state.copyWith(state.tasks, TaskStatus.failure));
      }
    });
    on<SortTasksEvent>((event, emit) async {
      final sortedTasks = List<Task>.from(state.tasks);
      if (event.isAplbethical) {
        sortedTasks.sort((a, b) => a.title.compareTo(b.title));
      } else {
        sortedTasks.sort((a, b) => b.title.compareTo(a.title));
      }
      try{
        await _taskRepository.reorderTasks(sortedTasks);
      } catch (e) {
        print('Error sorting tasks: $e');
        emit(state.copyWith(state.tasks, TaskStatus.failure));  
      }
      emit(state.copyWith(sortedTasks, state.status));
    });
  }
}
