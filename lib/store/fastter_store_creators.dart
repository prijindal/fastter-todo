import 'package:flutter/foundation.dart';
import '../models/base.model.dart';
import '../helpers/fastter.dart';

class SyncStartAction<T extends BaseModel> {}

class SyncCompletedAction<T extends BaseModel> {
  SyncCompletedAction(this.datas);
  final List<T> datas;
}

class AddAction<T extends BaseModel> {
  AddAction(this.data);
  final T data;
}

class DeleteAction<T extends BaseModel> {
  DeleteAction(this.dataid);
  final String dataid;
}

class UpdateAction<T extends BaseModel> {
  UpdateAction(this.dataid, this.data);
  final String dataid;
  final T data;
}

class ClearAction<T extends BaseModel> {}

ListState<T> Function(ListState<T> state, dynamic action)
    createListDataRedux<T extends BaseModel>() {
  return (ListState<T> state, dynamic action) {
    if (action is SyncStartAction<T>) {
      return ListState<T>(
        datas: state.datas,
        fetching: true,
      );
    } else if (action is SyncCompletedAction<T>) {
      return ListState<T>(
        datas: action.datas,
        fetching: false,
      );
    } else if (action is AddAction<T>) {
      state.datas.add(action.data);
      return ListState<T>(
        datas: state.datas,
        fetching: false,
      );
    } else if (action is DeleteAction<T>) {
      return ListState<T>(
        datas: state.datas.where((T data) => data.id != action.dataid).toList(),
        fetching: false,
      );
    } else if (action is UpdateAction<T>) {
      return ListState<T>(
          datas: state.datas
              .map<T>(
                (T data) => data.id == action.dataid ? action.data : data,
              )
              .toList());
    } else if (action is ClearAction<T>) {
      return ListState();
    }
    return state;
  };
}

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
