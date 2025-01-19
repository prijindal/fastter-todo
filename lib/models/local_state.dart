import 'package:flutter/material.dart';

import '../helpers/todos_sorting_algoritm.dart';

class LocalStateNotifier with ChangeNotifier {
  List<String> _selectedTodoIds = [];

  TodosSortingAlgorithm _todosSortingAlgorithm = TodosSortingAlgorithm.base();

  // Getters
  List<String> get selectedTodoIds => List.unmodifiable(_selectedTodoIds);

  void clearSelectedTodoIds() {
    _selectedTodoIds = [];
    notifyListeners();
  }

  void toggleSelectedId(String value) {
    if (_selectedTodoIds.contains(value)) {
      _selectedTodoIds = _selectedTodoIds.where((a) => a != value).toList();
    } else {
      _selectedTodoIds = _selectedTodoIds..add(value);
    }
    notifyListeners();
  }

  // Getters
  TodosSortingAlgorithm get todosSortingAlgorithm => _todosSortingAlgorithm;

  void setTodosSortingAlgorithm(TodosSortingAlgorithm value) {
    _todosSortingAlgorithm = value;
    notifyListeners();
  }
}
