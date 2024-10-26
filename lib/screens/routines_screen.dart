import 'package:flutter/material.dart';
import 'package:skuld/models/quest.dart';
import 'package:skuld/models/routine.dart';
import 'package:skuld/provider/database_service.dart';
import 'package:skuld/screens/form_screen.dart';
import 'package:skuld/utils/common_text.dart';
import 'package:skuld/utils/functions.dart';
import 'package:skuld/widgets/routine_card.dart';

class RoutinesScreen extends StatefulWidget {
  const RoutinesScreen({super.key});

  @override
  State<RoutinesScreen> createState() => _RoutinesScreenState();
}

class _RoutinesScreenState extends State<RoutinesScreen> {
  final DatabaseService _db = DatabaseService();
  bool _displayDoneRoutines = false;

  late ValueNotifier<List<Routine>> _routinesNotifier;
  late ValueNotifier<List<Routine>> _doneRoutinesNotifier;

  @override
  void initState() {
    super.initState();
    _routinesNotifier = ValueNotifier<List<Routine>>([]);
    _doneRoutinesNotifier = ValueNotifier<List<Routine>>([]);
    _fetchRoutines();
  }

  @override
  void dispose() {
    _routinesNotifier.dispose();
    _doneRoutinesNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: [
          CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                sliver: SliverToBoxAdapter(
                  child: Text(Texts.textRoutinesTitle, style: Theme.of(context).textTheme.bodyLarge),
                ),
              ),
              _routineList(_routinesNotifier),
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
                _routineList(_doneRoutinesNotifier),
            ],
          ),
          FloatingActionButton(
            heroTag: UniqueKey(),
            elevation: 2,
            shape: const CircleBorder(),
            onPressed: _createOrUpdateRoutine,
            child: const Icon(Icons.add_rounded),
          ),
        ],
      ),
    );
  }

  ValueListenableBuilder _routineList(ValueNotifier<List<Routine>> routineNotifier) {
    return ValueListenableBuilder<List<Routine>>(
      valueListenable: routineNotifier,
      builder: (context, routines, _) {
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
              onTap: () => _createOrUpdateRoutine({QuestType.routine: routine}),
              onCheck: (value) => _completeRoutine(routine),
            );
          },
        );
      },
    );
  }

  Future<void> _createOrUpdateRoutine([Map<QuestType, Routine>? typeAndQuest]) async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FormScreen(typeAndQuest: typeAndQuest)),
    ) ?? false;

    if (result) {
      await _fetchRoutines();
    }
  }

  Future<void> _completeRoutine(Routine routine) async {
    if (routine.isDone) { return; }

    setState(() {
      routine.isDone = true;
    });

    routine.dueDateTime = Functions.getNextDate(routine.dueDateTime, routine.frequency, routine.period, routine.days);
    Future.delayed(const Duration(milliseconds: 500), () async {
      routine.isDone = false;
      await _db.insertOrUpdateRoutine(routine);
      await _fetchRoutines();
    });
  }

  Future<void> _fetchRoutines() async {
    _routinesNotifier.value = await _db.getRoutines(false);
    _doneRoutinesNotifier.value = await _db.getRoutines(true);
  }
}