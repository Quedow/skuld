import 'package:flutter/material.dart';
import 'package:skuld/models/habit.dart';
import 'package:skuld/provider/quest_provider.dart';
import 'package:skuld/utils/functions.dart';

class HabitsScreen extends StatefulWidget {
  final QuestProvider questProvider;

  const HabitsScreen({super.key, required this.questProvider});

  @override
  State<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  @override
  Widget build(BuildContext context) {
    final QuestProvider questProvider = widget.questProvider;
    final List<Habit> habits = questProvider.habits;

    return ListView.builder(
      shrinkWrap: true,
      itemCount: habits.length,
      itemBuilder: (context, index) {
        final Habit habit = habits[index];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ListTile(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            tileColor: const Color(0xFFE1E1E1),
            title: Text(habit.title, style: TextStyle(color: Functions.getColor(habit.color))),
          ),
        );
      },
    );
  }
}