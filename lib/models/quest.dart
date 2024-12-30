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