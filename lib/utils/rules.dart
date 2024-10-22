import 'package:skuld/utils/common_text.dart';

abstract class Rules {
  static String? free(String? value) {
    return null;
  }

  static String? isNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return Texts.errorRequiredRule;
    }
    return null;
  }

  static String? isInteger(String? value) {
    String? isNull = isNotEmpty(value);
    if (isNull != null) {
      return isNull;
    } else if (int.tryParse(value!) == null) {
      return Texts.errorIntegerRule;
    }
    return null;
  }
}