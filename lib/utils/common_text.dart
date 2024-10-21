import 'package:skuld/models/quest.dart';

abstract class Texts {
  static String textTitleForm(bool isEditMode, QuestType questType) {
    return isEditMode 
      ? 'Edit ${questType == QuestType.task ? "Task" : "Habit"}'
      : 'Create ${questType == QuestType.task ? "Task" : "Habit"}';
  }

  static String textTasksTitle = 'TASKS';
  static String textDoneTasksBtn = 'DONE TASKS';
  static String textNoTask = '🤔 No task for now...';

  static String textHabitTitle = 'HABITS';
  static String textNoHabit = '🤔 No task for now...';

  static String textDeletionDialog = 'Do you confirm the deletion?';

  // Errors
  static String errorLoadingTasks = 'Error when loading tasks';
  static String errorLoadingHabits = 'Error when loading habits';

  // Rules
  static String errorRequiredRule = 'This filed cannot be empty';
}
