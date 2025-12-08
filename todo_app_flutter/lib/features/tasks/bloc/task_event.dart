import 'package:equatable/equatable.dart';
import 'package:todo_app_client/todo_app_client.dart';

abstract class TaskEvent extends Equatable{}

class LoadTasksEvent extends TaskEvent {
  @override
  List<Object?> get props => [];
}

class AddTaskEvent extends TaskEvent{
  final Task task;
  AddTaskEvent(this.task);
  @override
  List<Object?> get props => [task];
}
class UpdateTaskEvent extends TaskEvent{
  final Task task;
  UpdateTaskEvent(this.task);
  @override
  List<Object?> get props => [task];
}
class DeleteTaskEvent extends TaskEvent{
  final Task task;
  DeleteTaskEvent(this.task);
  @override
  List<Object?> get props => [task];
}
class ReorderTasksEvent extends TaskEvent{
  final List<Task> tasks;
  ReorderTasksEvent(this.tasks);
  @override
  List<Object?> get props => [tasks];
}
