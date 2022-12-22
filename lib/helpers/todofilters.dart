import '../models/base.model.dart';
import '../models/todo.model.dart';
import '../store/todos.dart';

int filterToCount(Map<String, dynamic> filter, ListState<Todo> todos) => todos
    .items
    .where((todo) =>
        todo.parent == null &&
        todo.completed != true &&
        fastterTodos.filterObject(todo, filter))
    .length;
