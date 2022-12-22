import '../fastter/fastter_bloc.dart';

import '../models/todoreminder.model.dart';

const String _todoRemindersFragment = '''
    fragment todoReminder on TodoReminder {
        _id
        title
        time
        completed
        todo {
            _id
        }
        createdAt
        updatedAt
    }
''';

final FastterBloc<TodoReminder> fastterTodoReminders =
    FastterBloc<TodoReminder>(
  name: 'todoReminder',
  fragment: _todoRemindersFragment,
  fromJson: (json) => TodoReminder.fromJson(json),
  toInput: (obj) {
    final json = obj.toJson();
    json.remove('_id');
    json.remove('createdAt');
    json.remove('updatedAt');
    json['todo'] = obj.todo == null ? null : obj.todo.id;
    return json;
  },
  filterObject: (todoReminder, filter) => true,
);
