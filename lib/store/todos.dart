import 'fastter_redux.dart';
import 'fastter_queries.dart';
import 'fastter_middleware.dart';

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

final _todosQueries =
    graphqlQueryCreator<Todo>('todo', todoFragment, (t) => Todo.fromJson(t));

final todosMiddleware = ListDataMiddleware<Todo>(queries: _todosQueries);
