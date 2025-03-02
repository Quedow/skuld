import 'dart:ui';

import 'package:skuld/utils/styles.dart';

enum RewardType { hp, xp, credits }

class RewardData {
  final Color color;
  final String label;
  final int Function(int priority) onTimeTask;
  final int Function(int priority) lateTask;
  final int goodHabit;
  final int badHabit;
  final int onTimeRoutine;
  final int lateRoutine;

  const RewardData({required this.color, required this.label, required this.onTimeTask, required this.lateTask, required this.goodHabit, required this.badHabit, required this.onTimeRoutine, required this.lateRoutine});
}

final Map<RewardType, RewardData> rewards = {
  RewardType.credits: RewardData(
    color: Styles.orangeColor,
    label: 'CR',
    onTimeTask: (_) => 5,
    lateTask: (_) => 1,
    goodHabit: 2,
    badHabit: 0,
    onTimeRoutine: 5,
    lateRoutine: 0,
  ),
  RewardType.xp: RewardData(
    color: Styles.greenColor,
    label: 'XP',
    onTimeTask: (priority) => 5 * (5 - priority),
    lateTask: (_) => 0,
    goodHabit: 2,
    badHabit: 0,
    onTimeRoutine: 5,
    lateRoutine: 0,
  ),
  RewardType.hp: RewardData(
    color: Styles.redColor,
    label: 'HP',
    onTimeTask: (_) => 0,
    lateTask: (priority) => -5 * (5 - priority),
    goodHabit: 0,
    badHabit: -5,
    onTimeRoutine: 0,
    lateRoutine: -5,
  ),
};
