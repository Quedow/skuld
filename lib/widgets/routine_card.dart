import 'package:extended_wrap/extended_wrap.dart';
import 'package:flutter/material.dart';
import 'package:skuld/models/routine.dart';
import 'package:skuld/utils/common_text.dart';
import 'package:skuld/utils/functions.dart';
import 'package:skuld/utils/styles.dart';

class RoutineCard extends StatelessWidget {
  final Routine routine;
  final void Function()? onTap;
  final void Function(bool?)? onCheck;
  final GlobalKey? animationOriginKey;

  const RoutineCard({super.key, required this.routine, required this.onTap, required this.onCheck, this.animationOriginKey});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final bool dueDateExpired = routine.dueDateTime.isBefore(DateTime.now());
    final Color dateTimeColor = (dueDateExpired && !routine.isDone) ? themeData.colorScheme.error : Colors.black;

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
                color: themeData.colorScheme.primary,
              ),
            ),
            Checkbox(
              key: animationOriginKey,
              value: routine.isDone,
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
                      child: Text(routine.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: themeData.textTheme.bodyLarge!.copyWith(decoration: routine.isDone ? TextDecoration.lineThrough : TextDecoration.none)),
                    ),
                    ExtendedWrap(
                      alignment: WrapAlignment.start,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 5,
                      maxLines: 1,
                      overflowWidget: const Text('...'),
                      children: [
                        Icon(Icons.access_time_rounded, size: 15, color: dateTimeColor),
                        Text(Functions.getTime(routine.dueDateTime), style: themeData.textTheme.bodyMedium!.copyWith(color: dateTimeColor)),
                        Icon(Icons.calendar_today_rounded, size: 15, color: dateTimeColor),
                        Text(Functions.getDate(routine.dueDateTime), style: themeData.textTheme.bodyMedium!.copyWith(color: dateTimeColor)),
                        const Icon(Icons.loop_rounded, size: 15),
                        Text(CText.textRoutineDetail(routine.frequency, routine.period), style: themeData.textTheme.bodyMedium),
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