import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skuld/provider/quest_provider.dart';
// import 'package:skuld/screens/game_screen.dart';
import 'package:skuld/screens/habits_screen.dart';
import 'package:skuld/screens/tasks_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> _screens = const [
    // GameScreen(),
    TasksScreen(),
    HabitsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<QuestProvider>(
          builder: (context, questProvider, child) {
            return IndexedStack(
              index: questProvider.currentScreenIndex,
              children: _screens,
            );
          },
        ),
      ),
      bottomNavigationBar: Consumer<QuestProvider>(
        builder: (context, questProvider, child) {
          return BottomNavigationBar(
            currentIndex: questProvider.currentScreenIndex,
            type: BottomNavigationBarType.fixed,
            selectedFontSize: 14,
            unselectedFontSize: 14,
            onTap: (index) => questProvider.updateScreenIndex(index),
            items: const [
              // BottomNavigationBarItem(label: 'Player', icon: Icon(Icons.gamepad_rounded)),
              BottomNavigationBarItem(label: 'Tasks', icon: Icon(Icons.checklist_rounded)),
              BottomNavigationBarItem(label: 'Habits', icon: Icon(Icons.psychology_rounded)),
            ],
          );
        },
      ),
    );
  }
}