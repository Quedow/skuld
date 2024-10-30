import 'package:flutter/material.dart';
import 'package:skuld/database/database_service.dart';
import 'package:skuld/models/habit.dart';
import 'package:skuld/models/quest.dart';
import 'package:skuld/models/routine.dart';
import 'package:skuld/models/task.dart';
import 'package:skuld/screens/form_screen.dart';

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

  Future<void> createOrUpdateTask(BuildContext context, [Map<QuestType, Task>? typeAndQuest]) async {
    bool result = await _navigateToFormScreen(context, typeAndQuest);

    if (result) {
      await fetchTasks();
    }
  }

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

  // Habits
  List<Habit> _habits = [];
  List<Habit> get habits => _habits;

  Future<void> createOrUpdateHabit(BuildContext context, [Map<QuestType, Habit>? typeAndQuest]) async {
    bool result = await _navigateToFormScreen(context, typeAndQuest);

    if (result) {
      await fetchHabits();
    }
  }

  Future<void> fetchHabits() async {
    _habits = await _db.getHabits();
    notifyListeners();
  }

  Future<void> incrementHabitCounter(int index, int habitId) async {
    await _db.incrementHabitCounter(habitId);
    _habits[index].counter++;
    notifyListeners();
  }

  // Routines
  List<Routine> _routines = [];
  List<Routine> get routines => _routines;

  List<Routine> _doneRoutines = [];
  List<Routine> get doneRoutines => _doneRoutines;

  Future<void> createOrUpdateRoutine(BuildContext context, [Map<QuestType, Routine>? typeAndQuest]) async {
    bool result = await _navigateToFormScreen(context, typeAndQuest);

    if (result) {
      await fetchRoutines();
    }
  }

  Future<void> fetchRoutines() async {
    _routines = await _db.getRoutines(false);
    _doneRoutines = await _db.getRoutines(true);
    notifyListeners();
  }

  Future<bool> _navigateToFormScreen(BuildContext context, [Map<QuestType, dynamic>? typeAndQuest]) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FormScreen(typeAndQuest: typeAndQuest)),
    ) ?? false;
  }

  List<int> _doneRates = [0, 0];
  List<int> get doneRates => _doneRates;

  Future<void> fetchDoneRates() async {
    _doneRates = await  _db.getDoneRates();
  }
}