import 'package:isar/isar.dart';

part 'task.g.dart';

@collection
class Task {
  Id id = Isar.autoIncrement;
  String title;
  String description;
  @Index()
  DateTime dueDateTime;
  String color;
  bool isDone = false;

  Task(this.title, this.description, this.dueDateTime, this.color);
}