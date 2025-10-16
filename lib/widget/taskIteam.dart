import 'package:flutter/material.dart';

import '../models/tasks_model.dart';


class Taskiteam extends StatelessWidget {
  const Taskiteam({super.key, required this.tasksModel});

  final TasksModel tasksModel;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: tasksModel.isChecked,
        onChanged: (value) {
        },
        shape: const CircleBorder(
          side: BorderSide(
            color: Colors.black,
          ),
        ),
        fillColor: WidgetStateProperty.all(
          Colors.blue,
        ),
        checkColor: Colors.white,
      ),
      contentPadding: EdgeInsetsDirectional.zero,
      title: Text(
        tasksModel.task,
        style: const TextStyle(
          fontSize: 20,
        ),
      ),
      subtitle: Text(
        tasksModel.dueDate,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black54,
        ),
      ),
    );
  }
}
