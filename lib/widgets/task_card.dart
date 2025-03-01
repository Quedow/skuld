import 'package:flutter/material.dart';
import 'package:skuld/models/task.dart';
import 'package:skuld/utils/functions.dart';
import 'package:skuld/utils/styles.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final void Function()? onTap;
  final void Function(bool?)? onCheck;
  final GlobalKey boxKey;

  const TaskCard({super.key, required this.task, required this.onTap, required this.onCheck, required this.boxKey});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final bool dueDateExpired = task.dueDateTime.isBefore(DateTime.now());
    final Color dateTimeColor = (dueDateExpired && !task.isDone) ? themeData.colorScheme.error : Colors.black;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Styles.borderRadius), side: const BorderSide(color: Styles.hintColor)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10, height: 64, // 64
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(Styles.borderRadius), bottomLeft: Radius.circular(Styles.borderRadius))),
                color: priorityToColor[task.priority],
              ),
            ),
            Checkbox(
              key: boxKey,
              value: task.isDone,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              onChanged: onCheck,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 5, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(task.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: themeData.textTheme.bodyLarge!.copyWith(decoration: task.isDone ? TextDecoration.lineThrough : TextDecoration.none)),
                    ),
                    Wrap(
                      alignment: WrapAlignment.start,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 5,
                      children: [
                        Icon(Icons.access_time_rounded, size: 15, color: dateTimeColor),
                        Text(Functions.getTime(task.dueDateTime), style: themeData.textTheme.bodyMedium!.copyWith(color: dateTimeColor)),
                        Icon(Icons.calendar_today_rounded, size: 15, color: dateTimeColor),
                        Text(Functions.getDate(task.dueDateTime), style: themeData.textTheme.bodyMedium!.copyWith(color: dateTimeColor)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}