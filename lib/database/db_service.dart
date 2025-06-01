import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:skuld/models/db/habit.dart';
import 'package:skuld/models/db/player.dart';
import 'package:skuld/models/db/routine.dart';
import 'package:skuld/models/db/task.dart';
import 'package:skuld/models/quest.dart';
import 'package:skuld/models/reward.dart';
import 'package:skuld/utils/functions.dart';

part 'db_service.g.dart';

// LazyDatabase _openConnection() {
//   return LazyDatabase(() async {
//     final dir = await getApplicationDocumentsDirectory();
//     final file = File(p.join(dir.path, 'app_db.sqlite'));
//     return NativeDatabase(file);
//   });
// }

@DriftDatabase(tables: [Tasks, Habits, Routines, Players])
class DatabaseService extends _$DatabaseService {
  // Singleton boilerplate
  // static final DatabaseService _instance = DatabaseService._internal();
  // factory DatabaseService() => _instance;
  // DatabaseService._internal() : super(_openConnection());

  // int get schemaVersion => 1;

  DatabaseService([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  // ignore: override_on_non_overriding_member
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'skuld_db',
      native: const DriftNativeOptions(
        // By default, `driftDatabase` from `package:drift_flutter` stores the
        // database files in `getApplicationDocumentsDirectory()`.
        // databasePath: dir,

      ),
      // If you need web support, see https://drift.simonbinder.eu/platforms/web/
    );
  }


  Future<Task?> getTask(int id) {
    return managers.tasks.filter((t) => t.id.equals(id)).getSingleOrNull();
  }

  Future<List<Task>> getTasks(bool isDone) {
    final query = managers.tasks.filter((t) => t.isDone.equals(isDone));

    return !isDone
      ? query.get()
      : query.orderBy((t) => t.dueDateTime.desc()).get();
  }

  Future<void> insertOrUpdateTask(TasksCompanion task) async {
    final Task? taskToUpdate = await getTask(task.id.value);

    if (taskToUpdate != null) {
      await managers.tasks.filter((t) => t.id.equals(taskToUpdate.id)).update((t) => task);
    } else {
      await managers.tasks.create((t) => task);
    }
  }

  Future<void> completeTask(Task task) async {
    final Task? taskToUpdate = await getTask(task.id);

    if (taskToUpdate == null) return;

    if (!taskToUpdate.isDone && !taskToUpdate.isReclaimed) {
      if (DateTime.now().isBefore(taskToUpdate.dueDateTime)) {
        await updatePlayer(
          credits: rewards[RewardType.credits]?.onTimeTask(taskToUpdate.priority),
          xp: rewards[RewardType.xp]?.onTimeTask(taskToUpdate.priority),
        );
      } else {
        await updatePlayer(
          credits: rewards[RewardType.credits]?.lateTask(taskToUpdate.priority),
          hp: rewards[RewardType.hp]?.lateTask(taskToUpdate.priority),
        );
      }
    }

    await (update(tasks)..where((t) => t.id.equals(task.id))).write(
      TasksCompanion(
        isDone: Value(task.isDone),
        isReclaimed: Value(task.isReclaimed),
      ),
    );
  }

  Future<List<int>> getDoneRates() async {    
    final DateTime now = DateTime.now();
    
    final DateTime startOfDay = DateTime(now.year, now.month, now.day);
    final DateTime endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    final DateTime startOfWeek = DateTime(now.year, now.month, now.day - (now.weekday - 1));
    final DateTime endOfWeek = DateTime(now.year, now.month, now.day + (7 - now.weekday), 23, 59, 59);
    
    final List<int> results = await Future.wait([
      managers.tasks.filter((t) => t.dueDateTime.isBetween(startOfDay, endOfDay)).count(),
      managers.tasks.filter((t) => t.dueDateTime.isBetween(startOfDay, endOfDay) & t.isDone.equals(true)).count(),
      managers.tasks.filter((t) => t.dueDateTime.isBetween(startOfWeek, endOfWeek)).count(),
      managers.tasks.filter((t) => t.dueDateTime.isBetween(startOfWeek, endOfWeek) & t.isDone.equals(true)).count(),
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
    return await managers.tasks.filter((t) => t.id.equals(id)).delete() > 0;
  }

  Future<Habit?> getHabit(int id) {
    return managers.habits.filter((h) => h.id.equals(id)).getSingleOrNull();
  }

  Future<void> insertOrUpdateHabit(HabitsCompanion habit) async {
    final Task? habitToUpdate = await getTask(habit.id.value);

    if (habitToUpdate != null) {
      await managers.habits.filter((h) => h.id.equals(habitToUpdate.id)).update((h) => habit);
    } else {
      await managers.habits.create((h) => habit);
    }
  }

  Future<void> incrementHabitCounter(Habit habit, bool isIncrement) async {
    final Habit? habitToUpdate = await getHabit(habit.id);

    if (habitToUpdate == null) return;

    if (isIncrement) {
      if (habitToUpdate.isGood) {
        await updatePlayer(
          credits: rewards[RewardType.credits]?.goodHabit,
          xp: rewards[RewardType.xp]?.goodHabit,
        );
      } else {
        await updatePlayer(hp: rewards[RewardType.hp]?.badHabit);
      }
    }

    await (update(habits)..where((h) => h.id.equals(habit.id))).write(
      HabitsCompanion(
        counter: Value(habit.counter),
        lastDateTime: isIncrement ? Value(habit.lastDateTime) : const Value.absent(),
      ),
    );
  }

  Future<bool> clearHabit(int id) async {
    return await managers.habits.filter((h) => h.id.equals(id)).delete() > 0;
  }

  Future<List<Habit>> getHabits() {
    return managers.habits.orderBy((h) => h.isGood.desc()).get();
  }

  Future<List<Routine>> getRoutines(bool isDone) {
    final query = managers.routines.filter((r) => r.isDone.equals(isDone));
    
    return !isDone
      ? query.get()
      : query.orderBy((r) => r.dueDateTime.desc()).get();
  }

  Future<Routine?> getRoutine(int id) {
    return managers.routines.filter((t) => t.id.equals(id)).getSingleOrNull();
  }

  Future<void> insertOrUpdateRoutine(RoutinesCompanion routine) async {
    final Routine? routineToUpdate = await getRoutine(routine.id.value);

    final RoutinesCompanion routinesCompanion;
    if (routineToUpdate != null) {
      final DateTime? lastDueDateTime = routineToUpdate.lastDueDateTime;
      final bool razLastDueDateTime = lastDueDateTime != null && (lastDueDateTime.isAfter(routine.dueDateTime.value) || lastDueDateTime.isAtSameMomentAs(routine.dueDateTime.value));

      routinesCompanion = RoutinesCompanion(
        title: routine.title,
        description: routine.description,
        frequency: routine.frequency,
        period: routine.period,
        days: routine.days,
        dueDateTime: routine.dueDateTime,
        isDone: routine.isDone,
        lastDueDateTime: razLastDueDateTime ? const Value(null) : const Value.absent(),
      );

      await managers.routines
        .filter((r) => r.id.equals(routineToUpdate.id))
        .update((_) => routinesCompanion);
    } else {
      await managers.routines.create((r) => routine);
    }
  }

  Future<void> completeRoutine(Routine routine) async {
    final Routine? routineToUpdate = await getRoutine(routine.id);

    if (routineToUpdate == null) return;

    if (!routineToUpdate.isDone) {
      if (DateTime.now().isBefore(routineToUpdate.dueDateTime)) {
        await updatePlayer(
          credits: rewards[RewardType.credits]?.onTimeRoutine,
          xp: rewards[RewardType.xp]?.onTimeRoutine,
        );
      } else {
        await updatePlayer(hp: rewards[RewardType.hp]?.lateRoutine);
      }
    }

    await managers.routines.filter((r) => r.id.equals(routineToUpdate.id)).update((r) =>
      RoutinesCompanion(
        lastDueDateTime: Value(routineToUpdate.dueDateTime),
        dueDateTime: Value(routine.dueDateTime),
        isDone: const Value(true),
      ),
    );
  }

  Future<bool> clearRoutine(int id) async {
    return await managers.routines.filter((r) => r.id.equals(id)).delete() > 0;
  }

  Stream<Player> watchPlayer() {
    return select(players).watchSingleOrNull().map((player) {
      if (player == null) {
        throw Exception();
      }
      return player;
    });
  }

  Future<void> updatePlayer({int? hp, int? xp, int? credits}) async {
    final Player player = await managers.players.getSingleOrNull() ?? await managers.players.createReturning((p) => p());
    
    int playerHp = player.hp;
    int playerXp = player.xp;
    int playerCredits = player.credits;
    int playerLevel = player.level;
  
    if (hp != null) {
      playerHp += hp;

      if (playerHp <= 0) {
        playerHp = Functions.getMaxHp(playerLevel);
        playerCredits -= 30;
        playerXp = 0;
      }
    }

    if (xp != null) {
      playerXp += xp;

      final int targetXp = Functions.getTargetXp(playerLevel);
      if (playerXp >= targetXp) {
        playerHp = Functions.getMaxHp(playerLevel);
        playerCredits += 20;
        playerLevel++;
        playerXp = 0;
      }
    }

    if (credits != null) playerCredits += credits;

    await managers.players.filter((p) => p.id.equals(1)).update((p) => player.copyWith(
      hp: playerHp,
      xp: playerXp,
      credits: playerCredits,
      level: playerLevel,
    ));
  }

  // ----------------- REPORT ----------------- //

  Future<Report> getReport() async {
    final DateTime now = DateTime.now();
    final DateTime startOfDay = DateTime(now.year, now.month, now.day);
    final DateTime endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    final List<List<Object>> results = await Future.wait([
      managers.tasks.filter((t) => t.dueDateTime.isBetween(startOfDay, endOfDay)).get(),
      managers.routines.filter((r) => r.dueDateTime.isBetween(startOfDay, endOfDay)).get(),
      managers.routines.filter((r) => r.lastDueDateTime.not.isNull() & r.lastDueDateTime.isBetween(startOfDay, endOfDay)).get(),
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
      managers.tasks.filter((t) => t.isDone.equals(false) & t.dueDateTime.isBefore(startOfDay)).exists(),
      managers.routines.filter((r) => r.dueDateTime.isBefore(startOfDay)).exists(),
    ]);
    return results.any((element) => element);
  }

  Future<void> clearDatabase() async {
    await batch((b) {
      b.deleteAll(tasks);
      b.deleteAll(habits);
      b.deleteAll(routines);
      b.deleteAll(players);
    });
  }
}
