import 'package:isar/isar.dart';

part 'routine.g.dart';

@collection
class Routine {
  Id id = Isar.autoIncrement;
  String title;
  String description;

  int frequency;
  String period;
  List<int> days;
  @Index()
  DateTime dueDateTime;
  DateTime? lastDueDateTime;
  bool isDone = false;

  Routine(this.title, this.description, this.frequency, this.period, this.days, this.dueDateTime);
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