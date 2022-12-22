import '../fastter/fastter_bloc.dart';

import '../models/base.model.dart';
import '../models/todo.model.dart';

const String _todoFragment = '''
    fragment todo on Todo {
        _id
        title
        completed
        dueDate
        priority
        encrypted
        parent {
          _id
        }
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

final FastterBloc<Todo> fastterTodos = FastterBloc<Todo>(
  name: 'todo',
  fragment: _todoFragment,
  fromJson: (t) => Todo.fromJson(t),
  toInput: (obj) {
    final json = obj.toJson();
    json.remove('_id');
    json.remove('createdAt');
    json.remove('updatedAt');
    json['parent'] = obj.parent == null ? null : obj.parent?.id;
    json['project'] = obj.project == null ? null : obj.project?.id;
    json['labels'] =
        obj.labels == null ? <String>[] : obj.labels.map((l) => l.id).toList();
    return json;
  },
  filterObject: _filterTodo,
);

CompareFunction<Todo> getCompareFunction(String sortBy) => (a, b) {
      if (sortBy == 'dueDate') {
        if (a.dueDate == null || b.dueDate == null) {
          return a.dueDate == null ? 1 : 0;
        }
        return a.dueDate.compareTo(b.dueDate);
      }

      if (sortBy == 'priority') {
        if (a.priority == null || b.priority == null) {
          return a.priority == null ? 1 : 0;
        }
        return b.priority.compareTo(a.priority);
      }

      if (sortBy == 'title') {
        if (a.title == null || b.title == null) {
          return a.title == null ? 1 : 0;
        }
        return a.title.compareTo(b.title);
      }

      if (sortBy == 'project') {
        if (a.project == null || b.project == null) {
          return a.project == null ? 1 : 0;
        }
        if (a.project?.title == null || b.project?.title == null) {
          return a.project?.title == null ? 1 : 0;
        }
        return a.project!.title.compareTo(b.project!.title);
      }

      if (a.createdAt != null && b.createdAt != null) {
        return a.createdAt.compareTo(b.createdAt);
      } else if (a.id != null && b.id != null) {
        return a.id.compareTo(b.id);
      } else {
        return 0;
      }
    };

bool _filterTodo(Todo todo, Map<String, dynamic> filter) {
  var matched = true;
  if (filter.containsKey('query')) {
    matched = matched &&
        todo.title.toLowerCase().contains(filter['query'].toLowerCase());
  }
  if (filter.containsKey('project')) {
    if (filter['project'] == null) {
      matched = matched && todo.project == null;
    } else if (todo.project == null) {
      matched = matched && false;
    } else {
      matched = matched && todo.project?.id == filter['project'];
    }
  }
  if (filter.containsKey('label')) {
    if (filter['label'] == null) {
      matched = matched && (todo.labels == null || todo.labels.isEmpty);
    } else if (todo.labels == null || todo.labels.isEmpty) {
      matched = matched && false;
    } else {
      matched = matched &&
          todo.labels.where((label) => label.id == filter['label']).isNotEmpty;
    }
  }
  if (filter.containsKey('_operators')) {
    if (filter['_operators'].containsKey('dueDate')) {
      if (todo.dueDate == null) {
        matched = matched && false;
      }
      if (filter['_operators']['dueDate'].containsKey('gte')) {
        final DateTime gte = filter['_operators']['dueDate']['gte'];
        matched = matched && todo.dueDate.compareTo(gte) >= 0;
      }
      if (filter['_operators']['dueDate'].containsKey('lte')) {
        final DateTime lte = filter['_operators']['dueDate']['lte'];
        matched = matched && todo.dueDate.compareTo(lte) <= 0;
      }
    }
  }
  return matched;
}
