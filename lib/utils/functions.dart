import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:skuld/models/quest.dart';
import 'package:skuld/screens/form_screen.dart';

abstract class Functions {
  static String getDate(DateTime date) {
    return DateFormat('MM/dd/yyyy').format(date);
  }

  static String getTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  static T? tryCast<T>(dynamic x) => x is T ? x : null;

  static DateTime getNextDate(DateTime date, int frequency, String period, List<int> days) {
    Jiffy.setLocale('fr');
    Jiffy jiffyDate = Jiffy.parseFromDateTime(date);
    int dayOfWeek = jiffyDate.dayOfWeek;
    days.sort();

    DateTime? nextDate;

    switch (period) {
      case 'w':
        for (var day in days) {
          if (day > dayOfWeek) {
            nextDate = jiffyDate.add(days: day - dayOfWeek).dateTime;
            return nextDate;
          }
        }
        nextDate = jiffyDate.add(weeks: frequency).dateTime;        
        nextDate = nextDate.subtract(Duration(days: (nextDate.weekday - days.first)));
        break;
      case 'd':
        nextDate = jiffyDate.add(days: frequency).dateTime;
        break;
      case 'm':
        nextDate = jiffyDate.add(months: frequency).dateTime;
        break;
      case 'y':
        nextDate = jiffyDate.add(years: frequency).dateTime;
        break;
    }
    return nextDate ?? date;
  }

  static Future<void> navigateToFormScreen(BuildContext context, [Map<QuestType, dynamic>? typeAndQuest]) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FormScreen(typeAndQuest: typeAndQuest)),
    );
  }
}