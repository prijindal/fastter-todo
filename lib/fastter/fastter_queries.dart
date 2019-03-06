import 'package:flutter/foundation.dart';
import '../models/base.model.dart';
import './fastter.dart';

class GraphQLQueries<T extends BaseModel> {
  GraphQLQueries({
    @required this.syncQuery,
    @required this.addMutation,
  });

  Future<List<T>> Function([Map<String, dynamic> filter, String extraFields])
      syncQuery;
  Future<T> Function(dynamic object) addMutation;
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
          variables: {
            'filter': filter,
          },
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
    addMutation: (dynamic object) {
      Map<String, dynamic> inputJson = (object as T).toJson();
      inputJson.remove('_id');
      return fastter
          .request(
        new Request(
          query: '''
            mutation(\$object:CreateOne${capitalized}Input!){
                  create$capitalized(record: \$object) {
                    record {
                      ...$name
                    }
                  }
              }
              $fragment
          ''',
          variables: {
            'object': inputJson,
          },
        ),
      )
          .then(
        (response) {
          if (response.containsKey('create$capitalized')) {
            if (response['create$capitalized'].containsKey('record')) {
              return fromJson(response['create$capitalized']['record']);
            }
          }
        },
      );
    },
  );
}
