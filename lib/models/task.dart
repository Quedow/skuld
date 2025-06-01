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
  bool isReclaimed = false;

  Task(this.title, this.description, this.dueDateTime, this.priority);

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'dueDateTime': dueDateTime.toIso8601String(),
    'priority': priority,
    'isDone': isDone,
    'isReclaimed': isReclaimed,
  };

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    json['title'] as String,
    json['description'] as String,
    DateTime.parse(json['dueDateTime'] as String),
    json['priority'] as int,
  )
  ..id = json['id'] as int
  ..isDone = json['isDone'] as bool
  ..isReclaimed = json['isReclaimed'] as bool;
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