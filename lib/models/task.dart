import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:skuld/utils/styles.dart';

part 'task.g.dart';

@collection
class Task {
  Id id = Isar.autoIncrement;
  String title;
  String description;
  @Index()
  DateTime dueDateTime;
  int priority;
  bool isDone = false;

  Task(this.title, this.description, this.dueDateTime, this.priority);
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