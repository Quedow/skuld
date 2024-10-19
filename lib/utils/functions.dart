import 'package:intl/intl.dart';

abstract class Functions {
  static String getDate(DateTime date) {
    return DateFormat('MM/dd/yyyy').format(date);
  }

  static String getTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  static T? tryCast<T>(dynamic x) => x is T ? x : null;
}