import 'package:isar/isar.dart';

part 'habit.g.dart';

@collection
class Habit {
  Id id = Isar.autoIncrement;
  String title;
  String description;
  bool isGood;
  String color;

  Habit(this.title, this.description, this.isGood, this.color);
}