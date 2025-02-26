import 'package:flutter/material.dart';
import 'package:skuld/provider/quest_provider.dart';
import 'package:skuld/pages/form_page.dart';
import 'package:skuld/screens/habits_screen.dart';
import 'package:skuld/screens/routines_screen.dart';
import 'package:skuld/screens/tasks_screen.dart';
import 'package:skuld/utils/common_text.dart';

class QuestsScreen extends StatefulWidget {
  final QuestProvider questProvider;

  const QuestsScreen({super.key, required this.questProvider});

  @override
  State<QuestsScreen> createState() => _QuestsScreenState();
}

class _QuestsScreenState extends State<QuestsScreen> {
  late final QuestProvider _questProvider;
  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _questProvider = widget.questProvider;
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
                  Tab(icon: const Icon(Icons.checklist_rounded), text: CText.textTasksTitle),
                  Tab(icon: const Icon(Icons.psychology_rounded), text: CText.textHabitTitle),
                  Tab(icon: const Icon(Icons.loop_rounded), text: CText.textRoutinesTitle),
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
            onPressed: () => _navigateToFormScreen(context),
            child: const Icon(Icons.add_rounded),
          ),
        ),
      ],
    );
  }

  static Future<void> _navigateToFormScreen(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FormPage()),
    );
  }
}