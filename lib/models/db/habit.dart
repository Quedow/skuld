import 'dart:ui';

import 'package:drift/drift.dart';
import 'package:skuld/utils/styles.dart';

class Habits extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  BoolColumn get isGood => boolean()();
  DateTimeColumn get lastDateTime => dateTime().nullable()();
  IntColumn get counter => integer().withDefault(const Constant(0))();
}


const Map<bool, String> isGoodToLabel = {
  true: 'Good Habit',
  false: 'Bad Habit',
};

const Color isGoodColor = Styles.greenColor;
const Color isNotGoodColor = Styles.redColor;