import 'package:flutter/material.dart';

import '../helpers/todos_sorting_algoritm.dart';

class LocalStateNotifier with ChangeNotifier {
  List<String> _selectedTodoIds = [];

  TodosSortingAlgorithm _todosSortingAlgorithm = TodosSortingAlgorithm.base();

  // Getters
  List<String> get selectedTodoIds => _selectedTodoIds;

  void setSelectedTodoIds(List<String> value) {
    _selectedTodoIds = value;
    notifyListeners();
  }

  // Getters
  TodosSortingAlgorithm get todosSortingAlgorithm => _todosSortingAlgorithm;

  void setTodosSortingAlgorithm(TodosSortingAlgorithm value) {
    _todosSortingAlgorithm = value;
    notifyListeners();
  }
}
