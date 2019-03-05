import 'fastter_store_creators.dart';

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

final projectsQueries = graphqlQueryCreator<Project>(
    'project', projectFragment, (t) => Project.fromJson(t));
