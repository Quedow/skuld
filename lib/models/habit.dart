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
  int counter = 0;

  Habit(this.title, this.description, this.isGood);
}

const Color isGoodColor = Styles.greenColor;
const Color isNotGoodColor = Styles.redColor;