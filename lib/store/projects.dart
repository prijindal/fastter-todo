import '../fastter/fastter_redux.dart';

import '../models/project.model.dart';
import './state.dart';

const projectFragment = '''
    fragment project on Project {
        _id
        title
        color
        createdAt
        updatedAt
    }
''';

final fastterProjects = FastterListRedux<Project, AppState>(
  name: 'project',
  fragment: projectFragment,
  fromJson: (json) => Project.fromJson(json),
  toInput: (Project obj) {
    Map<String, dynamic> json = obj.toJson();
    json.remove('_id');
    return json;
  },
  filterObject: (Project project, Map<String, dynamic> filter) => true,
);
