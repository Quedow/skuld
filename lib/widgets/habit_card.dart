import 'package:flutter/material.dart';
import 'package:skuld/models/habit.dart';
import 'package:skuld/utils/common_text.dart';
import 'package:skuld/utils/styles.dart';

class HabitCard extends StatelessWidget {
  final Habit habit;
  final void Function()? onTap;
  final void Function()? onIncrement;
  final GlobalKey? animationOriginKey;
  
  const HabitCard({super.key, required this.habit, required this.onTap, required this.onIncrement, required this.animationOriginKey});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final Color counterColor = !habit.isGood && habit.counter > 0 ? themeData.colorScheme.error : Colors.black;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Styles.borderRadius), side: const BorderSide(color: Styles.hintColor)),
        child: Padding(
          padding: const EdgeInsets.only(right: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 10,
                height: 64,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(Styles.borderRadius), bottomLeft: Radius.circular(Styles.borderRadius))),
                  color: habit.isGood ? isGoodColor : isNotGoodColor,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Text(habit.title, overflow: TextOverflow.ellipsis, style: themeData.textTheme.bodyLarge),
                      ),
                      Text(CText.textLastTime(habit.lastDateTime), style: themeData.textTheme.bodyMedium),
                    ],
                  ),
                ),
              ),
              Text(habit.counter.toString(), style: themeData.textTheme.bodyLarge!.copyWith(color: counterColor)),
              IconButton(
                key: animationOriginKey,
                onPressed: onIncrement,
                icon: const Icon(Icons.add_rounded),
              ),
            ],
          ),
        ),
      ),
    );
  }
}