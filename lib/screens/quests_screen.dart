import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skuld/provider/quest_provider.dart';
import 'package:skuld/screens/habits_screen.dart';
import 'package:skuld/screens/routines_screen.dart';
import 'package:skuld/screens/tasks_screen.dart';
import 'package:skuld/utils/common_text.dart';

class QuestsScreen extends StatefulWidget {
  const QuestsScreen({super.key});

  @override
  State<QuestsScreen> createState() => _QuestsScreenState();
}

class _QuestsScreenState extends State<QuestsScreen> {
  late QuestProvider _questProvider;
  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _questProvider = Provider.of<QuestProvider>(context, listen: false);
    _screens.addAll([
      TasksScreen(questProvider: _questProvider),
      HabitsScreen(questProvider: _questProvider),
      RoutinesScreen(questProvider: _questProvider),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomEnd,
      children: [
        DefaultTabController(
          initialIndex: 0,
          length: _screens.length,
          child: Scaffold(
            appBar: AppBar(
              toolbarHeight: 0,
              bottom: TabBar(
                tabs: [
                  Tab(icon: const Icon(Icons.checklist_rounded), text: Texts.textTasksTitle),
                  Tab(icon: const Icon(Icons.psychology_rounded), text: Texts.textHabitTitle),
                  Tab(icon: const Icon(Icons.loop_rounded), text: Texts.textRoutinesTitle),
                ],
              ),
            ),
            body: TabBarView(children: _screens),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: FloatingActionButton(
            heroTag: UniqueKey(),
            elevation: 2,
            shape: const CircleBorder(),
            onPressed: () => _questProvider.createOrUpdateTask(context),
            child: const Icon(Icons.add_rounded),
          ),
        ),
      ],
    );
  }
}