import 'package:flutter/material.dart';
import 'package:skuld/models/habit.dart';
import 'package:skuld/models/quest.dart';
import 'package:skuld/database/database_service.dart';
import 'package:skuld/screens/form_screen.dart';
import 'package:skuld/utils/common_text.dart';
import 'package:skuld/widgets/habit_card.dart';

class HabitsScreen extends StatefulWidget {
  const HabitsScreen({super.key});

  @override
  State<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  final DatabaseService _db = DatabaseService();
  
  late ValueNotifier<List<Habit>> _habitsNotifier;

  @override
  void initState() {
    super.initState();
    _habitsNotifier = ValueNotifier<List<Habit>>([]);
    _fetchHabits();
  }

  @override
  void dispose() {
    _habitsNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  Texts.textHabitTitle,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              Expanded(
                // Use ValueListenableBuilder for efficient state updates.
                child: ValueListenableBuilder<List<Habit>>(
                  valueListenable: _habitsNotifier,
                  builder: (BuildContext context, List<Habit> habits, _) {
                    if (habits.isEmpty) {
                      return Center(child: Text(Texts.textNoHabit, style: Theme.of(context).textTheme.bodyLarge));
                    }

                    return ListView.builder(
                      itemCount: habits.length,
                      itemBuilder: (context, index) {
                        Habit habit = habits[index];
                        return HabitCard(
                          habit: habit,
                          onTap: () => _createOrUpdateHabit({QuestType.habit: habit}),
                          onIncrement: () => _incrementHabitCounter(habit),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          FloatingActionButton(
            heroTag: UniqueKey(),
            elevation: 2,
            shape: const CircleBorder(),
            onPressed: _createOrUpdateHabit,
            child: const Icon(Icons.add_rounded),
          ),
        ],
      ),
    );
  }

  Future<void> _createOrUpdateHabit([Map<QuestType, dynamic>? typeAndQuest]) async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FormScreen(typeAndQuest: typeAndQuest)),
    ) ?? false;

    if (result) {
      await _fetchHabits();
    }
  }

  Future<void> _incrementHabitCounter(Habit habit) async {
    await _db.incrementHabitCounter(habit.id);
    habit.counter++;
    _habitsNotifier.value = List.from(_habitsNotifier.value);
  }

  Future<void> _fetchHabits() async {
    _habitsNotifier.value = await _db.getHabits();
  }
}