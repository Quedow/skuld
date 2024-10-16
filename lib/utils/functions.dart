import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

abstract class Functions {
  static Color getColor(String hexCode) {
    return Color(int.parse(hexCode.replaceFirst('#', '0xff')));
  }

  static String getDate(DateTime date) {
    return DateFormat('MM/dd/yyyy').format(date);
  }

  static String getTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  static T? tryCast<T>(dynamic x) => x is T ? x : null;
}