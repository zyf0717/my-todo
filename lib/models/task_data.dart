import 'dart:collection';
import 'package:flutter/material.dart';
import 'task.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';

class TaskData extends ChangeNotifier {
  List<Task> _tasks = [];

  TaskData() {
    read();
  }

  void read() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/tasks.json');
    try {
      Map map = jsonDecode(await File(file.path).readAsString());
      for (String key in map.keys) {
        _tasks.add(Task(name: key, isDone: map[key]));
      }
      notifyListeners();
    } catch (e) {
      _tasks = [Task(name: 'Swipe or long press to remove')];
      notifyListeners();
    }
  }

  void save() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/tasks.json');
    Map map = {};
    for (var task in _tasks) {
      map[task.name] = task.isDone;
    }
    await file.writeAsString(jsonEncode(map));
  }

  int get taskCount {
    return _tasks.length;
  }

  UnmodifiableListView<Task> get tasks {
    return UnmodifiableListView(_tasks);
  }

  void addTask(String newTaskTitle) {
    _tasks.add(Task(name: newTaskTitle));
    save();
    notifyListeners();
  }

  void updateTask(Task task) {
    task.toggleDone();
    save();
    notifyListeners();
  }

  void removeTask(int index) {
    _tasks.removeAt(index);
    save();
    notifyListeners();
  }
}
