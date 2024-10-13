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
}