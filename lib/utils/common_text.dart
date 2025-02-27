import 'package:skuld/models/quest.dart';
import 'package:skuld/models/routine.dart';
import 'package:skuld/utils/functions.dart';

abstract class CText {
  static String textTitleForm(bool isEditMode, QuestType questType) {
    switch (questType) {
      case QuestType.task:
        return isEditMode ? 'Edit Task' : 'Create Task';
      case QuestType.habit:
        return isEditMode ? 'Edit Habit' : 'Create Habit';
      case QuestType.routine:
        return isEditMode ? 'Edit Routine' : 'Create Routine';
    }
  }

  static String textEndRoutine(bool isDone) {
    return isDone ? 'Continue Routine' : 'End Routine';
  }

  static String textRoutineDetail(int frequency, String period) {
    return 'All $frequency ${periodToLabel[period]}';
  }

  static String textDoneRate(int value, bool isWeek) {
    return '$value % (${isWeek ? 'WEEK' : 'TODAY'})';
  }

  static String textLastTime(DateTime? lastDateTime, [bool isLongFormat = false]) {
    if (lastDateTime == null) return 'Never';
    final DateTime now = DateTime.now();
    final int daysAgo = DateTime(now.year, now.month, now.day)
      .difference(DateTime(lastDateTime.year, lastDateTime.month, lastDateTime.day)).inDays;
    final String content = switch (daysAgo) {
      0 => 'Today',
      1 => '1 day ago',
      _ => '$daysAgo days ago',
    };

    return isLongFormat ? 'Last activity: $content (${Functions.getDate(lastDateTime)})' : content;
  }

  // Quests
  static String textDailyQuestsTitle = 'DAILY QUESTS';
  static String textNoDailyQuest = 'Nothing to do today.';
  static String textIsPenalty = 'Attention ! Some old quests have not been completed.';

  // Tasks
  static String textTasksTitle = 'TASKS';
  static String textDoneTasksBtn = 'DONE TASKS';
  static String textNoTask = '🤔 No task for now...';

 // Habits
  static String textHabitTitle = 'HABITS';
  static String textNoHabit = '🤔 No task for now...';

 // Routines
  static String textRoutinesTitle = 'ROUTINES';
  static String textDoneRoutinesBtn = 'ENDED ROUTINES';
  static String textNoRoutine = '🤔 No routines for now...';

  // Popup
  static String textDeletionDialog = 'Do you confirm the deletion?';
  
  // Settings
  static String textDropdownFrequency = 'Frequency';
  static String textDeletionFrequency = 'Deletion frequency';
  static String textDeletionFrequencyContent = 'Quests with due date prior to the selected setting will be deleted.';
  static String textDeletePrefs = 'Delete preferences';
  static String textDeletePrefsContent = 'Preference settings will be reset default values.';

  // Note
  static String textNote = 'Note';
  static String textNoteLabel = 'Inspiration starts here...';
  static String textNoteSaved = 'Your note has been saved';

  // Errors
  static String errorLoadingTasks = 'Error when loading tasks'; // Not used
  static String errorLoadingHabits = 'Error when loading habits'; // Not used
  static String errorLoadingPlayer = 'ERROR WHEN LOADING PLAYER STATS';

  // Rules
  static String errorRequiredRule = 'This filed cannot be empty';
  static String errorIntegerRule = 'This field must be a whole number';
}
