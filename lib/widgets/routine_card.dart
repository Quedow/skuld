import 'package:flutter/material.dart';
import 'package:skuld/models/routine.dart';
import 'package:skuld/utils/functions.dart';
import 'package:skuld/utils/styles.dart';

class RoutineCard extends StatelessWidget {
  final Routine routine;
  final void Function()? onTap;
  final void Function(bool?)? onChanged;

  const RoutineCard({super.key, required this.routine, required this.onTap, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final bool dueDateExpired = routine.dueDateTime.isBefore(DateTime.now());
    final Color dateTimeColor = (dueDateExpired && !routine.isDone) ? Theme.of(context).colorScheme.error : Colors.black;

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
                color: Styles.greyColor,
              ),
            ),
            Checkbox(
              value: routine.isDone,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              onChanged: onChanged,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 5, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(routine.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodyLarge!.copyWith(decoration: routine.isDone ? TextDecoration.lineThrough : TextDecoration.none)),
                    ),
                    Wrap(
                      alignment: WrapAlignment.start,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 5,
                      children: [
                        Icon(Icons.access_time_rounded, size: 15, color: dateTimeColor),
                        Text(Functions.getTime(routine.dueDateTime), style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: dateTimeColor)),
                        Icon(Icons.calendar_today_rounded, size: 15, color: dateTimeColor),
                        Text(Functions.getDate(routine.dueDateTime), style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: dateTimeColor)),
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