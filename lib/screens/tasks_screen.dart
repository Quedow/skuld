import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skuld/models/quest.dart';
import 'package:skuld/models/task.dart';
import 'package:skuld/providers/quest_provider.dart';
import 'package:skuld/pages/form_page.dart';
import 'package:skuld/utils/common_text.dart';
import 'package:skuld/widgets/overlays.dart';
import 'package:skuld/widgets/task_card.dart';

class TasksScreen extends StatefulWidget {
  final QuestProvider questProvider;

  const TasksScreen({super.key, required this.questProvider});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  late final QuestProvider _questProvider;
  bool _displayDoneTasks = false;
  final ValueNotifier<int> _rateIndex = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    _questProvider = widget.questProvider;
    _questProvider.fetchTasks();
    _questProvider.fetchDoneRates();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Consumer<QuestProvider>(
        builder: (context, questProvider, _) => CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: ValueListenableBuilder<int>(
                    valueListenable: _rateIndex,
                    builder: (context, rateIndex, _) => GestureDetector(
                      onTap: () => _rateIndex.value = (rateIndex + 1) % questProvider.doneRates.length,
                      child: Text(CText.textDoneRate(questProvider.doneRates[rateIndex], rateIndex == 1), style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).colorScheme.primary)),
                    ),
                  ),
                ),
              ),
            ),
            _taskList(questProvider.tasks),
            SliverToBoxAdapter(
              child: Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () => setState(() => _displayDoneTasks = !_displayDoneTasks),
                  style: const ButtonStyle(
                    padding: WidgetStatePropertyAll(EdgeInsets.zero),
                    overlayColor: WidgetStatePropertyAll(Colors.transparent),
                  ),
                  label: Text(CText.textDoneTasksBtn, style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).colorScheme.primary)),
                  icon: Icon(_displayDoneTasks ? Icons.keyboard_arrow_down_rounded : Icons.keyboard_arrow_right_rounded),
                ),
              ),
            ),
            if (_displayDoneTasks)
              _taskList(questProvider.doneTasks),
          ],
        ),
      ),
    );
  }

  Widget _taskList(List<Task> tasks) {
    if (tasks.isEmpty) {
      return SliverToBoxAdapter(
        child: Center(child: Text(CText.textNoTask, style: Theme.of(context).textTheme.bodyLarge)),
      );
    }
    return SliverList.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final GlobalKey key = GlobalKey();
        final Task task = tasks[index];
        return TaskCard(
          animationOriginKey: key,
          task: task,
          onTap: () => _navigateToFormScreen(context, {QuestType.task: task}),
          onCheck: (value) {
            Overlays.playRewardAnimation(context, key, task);
            _questProvider.completeTask(task, value);
          },
        );
      },
    );
  }

  static Future<void> _navigateToFormScreen(BuildContext context, Map<QuestType, Task> typeAndQuest) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FormPage(typeAndQuest: typeAndQuest)),
    );
  }
}