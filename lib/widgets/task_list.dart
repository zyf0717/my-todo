import 'package:flutter/material.dart';
import 'package:mytodo/widgets/task_tile.dart';
import 'package:provider/provider.dart';
import 'package:mytodo/models/task_data.dart';

class TasksList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskData>(
      builder: (context, taskData, child) {
        return ListView.builder(
          itemBuilder: (context, index) {
            final task = taskData.tasks[index];
            return Dismissible(
              key: Key(task.name),
              child: TaskTile(
                taskTitle: task.name,
                isChecked: task.isDone,
                checkedboxCallback: (bool checkboxState) {
                  taskData.updateTask(task);
                },
                longPressCallback: () {
                  taskData.removeTask(index);
                },
              ),
              onDismissed: (direction) {
                taskData.removeTask(index);
              },
            );
          },
          itemCount: taskData.taskCount,
        );
      },
    );
  }
}
