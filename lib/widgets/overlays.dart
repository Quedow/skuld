import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:skuld/utils/common_text.dart';

abstract class Dialogs {
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