import 'package:flutter/material.dart';
import 'package:skuld/utils/common_text.dart';

abstract class Alerts {
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