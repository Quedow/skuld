import 'dart:ui';

import 'package:skuld/utils/styles.dart';
import 'package:drift/drift.dart';

@TableIndex(name: 'task_dueDateTime', columns: {#dueDateTime})
class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get dueDateTime => dateTime()();
  IntColumn get priority => integer()();
  BoolColumn get isDone => boolean().withDefault(const Constant(false))();
  BoolColumn get isReclaimed => boolean().withDefault(const Constant(false))();
}

const Map<int, String> priorityToLabel = {
  1: 'Important and Urgent',
  2: 'Important and Not Urgent',
  3: 'Not Important and Urgent',
  4: 'Not Important and Not Urgent',
};

const Map<int, Color> priorityToColor = {
  1: Styles.orangeColor,
  2: Styles.purpleColor,
  3: Styles.blueColor,
  4: Styles.greenColor,
};