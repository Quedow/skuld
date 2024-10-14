import 'package:flutter/material.dart';
import 'package:skuld/models/habit.dart';
import 'package:skuld/provider/database_service.dart';
import 'package:skuld/utils/functions.dart';

class HabitsScreen extends StatefulWidget {

  const HabitsScreen({super.key});

  @override
  State<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  final DatabaseService _db = DatabaseService();
  late Future<List<Habit>> _habits;
  
  @override
  void initState() {
    super.initState();
    _habits = _db.getHabits();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Habit>>(
      future: _habits,
      builder: (BuildContext context, AsyncSnapshot<List<Habit>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error when loading habits'));
        }

        final List<Habit> habits = snapshot.data ?? [];

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
    );
  }
}