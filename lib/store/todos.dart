import 'fastter/fastter_redux.dart';
import 'fastter/fastter_queries.dart';
import 'fastter/fastter_middleware.dart';

import '../models/todo.model.dart';

const todoFragment = '''
    fragment todo on Todo {
        _id
        title
        completed
        content
        dueDate
        project {
            _id
        }
        label {
            _id
        }
        createdAt
        updatedAt
    }
''';

final todosReducer = createListDataRedux<Todo>();

final todosMiddleware = ListDataMiddleware<Todo>(
  queries: graphqlQueryCreator<Todo>(
    'todo',
    todoFragment,
    (t) => Todo.fromJson(t),
  ),
);
