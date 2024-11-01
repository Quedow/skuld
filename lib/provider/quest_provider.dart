import 'package:flutter/material.dart';
import 'package:skuld/database/database_service.dart';
import 'package:skuld/models/habit.dart';
import 'package:skuld/models/quest.dart';
import 'package:skuld/models/routine.dart';
import 'package:skuld/models/task.dart';
import 'package:skuld/utils/functions.dart';

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

  Future<void> refreshData(QuestType questType, bool isUpdate) async {
    switch (questType) {
      case QuestType.task:
        await fetchTasks();
        if (!isUpdate) {
          await fetchDoneRates();
        }
        break;
      case QuestType.habit:
        await fetchHabits();
        break;
      case QuestType.routine:
        await fetchRoutines();
        break;
    }
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
    await _db.completeTask(task.id, state);
    task.isDone = state;
    if (state) {
      _tasks.remove(task);
      _doneTasks.add(task);
    } else {
      _doneTasks.remove(task);
      _tasks.add(task);
    }
    await fetchDoneRates();
  }

  List<int> _doneRates = [0, 0];
  List<int> get doneRates => _doneRates;

  Future<void> fetchDoneRates() async {
    _doneRates = await  _db.getDoneRates();
    notifyListeners();
  }

  // Habits
  List<Habit> _habits = [];
  List<Habit> get habits => _habits;

  Future<void> fetchHabits() async {
    _habits = await _db.getHabits();
    notifyListeners();
  }

  Future<void> incrementHabitCounter(Habit habit, int increment) async {
    DateTime now = DateTime.now();
    habit.counter += increment;
    habit.lastDateTime = now;
    await _db.insertOrUpdateHabit(habit);
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

  Future<void> completeRoutine(Routine routine) async {
    routine.dueDateTime = Functions.getNextDate(routine.dueDateTime, routine.frequency, routine.period, routine.days);
    Future.delayed(const Duration(milliseconds: 500), () async {
      routine.isDone = false;
      await _db.insertOrUpdateRoutine(routine);
      notifyListeners();
    });
  }

  Future<void> endRoutine(Routine routine) async {
    routine.isDone = !routine.isDone;
    await _db.insertOrUpdateRoutine(routine);
    if (routine.isDone) {
      _routines.remove(routine);
      _doneRoutines.add(routine);
    } else {
      _doneRoutines.remove(routine);
      _routines.add(routine);
    }
    notifyListeners();
  }
}