import 'package:flutter/material.dart';
import 'package:skuld/models/habit.dart';
import 'package:skuld/models/task.dart';

class QuestProvider with ChangeNotifier {
  final List<Task> _tasks = [];
  List<Task> get tasks => _tasks;

  final List<Habit> _habits = [];
  List<Habit> get habits => _habits;

  void addOrUpdateTask(Task newTask, int index) {
    if (index != -1) {
      print(newTask.dueDateTime);
      _tasks[index] = newTask;
    } else {
      _tasks.add(newTask);
    }
    notifyListeners();
  }

  void removeTask(int index) {
    _tasks.removeAt(index);
    notifyListeners();
  }

  void completeTask(int index, bool state) {
    _tasks[index].isDone = state;
    notifyListeners();
  }

  void addOrUpdateHabit(Habit newHabit, int index) {
    if (index != -1) {
      _habits[index] = newHabit;
    } else {
      _habits.add(newHabit);
    }
    notifyListeners();
  }

  void removeHabit(int index) {
    _habits.removeAt(index);
    notifyListeners();
  }
}
