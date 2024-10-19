import 'package:flutter/material.dart';
import 'package:skuld/models/habit.dart';
import 'package:skuld/utils/styles.dart';

class HabitCard extends StatelessWidget {
  final Habit habit;
  final void Function()? onTap;
  final void Function()? onPressed;
  
  const HabitCard({super.key, required this.habit, required this.onTap, required this.onPressed});

  @override
  Widget build(BuildContext context) {
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
                height: 52,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(Styles.borderRadius), bottomLeft: Radius.circular(Styles.borderRadius))),
                  color: habit.isGood ? isGoodColor : isNotGoodColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(habit.title, style: Theme.of(context).textTheme.bodyLarge),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(habit.counter.toString(), style: Theme.of(context).textTheme.bodyLarge),
              ),
              IconButton(
                onPressed: onPressed,
                icon: const Icon(Icons.add_rounded),
              ),
            ],
          ),
        ),
      ),
    );
  }
}