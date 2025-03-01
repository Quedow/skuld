import 'dart:io';

import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:skuld/models/habit.dart';
import 'package:skuld/models/player.dart';
import 'package:skuld/models/quest.dart';
import 'package:skuld/models/reward.dart';
import 'package:skuld/models/routine.dart';
import 'package:skuld/models/task.dart';
import 'package:skuld/utils/functions.dart';

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
      [TaskSchema, HabitSchema, RoutineSchema, PlayerSchema],
      directory: dir.path,
      inspector: false, // set to false for build
    );
    return isar;
  }

  Future<Task?> getTask(int id) async {
    return await isar.tasks.get(id);
  }

  Future<List<Task>> getTasks(bool isDone) async {
    var query = isar.tasks.where().anyDueDateTime().filter().isDoneEqualTo(isDone);

    return !isDone
      ? await query.findAll()
      : await query.sortByDueDateTimeDesc().findAll();
  }

  Future<void> insertOrUpdateTask(Task task) async {
    final Task? taskToUpdate = await isar.tasks.filter().idEqualTo(task.id).findFirst();
    
    await isar.writeTxn(() async {
      if (taskToUpdate != null) {
        taskToUpdate.title = task.title;
        taskToUpdate.description = task.description;
        taskToUpdate.dueDateTime = task.dueDateTime;
        taskToUpdate.priority = task.priority;
        await isar.tasks.put(taskToUpdate);
      } else {
        await isar.tasks.put(task);
      }
    });
  }

  Future<void> completeTask(Task task) async {
    final Task? taskToUpdate = await isar.tasks.filter().idEqualTo(task.id).findFirst();

    if (taskToUpdate == null) return;

    if (!taskToUpdate.isDone && !taskToUpdate.isReclaimed) {
      if (DateTime.now().isBefore(taskToUpdate.dueDateTime)) {
        await updatePlayer(
          credits: rewards[RewardType.credits]!.onTimeTask(0),
          xp: rewards[RewardType.xp]!.onTimeTask(taskToUpdate.priority),
        );
      } else {
        await updatePlayer(hp: -5 * (5 - taskToUpdate.priority));
      }
    }

    await isar.writeTxn(() async {
      taskToUpdate.isDone = task.isDone;
      taskToUpdate.isReclaimed = true;
      await isar.tasks.put(taskToUpdate);
    });
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

  Future<Habit?> getHabit(int id) async {
    return await isar.habits.get(id);
  }

  Future<void> insertOrUpdateHabit(Habit habit) async {
    final Habit? habitToUpdate = await isar.habits.filter().idEqualTo(habit.id).findFirst();
    
    await isar.writeTxn(() async {
      if (habitToUpdate != null) {
        habitToUpdate.title = habit.title;
        habitToUpdate.description = habit.description;
        habitToUpdate.isGood = habit.isGood;
        await isar.habits.put(habitToUpdate);
      } else {
        await isar.habits.put(habit);
      }
    });
  }

  Future<void> incrementHabitCounter(Habit habit, bool isIncrement) async {
    final Habit? habitToUpdate = await isar.habits.filter().idEqualTo(habit.id).findFirst();

    if (habitToUpdate == null) return;

    if (isIncrement) {
      if (habitToUpdate.isGood) {
        await updatePlayer(credits: 1, xp: 5);
      } else {
        await updatePlayer(hp: -5);
      }
    }

    await isar.writeTxn(() async {
      habitToUpdate.counter = habit.counter;
      if (isIncrement) {
        habitToUpdate.lastDateTime = habit.lastDateTime;
      }
      await isar.habits.put(habitToUpdate);
    });
  }

  Future<bool> clearHabit(int id) async {
    late bool success;
    await isar.writeTxn(() async {
      success = await isar.habits.delete(id);
    });
    return success;
  }

  Future<List<Habit>> getHabits() async {
    return await isar.habits.where().sortByIsGoodDesc().findAll();
  }

  Future<List<Routine>> getRoutines(bool isDone) async {
    var query = isar.routines.where().anyDueDateTime().filter().isDoneEqualTo(isDone);

    return !isDone
      ? await query.findAll()
      : await query.sortByDueDateTimeDesc().findAll();
  }

  Future<void> insertOrUpdateRoutine(Routine routine) async {
    final Routine? routineToUpdate = await isar.routines.filter().idEqualTo(routine.id).findFirst();
    
    await isar.writeTxn(() async {
      if (routineToUpdate != null) {
        routineToUpdate.title = routine.title;
        routineToUpdate.description = routine.description;
        routineToUpdate.frequency = routine.frequency;
        routineToUpdate.period = routine.period;
        routineToUpdate.days = routine.days;
        routineToUpdate.dueDateTime = routine.dueDateTime;
        routineToUpdate.isDone = routine.isDone;

      final DateTime? lastDueDateTime = routineToUpdate.lastDueDateTime;
      if (lastDueDateTime != null && (lastDueDateTime.isAfter(routine.dueDateTime) || lastDueDateTime.isAtSameMomentAs(routine.dueDateTime))) {
        routineToUpdate.lastDueDateTime = null;
      }

        await isar.routines.put(routineToUpdate);
      } else {
        await isar.routines.put(routine);
      }
    });
  }

  Future<void> completeRoutine(Routine routine) async {
    final Routine? routineToUpdate = await isar.routines.filter().idEqualTo(routine.id).findFirst();

    if (routineToUpdate == null) return;

    if (!routineToUpdate.isDone) {
      if (DateTime.now().isBefore(routineToUpdate.dueDateTime)) {
        await updatePlayer(credits: 5, xp: 5);
      } else {
        await updatePlayer(hp: -5);
      }
    }

    await isar.writeTxn(() async {
      routineToUpdate.lastDueDateTime = routineToUpdate.dueDateTime;
      routineToUpdate.dueDateTime = routine.dueDateTime;
      await isar.routines.put(routineToUpdate);
    });
  }

  Future<bool> clearRoutine(int id) async {
    late bool success;
    await isar.writeTxn(() async {
      success = await isar.routines.delete(id);
    });
    return success;
  }

  Stream<Player> watchPlayer() {
    return isar.players.watchObject(1, fireImmediately: true).map((player) {
      if (player == null) {
        throw Exception();
      }
      return player;
    });
  }

  Future<void> updatePlayer({int? hp, int? xp, int? credits, int? itemID}) async {
    final Player player = await isar.players.get(1) ?? Player();

    await isar.writeTxn(() async {
      if (hp != null) {
        player.hp += hp;

        if (player.hp <= 0) {
          player.hp = Functions.getMaxHp(player.level);
          player.credits -= 30;
          player.xp = 0;
        }
      }

      if (xp != null) {
        player.xp += xp;

        final int targetXp = Functions.getTargetXp(player.level);
        if (player.xp >= targetXp) {
          player.hp = Functions.getMaxHp(player.level);
          player.credits += 20;
          player.level++;
          player.xp = 0;
        }
      }

      if (credits != null) player.credits += credits;

      if (itemID != null) player.itemIDs.add(itemID);

      await isar.players.put(player);
    });
  }

  Future<Report> getReport() async {
    final DateTime now = DateTime.now();
    final DateTime startOfDay = DateTime(now.year, now.month, now.day);
    final DateTime endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    final List<List<Object>> results = await Future.wait([
      isar.tasks.filter().dueDateTimeBetween(startOfDay, endOfDay).findAll(),
      isar.routines.filter().dueDateTimeBetween(startOfDay, endOfDay).findAll(),
      isar.routines.filter().lastDueDateTimeIsNotNull().and().lastDueDateTimeBetween(startOfDay, endOfDay).findAll(),
    ]);

    final List<Task> tasks = results[0] as List<Task>;
    final List<Routine> undoneRoutines = results[1] as List<Routine>;
    final List<Routine> doneRoutines = results[2] as List<Routine>;

    final List<Quest> dailyQuests = [
      ...tasks.map((task) => Quest(task.title, task.isDone)),
      ...undoneRoutines.map((routine) => Quest(routine.title, false)),
      ...doneRoutines.map((routine) => Quest(routine.title, true)),
    ];
    return Report(
      dailyQuests: dailyQuests,
      isPenalty: await getIsPenalty(startOfDay),
    );
  }

  Future<bool> getIsPenalty(DateTime startOfDay) async {
    final List<bool> results = await Future.wait([
      isar.tasks.filter().isDoneEqualTo(false).dueDateTimeLessThan(startOfDay).isNotEmpty(),
      isar.routines.filter().dueDateTimeLessThan(startOfDay).isNotEmpty(),
    ]);
    return results.any((element) => element);
  }

  Future<void> clearDatabase() async {
    await isar.writeTxn(() async {
      await isar.clear();
    });
  }
}