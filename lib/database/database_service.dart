import 'dart:io';

import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:skuld/models/habit.dart';
import 'package:skuld/models/routine.dart';
import 'package:skuld/models/task.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  late final Isar isar;

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  Future<Isar> init() async {
    final Directory dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [TaskSchema, HabitSchema, RoutineSchema],
      directory: dir.path,
      inspector: false, // set to false for build
    );
    return isar;
  }

  Future<Task?> getTask(int id) async {
    return await isar.tasks.get(id);
  }

  Future<Habit?> getHabit(int id) async {
    return await isar.habits.get(id);
  }

  Future<void> insertOrUpdateTask(Task task) async {
    await isar.writeTxn(() async {
      await isar.tasks.put(task);
    });
  }

  Future<void> insertOrUpdateHabit(Habit habit) async {
    await isar.writeTxn(() async {
      await isar.habits.put(habit);
    });
  }

  Future<void> insertOrUpdateRoutine(Routine routine) async {
    await isar.writeTxn(() async {
      await isar.routines.put(routine);
    });
  }

  Future<void> completeTask(int id, bool state) async {
    await isar.writeTxn(() async {
      final Task? taskToUpdate = await isar.tasks.filter().idEqualTo(id).findFirst();
      if (taskToUpdate != null) {
        taskToUpdate.isDone = state;
        await isar.tasks.put(taskToUpdate);
      }
    });
  }

  Future<List<Task>> getTasks(bool isDone) async {
    var query = isar.tasks.where().anyDueDateTime().filter().isDoneEqualTo(isDone);

    return !isDone
      ? await query.findAll()
      : await query.sortByDueDateTimeDesc().findAll();
  }

  Future<List<Habit>> getHabits() async {
    return await isar.habits.where().findAll();
  }

  Future<List<Routine>> getRoutines(bool isDone) async {
    var query = isar.routines.where().anyDueDateTime().filter().isDoneEqualTo(isDone);

    return !isDone
      ? await query.findAll()
      : await query.sortByDueDateTimeDesc().findAll();
  }

  Future<List<int>> getDoneRates() async {
    final DateTime now = DateTime.now();
    
    final DateTime startOfDay = DateTime(now.year, now.month, now.day);
    final DateTime endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    final DateTime startOfWeek = DateTime(now.year, now.month, now.day - (now.weekday - 1));
    final DateTime endOfWeek = DateTime(now.year, now.month, now.day + (7 - now.weekday), 23, 59, 59);

    final List<int> results = await Future.wait([
      isar.tasks.filter().dueDateTimeBetween(startOfDay, endOfDay).count(),
      isar.tasks.filter().dueDateTimeBetween(startOfDay, endOfDay).isDoneEqualTo(true).count(),
      isar.tasks.filter().dueDateTimeBetween(startOfWeek, endOfWeek).count(),
      isar.tasks.filter().dueDateTimeBetween(startOfWeek, endOfWeek).isDoneEqualTo(true).count(),
    ]);

    final int dayTotal = results[0];
    final int doneDayTotal = results[1];
    final int weekTotal = results[2];
    final int doneWeekTotal = results[3];

    final int dayRate = dayTotal > 0 ? (100 * doneDayTotal / dayTotal).round() : 100;
    final int weekRate = weekTotal > 0 ? (100 * doneWeekTotal / weekTotal).round() : 100;
    return [dayRate, weekRate];
  }

  Future<bool> clearTask(int id) async {
    late bool success;
    await isar.writeTxn(() async {
      success = await isar.tasks.delete(id);
    });
    return success;
  }

  Future<bool> clearHabit(int id) async {
    late bool success;
    await isar.writeTxn(() async {
      success = await isar.habits.delete(id);
    });
    return success;
  }

  Future<bool> clearRoutine(int id) async {
    late bool success;
    await isar.writeTxn(() async {
      success = await isar.routines.delete(id);
    });
    return success;
  }

  Future<void> clearDatabase() async {
    await isar.writeTxn(() async {
      await isar.clear();
    });
  }
}