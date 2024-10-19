import 'package:flutter/material.dart';
import 'package:skuld/models/task.dart';
import 'package:skuld/utils/functions.dart';
import 'package:skuld/utils/styles.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final void Function()? onTap;
  final void Function(bool?)? onChanged;

  const TaskCard({super.key, required this.task, required this.onTap, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    bool dueDateExpired = task.dueDateTime.isBefore(DateTime.now());

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Styles.borderRadius), side: const BorderSide(color: Styles.hintColor)),
        child: Row(
          children: [
            Container(
              width: 10,
              height: 64, // 64
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(Styles.borderRadius), bottomLeft: Radius.circular(Styles.borderRadius))),
                color: priorityToColor[task.priority],
              ),
            ),
            Checkbox(
              value: task.isDone,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              onChanged: onChanged,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Wrap(
                direction: Axis.vertical,
                spacing: 2,
                children: [
                  Text(task.title, style: Theme.of(context).textTheme.bodyLarge!.copyWith(decoration: task.isDone ? TextDecoration.lineThrough : TextDecoration.none)),
                  Wrap(
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 5,
                    children: [
                      const Icon(Icons.access_time_rounded, size: 15),
                      Text(Functions.getTime(task.dueDateTime), style: Theme.of(context).textTheme.bodyMedium),
                      Icon(Icons.calendar_today_rounded, size: 15, color: !dueDateExpired ? Colors.black : Theme.of(context).colorScheme.error),
                      Text(Functions.getDate(task.dueDateTime), style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: !dueDateExpired ? Colors.black : Theme.of(context).colorScheme.error)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}