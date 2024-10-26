import 'package:flutter/material.dart';
import 'package:skuld/models/quest.dart';
import 'package:skuld/models/task.dart';
import 'package:skuld/database/database_service.dart';
import 'package:skuld/screens/form_screen.dart';
import 'package:skuld/utils/common_text.dart';
import 'package:skuld/widgets/task_card.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final DatabaseService _db = DatabaseService();
  bool _displayDoneTasks = false;

  late ValueNotifier<List<Task>> _tasksNotifier;
  late ValueNotifier<List<Task>> _doneTasksNotifier;

  @override
  void initState() {
    super.initState();
    _tasksNotifier = ValueNotifier<List<Task>>([]);
    _doneTasksNotifier = ValueNotifier<List<Task>>([]);
    _fetchTasks();
  }

  @override
  void dispose() {
    _tasksNotifier.dispose();
    _doneTasksNotifier.dispose();
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
                  child: Text(Texts.textTasksTitle, style: Theme.of(context).textTheme.bodyLarge),
                ),
              ),
              _taskList(_tasksNotifier),
              SliverToBoxAdapter(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () => setState(() => _displayDoneTasks = !_displayDoneTasks),
                    style: const ButtonStyle(
                      padding: WidgetStatePropertyAll(EdgeInsets.zero),
                      overlayColor: WidgetStatePropertyAll(Colors.transparent),
                    ),
                    label: Text(Texts.textDoneTasksBtn, style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).colorScheme.primary)),
                    icon: Icon(_displayDoneTasks ? Icons.keyboard_arrow_down_rounded : Icons.keyboard_arrow_right_rounded),
                  ),
                ),
              ),
              if (_displayDoneTasks)
                _taskList(_doneTasksNotifier),
            ],
          ),
          FloatingActionButton(
            heroTag: UniqueKey(),
            elevation: 2,
            shape: const CircleBorder(),
            onPressed: _createOrUpdateTask,
            child: const Icon(Icons.add_rounded),
          ),
        ],
      ),
    );
  }

  ValueListenableBuilder _taskList(ValueNotifier<List<Task>> taskNotifier) {
    return ValueListenableBuilder<List<Task>>(
      valueListenable: taskNotifier,
      builder: (context, tasks, _) {
        if (tasks.isEmpty) {
          return SliverToBoxAdapter(
            child: Center(child: Text(Texts.textNoTask, style: Theme.of(context).textTheme.bodyLarge)),
          );
        }
        return SliverList.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            Task task = tasks[index];
            return TaskCard(
              task: task,
              onTap: () => _createOrUpdateTask({QuestType.task: task}),
              onCheck: (value) => _completeTask(task, value),
            );
          },
        );
      },
    );
  }


  Future<void> _createOrUpdateTask([Map<QuestType, Task>? typeAndQuest]) async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FormScreen(typeAndQuest: typeAndQuest)),
    ) ?? false;

    if (result) {
      await _fetchTasks();
    }
  }

  Future<void> _completeTask(Task task, bool? value) async {
    final bool state = value ?? task.isDone;
    await _db.completeTask(task.id, state);
    await _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    _tasksNotifier.value = await _db.getTasks(false);
    _doneTasksNotifier.value = await _db.getTasks(true);
  }
}