import 'package:flutter/material.dart';
import 'package:skuld/models/habit.dart';
import 'package:skuld/models/reward.dart';
import 'package:skuld/models/routine.dart';
import 'package:skuld/models/task.dart';
import 'package:skuld/providers/settings_service.dart';
import 'package:skuld/utils/functions.dart';
import 'package:skuld/widgets/overlays.dart';

abstract class AnimController {
  static final bool _gameMode = SettingsService().getGameMode();
  static const List<Offset> _offsets = [Offset(0, 0), Offset(20, -20), Offset(-10, -35)];

  static void playReward(BuildContext context, GlobalKey animationOriginKey, Object quest) {
    if (!_gameMode) return; 
    
    if (quest is! Task && quest is! Routine && quest is! Habit) return;

    final int Function(RewardData) getRewardValue;

    if (quest is Task) {
      if (quest.isDone || quest.isReclaimed) return;
      final bool isOnTime = DateTime.now().isBefore(quest.dueDateTime);
      getRewardValue = (rewardData) => isOnTime
        ? rewardData.onTimeTask(quest.priority)
        : rewardData.lateTask(quest.priority);
    } else if (quest is Habit) {
      getRewardValue = (rewardData) =>
        quest.isGood ? rewardData.goodHabit : rewardData.badHabit;
    } else if (quest is Routine) {
      if (quest.isDone) return;
      final bool isOnTime = DateTime.now().isBefore(quest.dueDateTime);
      getRewardValue = (rewardData) => isOnTime
        ? rewardData.onTimeRoutine
        : rewardData.lateRoutine;
    } else {
      return;
    }

    int index = 0;
    for (final RewardData rewardData in rewards.values) {
      final int value = getRewardValue(rewardData);
      
      if (value == 0) continue;

      final String label = '${value >= 0 ? '+' : '-'}${value.abs()}${rewardData.label}';
      _showAnimation(context, animationOriginKey, label, rewardData.color, index);
      index++;
    }
  }

  static void _showAnimation(BuildContext context, GlobalKey key, String label, Color labelColor, int index) {
    final RenderBox? box = key.currentContext?.findRenderObject() as RenderBox?;

    if (box == null) return;

    final int duration = (Functions.getRandomDouble(1, 2) * 1000).toInt();
    final Offset position = box.localToGlobal(Offset.zero);
    final Offset offset = _offsets[index % _offsets.length];
    
    final OverlayState overlay = Overlay.of(context);
    final OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: position.dx + offset.dx,
        top: position.dy - 100 + offset.dy,
        child: RewardAnimation(label: label, labelColor: labelColor, duration: duration),
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(Duration(milliseconds: duration), () {
      overlayEntry.remove();
    });
  }
}