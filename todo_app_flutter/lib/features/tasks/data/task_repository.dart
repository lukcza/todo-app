import 'package:todo_app_client/todo_app_client.dart';

class TaskRepository {
  final Client client;
  TaskRepository(this.client);

  Future<List<Task>> getAllTasks() async {
    return await client.task.getAllTasks();
  }
  Future<Task> addTask(Task task) async {
    return await client.task.addTask(task);
  }
  Future<void> updateTask(Task task) async {
    await client.task.updateTask(task);
  }
  Future<void> deleteTask(Task task) async {
    await client.task.deleteTask(task);
  }
}