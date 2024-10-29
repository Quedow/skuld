import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skuld/models/quest.dart';
import 'package:skuld/models/routine.dart';
import 'package:skuld/database/database_service.dart';
import 'package:skuld/provider/quest_provider.dart';
import 'package:skuld/utils/common_text.dart';
import 'package:skuld/utils/functions.dart';
import 'package:skuld/widgets/routine_card.dart';

class RoutinesScreen extends StatefulWidget {
  final QuestProvider questProvider;
  
  const RoutinesScreen({super.key, required this.questProvider});

  @override
  State<RoutinesScreen> createState() => _RoutinesScreenState();
}

class _RoutinesScreenState extends State<RoutinesScreen> {
  late final QuestProvider _questProvider;
  bool _displayDoneRoutines = false;

  @override
  void initState() {
    super.initState();
    _questProvider = widget.questProvider;
    _questProvider.fetchRoutines();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Consumer<QuestProvider>(
        builder: (context, questProvider, _) => CustomScrollView(
          slivers: [
            _routineList(questProvider.routines),
            SliverToBoxAdapter(
              child: Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () => setState(() => _displayDoneRoutines = !_displayDoneRoutines),
                  style: const ButtonStyle(
                    padding: WidgetStatePropertyAll(EdgeInsets.zero),
                    overlayColor: WidgetStatePropertyAll(Colors.transparent),
                  ),
                  label: Text(Texts.textDoneRoutinesBtn, style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).colorScheme.primary)),
                  icon: Icon(_displayDoneRoutines ? Icons.keyboard_arrow_down_rounded : Icons.keyboard_arrow_right_rounded),
                ),
              ),
            ),
            if (_displayDoneRoutines) 
              _routineList(questProvider.doneRoutines),
          ],
        ),
      ),
    );
  }

  Widget _routineList(List<Routine> routines) {
    if (routines.isEmpty) {
      return SliverToBoxAdapter(
        child: Center(child: Text(Texts.textNoRoutine, style: Theme.of(context).textTheme.bodyLarge)),
      );
    }
    return SliverList.builder(
      itemCount: routines.length,
      itemBuilder: (context, index) {
        Routine routine = routines[index];
        return RoutineCard(
          routine: routine,
          onTap: () => _questProvider.createOrUpdateRoutine(context, {QuestType.routine: routine}),
          onCheck: (value) => _completeRoutine(routine),
        );
      },
    );
  }

  Future<void> _completeRoutine(Routine routine) async {
    if (routine.isDone) { return; }

    setState(() {
      routine.isDone = true;
    });

    routine.dueDateTime = Functions.getNextDate(routine.dueDateTime, routine.frequency, routine.period, routine.days);
    Future.delayed(const Duration(milliseconds: 500), () async {
      routine.isDone = false;
      await DatabaseService().insertOrUpdateRoutine(routine);
      await _questProvider.fetchRoutines();
    });
  }
}