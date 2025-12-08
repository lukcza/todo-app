import 'package:equatable/equatable.dart';
import 'package:todo_app_client/todo_app_client.dart';

enum TaskStatus { initial, loading, success, failure }
class TaskState extends Equatable{
  List<Task> tasks;
  TaskStatus status;
  final bool showCopmplitedTasks;
  TaskState({this.tasks = const [], this.status = TaskStatus.initial, this.showCopmplitedTasks = true});
  TaskState copyWith(List<Task>? tasks, TaskStatus? status){
    return TaskState(
      tasks: tasks ?? this.tasks,
      status: status ?? this.status,
    );
  }
  @override
  List<Object?> get props => [tasks, status, showCopmplitedTasks];
}