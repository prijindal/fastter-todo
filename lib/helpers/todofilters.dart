import 'package:fastter_dart/models/base.model.dart';
import 'package:fastter_dart/models/todo.model.dart';
import 'package:fastter_dart/store/todos.dart';

int filterToCount(Map<String, dynamic> filter, ListState<Todo> todos) => todos
    .items
    .where((todo) =>
        todo.parent == null &&
        todo.completed != true &&
        fastterTodos.filterObject(todo, filter))
    .length;
