import 'package:flutter/material.dart';

class TaskListItem extends StatelessWidget {
  final int id;
  final String title;
  final String description;
  final bool isCompleted;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const TaskListItem({
    Key? key,
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: isCompleted ? Colors.grey[200] : null,
      leading: Checkbox(
        value: isCompleted,
        onChanged: (_) => onToggle(),
      ),
      title: Text(
        title,
        style: TextStyle(
          decoration: isCompleted ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: Text(description),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: onEdit,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            color: Colors.red,
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
