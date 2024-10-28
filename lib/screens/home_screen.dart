import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skuld/provider/quest_provider.dart';
import 'package:skuld/screens/habits_screen.dart';
import 'package:skuld/screens/routines_screen.dart';
import 'package:skuld/screens/settings_screen.dart';
import 'package:skuld/screens/tasks_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> _screens = const [
    TasksScreen(),
    HabitsScreen(),
    RoutinesScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<QuestProvider>(
          builder: (context, questProvider, _) => IndexedStack(
            index: questProvider.currentScreenIndex,
            children: _screens,
          ),
        ),
      ),
      bottomNavigationBar: Consumer<QuestProvider>(
        builder: (context, questProvider, _) => BottomNavigationBar(
          currentIndex: questProvider.currentScreenIndex,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 14,
          unselectedFontSize: 14,
          onTap: questProvider.updateScreenIndex,
          items:  const [
            BottomNavigationBarItem(label: 'Tasks', icon: Icon(Icons.checklist_rounded)),
            BottomNavigationBarItem(label: 'Habits', icon: Icon(Icons.psychology_rounded)),
            BottomNavigationBarItem(label: 'Routines', icon: Icon(Icons.loop_rounded)),
            BottomNavigationBarItem(label: 'Settings', icon: Icon(Icons.settings_rounded)),
          ],
        ),
      ),
    );
  }
}