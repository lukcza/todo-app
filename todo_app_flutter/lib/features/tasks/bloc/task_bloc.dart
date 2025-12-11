import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_client/todo_app_client.dart';
import 'package:todo_app_flutter/features/tasks/data/task_repository.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState>{
  final TaskRepository _taskRepository;
  TaskBloc({required TaskRepository taskRepository}) : _taskRepository = taskRepository, super(TaskState()){
    on<AddTaskEvent>((event, emit) {
      final updatedTasks = List<Task>.from(state.tasks)..add(event.task);
      emit(state.copyWith(updatedTasks, state.status));
    });

    on<DeleteTaskEvent>((event, emit) {
      final updatedTasks = List<Task>.from(state.tasks)..remove(event.task);
      _taskRepository.deleteTask(event.task);
      emit(state.copyWith(updatedTasks, state.status));
    });
    on<UpdateTaskEvent>((event, emit) {
      final updatedTasks = state.tasks.map((task) {
        return task.id == event.task.id ? event.task : task;
      }).toList();
      _taskRepository.updateTask(event.task);
      emit(state.copyWith(updatedTasks, state.status));
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
    on<ReorderTasksEvent>((event, emit) {
      final modifedList = List<Task>.from(event.tasks);
      final taskToMove = modifedList.removeAt(event.oldIndex);
      modifedList.insert(event.newIndex, taskToMove);
      final updatedTasks = <Task>[];
      for(int i =0; i< modifedList.length; i++){
         final task = modifedList[i];
         updatedTasks.add(task.copyWith(sortOrder: i));
       }
      _taskRepository.reorderTasks(updatedTasks);
      emit(state.copyWith(updatedTasks, state.status));
    });
  }
}