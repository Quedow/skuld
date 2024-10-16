import 'dart:io';

import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:skuld/models/habit.dart';
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
      [TaskSchema, HabitSchema],
      directory: dir.path,
      inspector: true, // set to false for build
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
      final Habit? habitToUpdate = await isar.habits.filter().idEqualTo(habit.id).findFirst();
      if (habitToUpdate != null) {
        habitToUpdate.title = habit.title;
        habitToUpdate.description = habit.description;
        habitToUpdate.isGood = habit.isGood;
        habitToUpdate.color = habit.color;
        await isar.habits.put(habitToUpdate);
      } else {
        await isar.habits.put(habit);
      }
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

  Future<List<Task>> getTasks() async {
    return await isar.tasks.where(sort: Sort.asc).anyDueDateTime().findAll();
  }

  Future<List<Habit>> getHabits() async {
    return await isar.habits.where().findAll();
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
      success = await isar.tasks.delete(id);
    });
    return success;
  }

  Future<void> clearDatabase() async {
    await isar.writeTxn(() async {
      await isar.clear();
    });
  }
}
