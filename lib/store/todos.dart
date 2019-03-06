import '../fastter/fastter_redux.dart';
import '../fastter/fastter_queries.dart';
import '../fastter/fastter_middleware.dart';

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
        label {
            _id
        }
        createdAt
        updatedAt
    }
''';

final todosReducer = createListDataRedux<Todo>();

final todosMiddleware = ListDataMiddleware<Todo, AppState>(
  queries: graphqlQueryCreator<Todo>(
    'todo',
    todoFragment,
    (t) => Todo.fromJson(t),
  ),
);

bool filterTodo(Todo todo, Map<String, dynamic> filter) {
  bool matched = true;
  if (filter.containsKey('project')) {
    if (filter['project'] == null) {
      matched = matched && todo.project == null;
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
