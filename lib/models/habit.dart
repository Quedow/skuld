import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:skuld/utils/styles.dart';

part 'habit.g.dart';

@collection
class Habit {
  Id id = Isar.autoIncrement;
  String title;
  String description;
  bool isGood;
  DateTime? lastDateTime;
  int counter = 0;

  Habit(this.title, this.description, this.isGood);

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'isGood': isGood,
    'lastDateTime': lastDateTime?.toIso8601String(),
    'counter': counter,
  };

  factory Habit.fromJson(Map<String, dynamic> json) => Habit(
      json['title'] as String,
      json['description'] as String,
      json['isGood'] as bool,
    )
    ..id = json['id'] as int
    ..lastDateTime = json['lastDateTime'] != null
      ? DateTime.parse(json['lastDateTime'] as String)
      : null
    ..counter = json['counter'] as int;
}

const Map<bool, String> isGoodToLabel = {
  true: 'Good Habit',
  false: 'Bad Habit',
};

const Color isGoodColor = Styles.greenColor;
const Color isNotGoodColor = Styles.redColor;