import 'dart:convert';
import 'package:drift/drift.dart';

class IntListConverter extends TypeConverter<List<int>, String> {
  const IntListConverter();
  @override
  List<int> fromSql(String fromDb) {
    if (fromDb.isEmpty) return [];
    return List<int>.from(json.decode(fromDb));
  }

  @override
  String toSql(List<int> value) {
    return json.encode(value);
  }
}

@TableIndex(name: 'routine_dueDateTime', columns: {#dueDateTime})
class Routines extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  
  IntColumn get frequency => integer()();
  TextColumn get period => text()();
  TextColumn get days => text().map(const IntListConverter())();

  DateTimeColumn get dueDateTime => dateTime()();
  DateTimeColumn get lastDueDateTime => dateTime().nullable()();
  BoolColumn get isDone => boolean().withDefault(const Constant(false))();
}

const Map<String, String> periodToLabel = {
  'd': 'days',
  'w': 'weeks',
  'm': 'months',
  'y': 'years',
};

const Map<int, String> dayToLabel = {
  1: 'M',
  2: 'T',
  3: 'W',
  4: 'Th',
  5: 'F',
  6: 'Sa',
  7: 'S',
};
