import 'package:flutter/material.dart';
import 'package:skuld/models/quest.dart';
import 'package:skuld/models/task.dart';
import 'package:skuld/provider/quest_provider.dart';
import 'package:skuld/screens/form_screen.dart';
import 'package:skuld/utils/functions.dart';

class TasksScreen extends StatefulWidget {
  final QuestProvider questProvider;

  const TasksScreen({super.key, required this.questProvider});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  @override
  Widget build(BuildContext context) {
    final QuestProvider questProvider = widget.questProvider;
    final List<Task> tasks = questProvider.tasks;

    return ListView.builder(
      shrinkWrap: true,
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        Task task = tasks[index];
        bool dueDateExpired = task.dueDateTime.isBefore(DateTime.now());

        // if (task.isDone) { return SizedBox.shrink(); }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: GestureDetector(
            onTap: () => _navigateToFormScreen(questProvider, task.id),
            child: ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              tileColor: const Color(0xFFE1E1E1),
              leading: Checkbox(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                value: task.isDone,
                onChanged: (value) => setState(() => questProvider.completeTask(index, value ?? task.isDone)),
              ),
              title: Text(task.title, style: TextStyle(color: !dueDateExpired ? Colors.black : Colors.red)),
              subtitle: Wrap(
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 5,
                children: [
                  Icon(Icons.access_time_rounded, size: 15),
                  Text(Functions.getTime(task.dueDateTime)),
                  Icon(Icons.calendar_today_rounded, size: 15),
                  Text(Functions.getDate(task.dueDateTime)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _navigateToFormScreen(QuestProvider questProvider, int taskId) async {
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => FormScreen(questProvider: questProvider, questTypeAndId: {QuestType.task: taskId})));

    if (result == true) {
      setState(() {

      });
    }
  }
}