enum QuestType {
  task,
  habit,
  routine,
}

const Map<QuestType, String> questToLabel = {
  QuestType.task: 'Task',
  QuestType.habit: 'Habit',
  QuestType.routine: 'Routine',
};

class Report {
  final List<Quest> dailyQuests;
  final bool isPenalty;

  Report({required this.dailyQuests, required this.isPenalty});
}

class Quest {
  String title;
  bool isDone;

  Quest(this.title, this.isDone);
}