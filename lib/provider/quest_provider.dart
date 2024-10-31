import 'package:flutter/material.dart';
import 'package:skuld/database/database_service.dart';
import 'package:skuld/models/habit.dart';
import 'package:skuld/models/quest.dart';
import 'package:skuld/models/routine.dart';
import 'package:skuld/models/task.dart';

class QuestProvider with ChangeNotifier {
  final DatabaseService _db = DatabaseService();

  int _currentScreenIndex = 0;
  int get currentScreenIndex => _currentScreenIndex;

  void updateScreenIndex(int index) {
    if (index != _currentScreenIndex) {
      _currentScreenIndex = index;
    }
    notifyListeners();
  }

  // Tasks
  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;

  List<Task> _doneTasks = [];
  List<Task> get doneTasks => _doneTasks;

  Future<void> fetchTasks() async {
    _tasks = await _db.getTasks(false);
    _doneTasks = await _db.getTasks(true);
    notifyListeners();
  }

  Future<void> completeTask(Task task, bool? value) async {
    final bool state = value ?? task.isDone;
    await DatabaseService().completeTask(task.id, state);
    await fetchDoneRates();
    await fetchTasks();
  }


  List<int> _doneRates = [0, 0];
  List<int> get doneRates => _doneRates;

  Future<void> fetchDoneRates() async {
    _doneRates = await  _db.getDoneRates();
  }

  // Habits
  List<Habit> _habits = [];
  List<Habit> get habits => _habits;

  Future<void> fetchHabits() async {
    _habits = await _db.getHabits();
    notifyListeners();
  }

  Future<void> incrementHabitCounter(int index, int habitId) async {
    DateTime now = DateTime.now();
    await _db.incrementHabitCounter(habitId, now);
    _habits[index].counter++;
    _habits[index].lastDateTime = now;
    notifyListeners();
  }

  // Routines
  List<Routine> _routines = [];
  List<Routine> get routines => _routines;

  List<Routine> _doneRoutines = [];
  List<Routine> get doneRoutines => _doneRoutines;

  Future<void> fetchRoutines() async {
    _routines = await _db.getRoutines(false);
    _doneRoutines = await _db.getRoutines(true);
    notifyListeners();
  }

  Future<void> refreshData(QuestType questType, bool isUpdate) async {
    switch (questType) {
      case QuestType.task:
        if (!isUpdate) {
          await fetchDoneRates();
        }
        await fetchTasks();
        break;
      case QuestType.habit:
        await fetchHabits();
        break;
      case QuestType.routine:
        await fetchRoutines();
        break;
    }
  }
}