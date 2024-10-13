import 'package:flutter/material.dart';
import 'package:skuld/screens/form_screen.dart';
import 'package:skuld/screens/game_screen.dart';
import 'package:skuld/screens/tasks_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentScreenIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: [
          GameScreen(),
          FormScreen(),
          TasksScreen(),
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
          BottomNavigationBarItem(label: 'Add', icon: const Icon(Icons.add_rounded)),
          BottomNavigationBarItem(label: 'Tasks', icon: const Icon(Icons.menu_rounded)),
        ],
      ),
    );
  }
}