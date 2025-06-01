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

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'frequency': frequency,
    'period': period,
    'days': days,
    'dueDateTime': dueDateTime.toIso8601String(),
    'lastDueDateTime': lastDueDateTime?.toIso8601String(),
    'isDone': isDone,
  };

  factory Routine.fromJson(Map<String, dynamic> json) => Routine(
    json['title'] as String,
    json['description'] as String,
    json['frequency'] as int,
    json['period'] as String,
    List<int>.from(json['days'] as List),
    DateTime.parse(json['dueDateTime'] as String),
  )
  ..id = json['id'] as int
  ..lastDueDateTime = json['lastDueDateTime'] != null
    ? DateTime.parse(json['lastDueDateTime'] as String)
    : null
  ..isDone = json['isDone'] as bool;
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