import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skuld/provider/quest_provider.dart';
import 'package:skuld/screens/form_screen.dart';
import 'package:skuld/screens/game_screen.dart';
import 'package:skuld/screens/habits_screen.dart';
import 'package:skuld/screens/tasks_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentScreenIndex = 0;
  late QuestProvider _questProvider;

  @override
  void initState() {
    super.initState();
    _questProvider = Provider.of<QuestProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: [
          GameScreen(),
          TasksScreen(questProvider: _questProvider),
          FormScreen(questProvider: _questProvider),
          HabitsScreen(questProvider: _questProvider),
        ].elementAt(currentScreenIndex)
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentScreenIndex,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 14,
        unselectedFontSize: 14,
        onTap: (index) {
          if (currentScreenIndex == index) { return; }
          setState(() {
            currentScreenIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(label: 'Player', icon: const Icon(Icons.gamepad_rounded)),
          BottomNavigationBarItem(label: 'Tasks', icon: const Icon(Icons.menu_rounded)),
          BottomNavigationBarItem(label: 'Add', icon: const Icon(Icons.add_rounded)),
          BottomNavigationBarItem(label: 'Habits', icon: const Icon(Icons.menu_rounded)),
        ],
      ),
    );
  }
}