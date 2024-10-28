import 'package:isar/isar.dart';
import 'package:jiffy/jiffy.dart';
import 'package:skuld/models/routine.dart';
import 'package:skuld/models/task.dart';
import 'package:skuld/provider/settings_service.dart';

Future<void> performMigrationIfNeeded(Isar isar) async {
  final SettingsService settings = SettingsService();
  await clearOldQuests(isar, settings.getDeletionFrequency());
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