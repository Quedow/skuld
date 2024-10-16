import 'package:skuld/models/quest.dart';

abstract class Texts {
  static String textTitleForm(bool isEditMode, QuestType questType) {
    return isEditMode 
      ? 'Edit ${questType == QuestType.task ? "Task" : "Habit"}'
      : 'Create ${questType == QuestType.task ? "Task" : "Habit"}';
  }

  // Errors
  static String errorLoadingTasks = 'Error when loading tasks';

  // Rules
  static String errorRequiredRule = 'This filed cannot be empty';
}
