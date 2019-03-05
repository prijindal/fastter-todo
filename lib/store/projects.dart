import 'fastter_redux.dart';
import 'fastter_queries.dart';
import 'fastter_middleware.dart';

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

final _projectsQueries = graphqlQueryCreator<Project>(
    'project', projectFragment, (t) => Project.fromJson(t));

final projectsMiddleware =
    ListDataMiddleware<Project>(queries: _projectsQueries);
