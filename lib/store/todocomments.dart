import '../fastter/fastter_redux.dart';

import '../models/todocomment.model.dart';
import './state.dart';

const String _todoCommentsFragment = '''
    fragment todoComment on TodoComment {
        _id
        content
        todo {
            _id
        }
        createdAt
        updatedAt
    }
''';

final FastterListRedux<TodoComment, AppState> fastterTodoComments =
    FastterListRedux<TodoComment, AppState>(
  name: 'todoComment',
  fragment: _todoCommentsFragment,
  fromJson: (json) => TodoComment.fromJson(json),
  toInput: (obj) {
    final json = obj.toJson();
    json.remove('_id');
    json.remove('createdAt');
    json.remove('updatedAt');
    json['todo'] = obj.todo == null ? null : obj.todo.id;
    return json;
  },
  filterObject: (todoComment, filter) => true,
);
