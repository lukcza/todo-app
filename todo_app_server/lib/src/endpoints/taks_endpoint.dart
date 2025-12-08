import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
class TaskEndpoint extends Endpoint {
  Future<List<Task>> getAllTasks(Session session) async {
    return await Task.db.find(
      session,
      orderBy: (t) => t.createdAt,
      );
  }
  Future<Task> addTask(Session session, Task task) async{
    return await Task.db.insertRow(session, task);
  }
  Future<void> updateTask(Session session, Task task) async {
    await Task.db.updateRow(session, task);
  }
  Future<void> deleteTask(Session session, Task task) async {
    await Task.db.deleteRow(session, task);
  }
} 