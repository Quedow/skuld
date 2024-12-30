import 'package:isar/isar.dart';
import 'package:jiffy/jiffy.dart';
import 'package:skuld/models/player.dart';
import 'package:skuld/models/routine.dart';
import 'package:skuld/models/task.dart';
import 'package:skuld/provider/settings_service.dart';

Future<void> performMigrationIfNeeded(Isar isar) async {
  final SettingsService settings = SettingsService();
  await clearOldQuests(isar, settings.getDeletionFrequency());
  final int currentVersion = settings.getVersion();
  switch(currentVersion) {
    case 1:
      await migrateV1ToV2(isar);
      break;
    case 2:
      // Si la version n'est pas définie (nouvelle installation) ou si elle est déjà à 2, il n'est pas nécessaire de migrer.
      return;
    default:
      throw Exception('Unknown version: $currentVersion');
  }

  // Mise à jour de la version
  await settings.setVersion(2);
}

Future<void> clearOldQuests(Isar isar, String deleteFrequency) async {
  final Map<String, Jiffy Function(Jiffy)> durations = {
    '1w': (Jiffy jiffy) => jiffy.subtract(weeks: 1),
    '2w': (Jiffy jiffy) => jiffy.subtract(weeks: 2),
    '1m': (Jiffy jiffy) => jiffy.subtract(months: 1),
    '1y': (Jiffy jiffy) => jiffy.subtract(years: 1),
  };

  final DateTime? deleteDate = durations[deleteFrequency]?.call(Jiffy.now()).dateTime;
  if (deleteDate == null) { return; }

  await isar.writeTxn(() async {
    await isar.tasks.filter().isDoneEqualTo(true).dueDateTimeLessThan(deleteDate).deleteAll();
    await isar.routines.filter().isDoneEqualTo(true).dueDateTimeLessThan(deleteDate).deleteAll();
  });
}

Future<void> migrateV1ToV2(Isar isar) async {
  final int taskCount = await isar.tasks.count();

  for (int i = 0; i < taskCount; i += 50) {
    final List<Task> tasks = await isar.tasks.where().offset(i).limit(50).findAll();
    await isar.writeTxn(() async {
      for (final Task task in tasks) {
        task.isReclaimed = task.isDone;
      }
      await isar.tasks.putAll(tasks);
    });
  }

  if ((await isar.players.count()) == 0) {
    await isar.writeTxn(() async {
      await isar.players.put(Player());
    });
  }
}