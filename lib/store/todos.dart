import 'fastter_store_creators.dart';

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

final todosQueries =
    graphqlQueryCreator<Todo>('todo', todoFragment, (t) => Todo.fromJson(t));
