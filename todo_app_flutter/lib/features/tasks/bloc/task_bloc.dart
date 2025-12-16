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
        emit(state.copyWith(updatedTasks, TaskStatus.initial, state.sortOrder,state.showCopmplitedTasks));
      } catch (e) {
        print(e);
        emit(state.copyWith(state.tasks, TaskStatus.failure, state.sortOrder,state.showCopmplitedTasks));
      }
    });

    on<DeleteTaskEvent>((event, emit) async {
      final updatedTasks = List<Task>.from(state.tasks)..remove(event.task);
      try {
        await _taskRepository.deleteTask(event.task);
        emit(state.copyWith(updatedTasks, state.status, state.sortOrder,state.showCopmplitedTasks));
      } catch (e) {
        print(e);
        emit(state.copyWith(state.tasks, TaskStatus.failure, state.sortOrder,state.showCopmplitedTasks));
      }
    });
    on<UpdateTaskEvent>((event, emit) async {
      final updatedTasks = state.tasks.map((task) {
        return task.id == event.task.id ? event.task : task;
      }).toList();
      try {
        await _taskRepository.updateTask(event.task);
        emit(state.copyWith(updatedTasks, TaskStatus.initial, state.sortOrder,state.showCopmplitedTasks));
      } catch (e) {
        print(e);
        emit(state.copyWith(state.tasks, TaskStatus.failure, state.sortOrder,state.showCopmplitedTasks));
      }
    });
    on<LoadTasksEvent>((event, emit) async {
      emit(state.copyWith(state.tasks, TaskStatus.loading, state.sortOrder,state.showCopmplitedTasks));
      try {
        final tasks = await _taskRepository.getAllTasks();
        emit(state.copyWith(tasks, TaskStatus.success, state.sortOrder,state.showCopmplitedTasks));
      } catch (_) {
        emit(state.copyWith(state.tasks, TaskStatus.failure, state.sortOrder,state.showCopmplitedTasks));
      }
    });
    on<ReorderTasksEvent>((event, emit) async {
      emit(state.copyWith(event.tasks, state.status, SortOrder.custom,state.showCopmplitedTasks));
      try {
        await _taskRepository.reorderTasks(event.tasks);
      } catch (e) {
        print('Error reordering tasks: $e');
        emit(state.copyWith(state.tasks, TaskStatus.failure, state.sortOrder,state.showCopmplitedTasks));
      }
    });
    on<SortTasksEvent>((event, emit) async {
      final sortedTasks = List<Task>.from(state.tasks);
      if (event.order == SortOrder.ascending) {
        sortedTasks.sort((a, b) => a.title.compareTo(b.title));
      } else if (event.order == SortOrder.descending) {
        sortedTasks.sort((a, b) => b.title.compareTo(a.title));
      }
      try{
        await _taskRepository.reorderTasks(sortedTasks);
      } catch (e) {
        print('Error sorting tasks: $e');
        emit(state.copyWith(state.tasks, TaskStatus.failure, state.sortOrder,state.showCopmplitedTasks));  
      }
      emit(state.copyWith(sortedTasks, state.status, event.order,state.showCopmplitedTasks));
    });
    on<VisibilityToggleEvent>((event, emit) async {
      if(event.showCompleted){
        try {
          final tasks = await _taskRepository.getAllTasks();
          final filteredTasks = tasks.where((task) => !task.isCompleted).toList();
          emit(state.copyWith(filteredTasks, state.status, state.sortOrder, true));
         } catch (e) {
          print(e);
          emit(state.copyWith(state.tasks, TaskStatus.failure, state.sortOrder, state.showCopmplitedTasks));
        }
      } else {
        try {
          final tasks = await _taskRepository.getAllTasks();
          emit(state.copyWith(tasks, state.status, state.sortOrder, false));
         } catch (e) {
          print(e);
          emit(state.copyWith(state.tasks, TaskStatus.failure, state.sortOrder, state.showCopmplitedTasks));
        }
      }
    });
  }
}
