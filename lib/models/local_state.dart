import 'package:flutter/material.dart';

import '../helpers/todos_sorting_algoritm.dart';

enum TodosView {
  list,
  grid,
}

class LocalStateNotifier with ChangeNotifier {
  List<String> _selectedTodoIds = [];

  TodosSortingAlgorithm _todosSortingAlgorithm = TodosSortingAlgorithm.base();

  TodosView _todosView = TodosView.list;

  LocalStateNotifier({
    List<String>? selectedTodoIds,
    TodosSortingAlgorithm? todosSortingAlgorithm,
    TodosView? todosView,
  })  : _selectedTodoIds = selectedTodoIds ?? [],
        _todosSortingAlgorithm =
            todosSortingAlgorithm ?? TodosSortingAlgorithm.base(),
        _todosView = todosView ?? TodosView.list;

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

  TodosView get todosView => _todosView;

  void setTodosView(TodosView value) {
    _todosView = value;
    notifyListeners();
  }
}
