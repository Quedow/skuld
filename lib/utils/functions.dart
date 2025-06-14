import 'dart:math';

import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

abstract class Functions {
  static String getDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static String getTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  static String getBackupDate() {
    return DateFormat('dd-MM-yyyy_HH-mm-ss').format(DateTime.now());
  }

  static int getMaxHp(int level) {
    return 100 + level * 20;
  }

  static int getTargetXp(int level) {
    return level == 0 ? 50 : level * 100;
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


  static double getRandomDouble(double min, double max) {
    final random = Random();
    return min + (random.nextDouble() * (max - min));
  }
}