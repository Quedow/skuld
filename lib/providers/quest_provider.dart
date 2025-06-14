import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:skuld/database/database_service.dart';
import 'package:skuld/models/quest.dart';
import 'package:skuld/utils/functions.dart';

class QuestProvider with ChangeNotifier {
  final DatabaseService _db = DatabaseService();

  int _currentScreenIndex = 1;
  int get currentScreenIndex => _currentScreenIndex;

  void updateScreenIndex(int index) {
    if (index != _currentScreenIndex) {
      _currentScreenIndex = index;
    }
    notifyListeners();
  }

  Future<void> refreshData(QuestType questType) async {
    switch (questType) {
      case QuestType.task:
        await fetchTasks();
        await fetchDoneRates();
        break;
      case QuestType.habit:
        await fetchHabits();
        break;
      case QuestType.routine:
        await fetchRoutines();
        break;
    }
    await fetchReport();
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
    task.isDone = state;
    task.isReclaimed = true;
    await _db.completeTask(task);
    if (state) {
      _tasks.remove(task);
      _doneTasks.add(task);
    } else {
      _doneTasks.remove(task);
      _tasks.add(task);
    }
    await fetchDoneRates();
    await fetchReport();
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
    if (habit.counter + increment >= 0 && increment != 0) {
      habit.counter += increment;
      habit.lastDateTime = DateTime.now();
      await _db.incrementHabitCounter(habit, increment > 0);
      notifyListeners();
    }
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
    await Future.delayed(const Duration(milliseconds: 500), () async {
      routine.isDone = false;
      await _db.completeRoutine(routine);
      notifyListeners();
    }).whenComplete(() => fetchReport());
  }

  Future<void> endRoutine(Routine routine) async {
    final bool isDone = !routine.isDone;
    routine.isDone = isDone;
    await _db.insertOrUpdateRoutine(routine.toCompanion(true).copyWith(isDone: Value(isDone)));
    if (routine.isDone) {
      _routines.remove(routine);
      _doneRoutines.add(routine);
    } else {
      _doneRoutines.remove(routine);
      _routines.add(routine);
    }
    notifyListeners();
  }

  // Report
  Report _report = Report(dailyQuests: [], isPenalty: false);
  Report get report => _report;

  Future<void> fetchReport() async {
    _report = await _db.getReport();
    notifyListeners();
  }
}