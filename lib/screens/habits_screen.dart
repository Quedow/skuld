import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skuld/models/habit.dart';
import 'package:skuld/models/quest.dart';
import 'package:skuld/provider/quest_provider.dart';
import 'package:skuld/utils/common_text.dart';
import 'package:skuld/utils/functions.dart';
import 'package:skuld/widgets/habit_card.dart';

class HabitsScreen extends StatefulWidget {
  final QuestProvider questProvider;

  const HabitsScreen({super.key, required this.questProvider});

  @override
  State<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  late final QuestProvider _questProvider;
  
  @override
  void initState() {
    super.initState();
    _questProvider = widget.questProvider;
    _questProvider.fetchHabits();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Consumer<QuestProvider>(
        builder: (context, questProvider, _) => _habitList(questProvider.habits),
      ),
    );
  }

  Widget _habitList(List<Habit> habits) {
    if (habits.isEmpty) {
      return Center(child: Text(Texts.textNoHabit, style: Theme.of(context).textTheme.bodyLarge));
    }
    return ListView.builder(
      itemCount: habits.length,
      itemBuilder: (context, index) {
        Habit habit = habits[index];
        return HabitCard(
          habit: habit,
          onTap: () => Functions.navigateToFormScreen(context, {QuestType.habit: habit}),
          onIncrement: () => _questProvider.incrementHabitCounter(index, habit.id),
        );
      },
    );
  }
}