import '../fastter/fastter_bloc.dart';
import '../models/base.model.dart';
import '../models/project.model.dart';

const _projectFragment = '''
    fragment project on Project {
        _id
        title
        color
        index
        createdAt
        updatedAt
    }
''';

final FastterBloc<Project> fastterProjects = FastterBloc<Project>(
  name: 'project',
  fragment: _projectFragment,
  fromJson: (json) => Project.fromJson(json),
  toInput: (obj) {
    final json = obj.toJson();
    json.remove('_id');
    json.remove('createdAt');
    json.remove('updatedAt');
    return json;
  },
  filterObject: (project, filter) {
    var matched = true;
    if (filter.containsKey('query')) {
      matched = matched &&
          project.title.toLowerCase().contains(filter['query'].toLowerCase());
    }
    return matched;
  },
);

CompareFunction<Project> getCompareFunction(String sortBy) => (a, b) {
      if (sortBy == 'index') {
        if (a.index == null || b.index == null) {
          return a.index == null ? 1 : 0;
        }
        return a.index!.compareTo(b.index!);
      }
      if (sortBy == 'title') {
        if (a.title == null || b.title == null) {
          return a.title == null ? 1 : 0;
        }
        return a.title.compareTo(b.title);
      }

      if (a.createdAt != null && b.createdAt != null) {
        return a.createdAt.compareTo(b.createdAt);
      } else if (a.id != null && b.id != null) {
        return a.id.compareTo(b.id);
      } else {
        return 0;
      }
    };
