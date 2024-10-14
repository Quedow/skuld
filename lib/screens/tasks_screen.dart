import 'package:flutter/material.dart';
import 'package:skuld/models/quest.dart';
import 'package:skuld/models/task.dart';
import 'package:skuld/provider/database_service.dart';
import 'package:skuld/screens/form_screen.dart';
import 'package:skuld/utils/functions.dart';

class TasksScreen extends StatefulWidget {

  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final DatabaseService _db = DatabaseService();
  late Future<List<Task>> _tasks;
  
  @override
  void initState() {
    super.initState();
    _tasks = _db.getTasks();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Task>>(
      future: _tasks,
      builder: (BuildContext context, AsyncSnapshot<List<Task>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error when loading tasks'));
        }

        final List<Task> tasks = snapshot.data ?? [];

        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            Task task = tasks[index];
            bool dueDateExpired = task.dueDateTime.isBefore(DateTime.now());
          
            // if (task.isDone) { return SizedBox.shrink(); }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: GestureDetector(
                onTap: () => _navigateToFormScreen(task.id),
                child: ListTile(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  tileColor: const Color(0xFFE1E1E1),
                  leading: Checkbox(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                    value: task.isDone,
                    onChanged: (value) async {
                      final bool state = value ?? task.isDone;
                      await _db.completeTask(task.id, state);
                      setState(() {
                        task.isDone = state;
                      });
                    },
                  ),
                  title: Text(task.title, style: TextStyle(color: !dueDateExpired ? Colors.black : Colors.red)),
                  subtitle: Wrap(
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 5,
                    children: [
                      const Icon(Icons.access_time_rounded, size: 15),
                      Text(Functions.getTime(task.dueDateTime)),
                      const Icon(Icons.calendar_today_rounded, size: 15),
                      Text(Functions.getDate(task.dueDateTime)),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _navigateToFormScreen(int id) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormScreen(questTypeAndId: {QuestType.task: id}),
      ),
    );
    if (result == true) {
      setState(() {
        _tasks = _db.getTasks();
      });
    }
  }
}