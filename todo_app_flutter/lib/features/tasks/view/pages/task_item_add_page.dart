import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
class TaskItemAddPage extends StatelessWidget {
  const TaskItemAddPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
      ),
      body: const Center(
        child: Text('Task Item Add Page Content Here'),
      ),
    );
  }
}