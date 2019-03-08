class ToggleSelectTodo {
  ToggleSelectTodo(this.todoid);

  final String todoid;
}

class SelectTodo {
  SelectTodo(this.todoid);

  final String todoid;
}

class UnSelectTodo {
  UnSelectTodo(this.todoid);

  final String todoid;
}

List<String> selectedTodos(List<String> state, action) {
  if (state == null) {
    state = [];
  }
  if (action is ToggleSelectTodo) {
    if (state.contains(action.todoid)) {
      return List<String>.from(state)..remove(action.todoid);
    } else {
      return List<String>.from(state)..add(action.todoid);
    }
  } else if (action is SelectTodo) {
    if (!state.contains(action.todoid)) {
      return List<String>.from(state)..add(action.todoid);
    }
  } else if (action is UnSelectTodo) {
    if (state.contains(action.todoid)) {
      return List<String>.from(state)..remove(action.todoid);
    }
  }
  return state;
}
