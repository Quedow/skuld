import 'package:drift/drift.dart';
import 'package:jiffy/jiffy.dart';
import 'package:skuld/database/database_service.dart';
import 'package:skuld/providers/settings_service.dart';

Future<void> performMigrationIfNeeded(DatabaseService db) async {
  final SettingsService settings = SettingsService();
  await initPlayer(db);
  await clearOldQuests(db, settings.getDeletionFrequency());
}

Future<void> clearOldQuests(DatabaseService db, String deleteFrequency) async {
  final Map<String, Jiffy Function(Jiffy)> durations = {
    '1w': (Jiffy jiffy) => jiffy.subtract(weeks: 1),
    '2w': (Jiffy jiffy) => jiffy.subtract(weeks: 2),
    '1m': (Jiffy jiffy) => jiffy.subtract(months: 1),
    '1y': (Jiffy jiffy) => jiffy.subtract(years: 1),
  };

  final DateTime? deleteDate = durations[deleteFrequency]?.call(Jiffy.now()).dateTime;
  if (deleteDate == null) { return; }

  await Future.wait([
    db.managers.tasks.filter((t) => t.isDone.equals(true) & t.dueDateTime.isBefore(deleteDate)).delete(),
    db.managers.routines.filter((t) => t.isDone.equals(true) & t.dueDateTime.isBefore(deleteDate)).delete(),
  ]);
}

Future<void> initPlayer(DatabaseService db) async {
  if (!(await db.managers.players.filter((p) => p.id.equals(1)).exists())) {
    await db.managers.players.create((p) => p(id: const Value(1)));
  }
}