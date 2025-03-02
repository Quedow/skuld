import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:skuld/models/habit.dart';
import 'package:skuld/models/reward.dart';
import 'package:skuld/models/routine.dart';
import 'package:skuld/models/task.dart';
import 'package:skuld/utils/common_text.dart';
import 'package:skuld/utils/functions.dart';

abstract class Overlays {
  static const List<Offset> offsets = [Offset(0, 0), Offset(20, -20), Offset(-10, -35)];

  static Future<void> deletionDialog(BuildContext context, void Function() onConfirmation) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        final ThemeData themeData = Theme.of(context);
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.spaceAround,
          title: Text(CText.textDeletionDialog, style: themeData.textTheme.titleLarge),
          actions: [
            IconButton(icon: Icon(Icons.cancel_rounded, color: themeData.colorScheme.error),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
            IconButton(icon: Icon(Icons.check_circle_rounded, color: themeData.colorScheme.primary),
              onPressed: () async {
                onConfirmation();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static void playRewardAnimation(BuildContext context, GlobalKey animationOriginKey, Object quest) {
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
      Overlays._showAnimation(context, animationOriginKey, label, rewardData.color, index);
      index++;
    }
  }

  static void _showAnimation(BuildContext context, GlobalKey key, String label, Color labelColor, int index) {
    final RenderBox? box = key.currentContext?.findRenderObject() as RenderBox?;

    if (box == null) return;

    final int duration = (Functions.getRandomDouble(1, 2) * 1000).toInt();
    final Offset position = box.localToGlobal(Offset.zero);
    final Offset offset = offsets[index % offsets.length];
    
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


class RewardAnimation extends StatelessWidget {
  final String label;
  final Color labelColor;
  final int duration;

  const RewardAnimation({super.key, required this.label, required this.labelColor, required this.duration});

  @override
  Widget build(BuildContext context) {
    return SlideInUp(
      curve: Curves.easeOutExpo,
      duration: Duration(milliseconds: 10 * duration),
      child: FadeOut(
        duration: Duration(milliseconds: duration),
        delay: const Duration(milliseconds: 250),
        child: ZoomIn(
          duration: const Duration(milliseconds: 100),
          child: Text(label, style: Theme.of(context).textTheme.labelMedium!.copyWith(color: labelColor)),
        ),
      ),
    );
  }
}