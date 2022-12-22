import '../fastter/fastter_bloc.dart';

import '../models/todocomment.model.dart';

const String _todoCommentsFragment = '''
    fragment todoComment on TodoComment {
        _id
        content
        type
        todo {
            _id
        }
        createdAt
        updatedAt
    }
''';

final FastterBloc<TodoComment> fastterTodoComments = FastterBloc<TodoComment>(
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
