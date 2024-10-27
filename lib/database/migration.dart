import 'package:isar/isar.dart';
import 'package:jiffy/jiffy.dart';
import 'package:skuld/models/routine.dart';
import 'package:skuld/models/task.dart';

Future<void> performMigrationIfNeeded(Isar isar) async {
  await clearOldQuests(isar);
}

Future<void> clearOldQuests(Isar isar) async {
  await isar.writeTxn(() async {
    DateTime deletionDate = Jiffy.now().subtract(months: 1).dateTime;
    await isar.tasks.filter().isDoneEqualTo(true).dueDateTimeLessThan(deletionDate).deleteAll();
    await isar.routines.filter().isDoneEqualTo(true).dueDateTimeLessThan(deletionDate).deleteAll();
  });
}