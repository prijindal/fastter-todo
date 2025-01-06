import 'package:flutter/material.dart';

class LocalStateNotifier with ChangeNotifier {
  List<String> _selectedTodoIds = [];

  // Getters
  List<String> get selectedTodoIds => _selectedTodoIds;

  void setSelectedTodoIds(List<String> value) {
    _selectedTodoIds = value;
    notifyListeners();
  }
}
