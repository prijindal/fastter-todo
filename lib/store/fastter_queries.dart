import 'package:flutter/foundation.dart';
import '../models/base.model.dart';
import '../helpers/fastter.dart';

class GraphQLQueries<T extends BaseModel> {
  GraphQLQueries({@required this.syncQuery});

  Future<List<T>> Function([Map<String, dynamic> filter, String extraFields])
      syncQuery;
}

GraphQLQueries<T> graphqlQueryCreator<T extends BaseModel>(
    String name, String fragment, T Function(Map<String, dynamic>) fromJson) {
  String capitalized = name.replaceRange(0, 1, name[0].toUpperCase());
  return GraphQLQueries<T>(
    syncQuery: ([
      Map<String, dynamic> filter = const {},
      String extraFields = '',
    ]) {
      return fastter
          .request(
        new Request(
          query: '''
                query(\$filter:FilterFindMany${capitalized}Input){
                  ${name}s(filter:\$filter) {
                    ...$name
                    $extraFields
                  }
                }
                $fragment
              ''',
        ),
      )
          .then((response) {
        if (response.containsKey('${name}s')) {
          return (response['${name}s'] as List<dynamic>)
              .map<T>((todo) => fromJson(todo))
              .toList();
        }
        return null;
      });
    },
  );
}
