import 'package:equatable/equatable.dart';
import 'package:todo_app_client/todo_app_client.dart';

enum TaskStatus { initial, loading, success, failure }
enum SortOrder { ascending, descending, custom }
class TaskState extends Equatable{
  List<Task> tasks;
  TaskStatus status;
  final bool showCopmplitedTasks;
  final SortOrder sortOrder;
  TaskState({this.tasks = const [], this.status = TaskStatus.initial, this.showCopmplitedTasks = true, this.sortOrder = SortOrder.custom});
  TaskState copyWith(List<Task>? tasks, TaskStatus? status, SortOrder? sortOrder, bool? showCopmplitedTasks){
    return TaskState(
      tasks: tasks ?? this.tasks,
      status: status ?? this.status,
      sortOrder: sortOrder ?? this.sortOrder,
      showCopmplitedTasks: showCopmplitedTasks ?? this.showCopmplitedTasks,
    );
  }
  @override
  List<Object?> get props => [tasks, status, showCopmplitedTasks, sortOrder];
}