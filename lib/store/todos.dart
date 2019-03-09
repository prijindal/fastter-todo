import '../fastter/fastter_redux.dart';

import '../models/todo.model.dart';
import './state.dart';

const todoFragment = '''
    fragment todo on Todo {
        _id
        title
        completed
        content
        dueDate
        project {
            _id
            title
            color
        }
        labels {
            _id
        }
        createdAt
        updatedAt
    }
''';

final fastterTodos = FastterListRedux<Todo, AppState>(
  name: 'todo',
  fragment: todoFragment,
  fromJson: (t) => Todo.fromJson(t),
  toInput: (Todo obj) {
    Map<String, dynamic> json = obj.toJson();
    json.remove('_id');
    json['project'] = obj.project == null ? null : obj.project.id;
    json['labels'] =
        obj.labels == null ? [] : obj.labels.map((l) => l.id).toList();
    return json;
  },
  filterObject: _filterTodo,
);

bool _filterTodo(Todo todo, Map<String, dynamic> filter) {
  bool matched = true;
  if (filter.containsKey('project')) {
    if (filter['project'] == null) {
      matched = matched && todo.project == null;
    } else if (todo.project == null) {
      matched = matched && false;
    } else {
      matched = matched && todo.project.id == filter['project'];
    }
  }
  if (filter.containsKey("_operators")) {
    if (filter["_operators"].containsKey("dueDate")) {
      if (todo.dueDate == null) {
        matched = matched && false;
      }
      if (filter["_operators"]["dueDate"].containsKey("gte")) {
        DateTime gte = filter["_operators"]["dueDate"]["gte"];
        matched = matched && todo.dueDate.compareTo(gte) >= 0;
      }
      if (filter["_operators"]["dueDate"].containsKey("lte")) {
        DateTime lte = filter["_operators"]["dueDate"]["lte"];
        matched = matched && todo.dueDate.compareTo(lte) <= 0;
      }
    }
  }
  return matched;
}
