import 'package:flutter/material.dart';

class QuestProvider with ChangeNotifier {
  int _currentScreenIndex = 0;
  int get currentScreenIndex => _currentScreenIndex;

  void updateScreenIndex(int index) {
    if (index != _currentScreenIndex) {
      _currentScreenIndex = index;
    }
    notifyListeners();
  }
}
