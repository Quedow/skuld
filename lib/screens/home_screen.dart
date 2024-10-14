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
  late QuestProvider _questProvider;
  int currentScreenIndex = 0;

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
          const GameScreen(),
          const TasksScreen(),
          const FormScreen(),
          const HabitsScreen(),
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
          const BottomNavigationBarItem(label: 'Player', icon: Icon(Icons.gamepad_rounded)),
          const BottomNavigationBarItem(label: 'Tasks', icon: Icon(Icons.menu_rounded)),
          const BottomNavigationBarItem(label: 'Add', icon: Icon(Icons.add_rounded)),
          const BottomNavigationBarItem(label: 'Habits', icon: Icon(Icons.menu_rounded)),
        ],
      ),
    );
  }
}