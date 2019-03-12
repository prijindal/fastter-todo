import '../fastter/fastter_redux.dart';

import '../models/project.model.dart';
import './state.dart';

const _projectFragment = '''
    fragment project on Project {
        _id
        title
        color
        createdAt
        updatedAt
    }
''';

final FastterListRedux<Project, AppState> fastterProjects =
    FastterListRedux<Project, AppState>(
  name: 'project',
  fragment: _projectFragment,
  fromJson: (json) => Project.fromJson(json),
  toInput: (obj) {
    final json = obj.toJson();
    json.remove('_id');
    return json;
  },
  filterObject: (project, filter) => true,
);
