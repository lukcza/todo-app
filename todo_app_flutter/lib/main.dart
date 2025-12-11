import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_client/todo_app_client.dart';
import 'package:flutter/material.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:todo_app_flutter/features/tasks/bloc/task_bloc.dart';
import 'package:todo_app_flutter/features/tasks/bloc/task_event.dart';
import 'package:todo_app_flutter/features/tasks/data/task_repository.dart';
import 'package:todo_app_flutter/features/tasks/view/pages/task_list_page.dart';

var client = Client('http://localhost:8080/')
  ..connectivityMonitor = FlutterConnectivityMonitor();

void main() {

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<TaskRepository>(
          create: (context) => TaskRepository(client),
        ),
      ],
      child: MultiBlocProvider(providers: [
        BlocProvider(create: (context) => TaskBloc(
          taskRepository: context.read<TaskRepository>()
          )..add(LoadTasksEvent())),
      ], child: MaterialApp(
        title: 'Todo App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const TaskListPage(),
      )),
    );
  }
}
