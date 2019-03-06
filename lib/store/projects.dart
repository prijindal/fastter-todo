import 'fastter/fastter_redux.dart';
import 'fastter/fastter_queries.dart';
import 'fastter/fastter_middleware.dart';

import '../models/project.model.dart';

const projectFragment = '''
    fragment project on Project {
        _id
        title
        color
        createdAt
        updatedAt
    }
''';

final projectsReducer = createListDataRedux<Project>();

final projectsMiddleware = ListDataMiddleware<Project>(
  queries: graphqlQueryCreator<Project>(
    'project',
    projectFragment,
    (t) => Project.fromJson(t),
  ),
);
