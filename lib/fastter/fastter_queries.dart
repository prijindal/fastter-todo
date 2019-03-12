import 'package:flutter/foundation.dart';
import 'package:redux/redux.dart';
import 'package:tuple/tuple.dart';
import 'package:event_bus/event_bus.dart';
import '../models/base.model.dart';
import './fastter.dart';

import 'fastter_action.dart';

class GraphQLQueries<T extends BaseModel, S> {
  final String name;
  final String fragment;
  final T Function(Map<String, dynamic>) fromJson;
  final Map<String, dynamic> Function(T) toInput;

  GraphQLQueries({
    @required this.name,
    @required this.fragment,
    @required this.fromJson,
    @required this.toInput,
  });

  Future<List<T>> syncQuery([
    Map<String, dynamic> filter = const <String, dynamic>{},
    String extraFields = "",
  ]) {
    String capitalized = name.replaceRange(0, 1, name[0].toUpperCase());
    return Fastter.instance
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
  }

  Future<T> addMutation(dynamic object) {
    String capitalized = name.replaceRange(0, 1, name[0].toUpperCase());
    return Fastter.instance
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
          'object': toInput(object),
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
        return null;
      },
    );
  }

  Future<T> deleteMutation(String id) {
    String capitalized = name.replaceRange(0, 1, name[0].toUpperCase());
    return Fastter.instance
        .request(
      new Request(
        query: '''
          mutation(\$_id:MongoID!){
            delete$capitalized(_id: \$_id) {
              record {
                ...$name
              }
            }
          }
          $fragment
        ''',
        variables: {
          '_id': id,
        },
      ),
    )
        .then((response) {
      if (response.containsKey('delete$capitalized')) {
        if (response['delete$capitalized'].containsKey('record')) {
          return fromJson(response['delete$capitalized']['record']);
        }
      }
      return null;
    });
  }

  Future<T> updateMutation(String id, dynamic object) {
    String capitalized = name.replaceRange(0, 1, name[0].toUpperCase());
    Map<String, dynamic> input = toInput(object);
    input['_id'] = id;
    return Fastter.instance
        .request(
      new Request(
        query: '''
          mutation(\$object:UpdateById${capitalized}Input!){
            update$capitalized(record: \$object) {
                record {
                  ...$name
                }
              }
            }
            $fragment
          ''',
        variables: {
          'object': input,
        },
      ),
    )
        .then((response) {
      if (response.containsKey('update$capitalized')) {
        if (response['update$capitalized'].containsKey('record')) {
          return fromJson(response['update$capitalized']['record']);
        }
      }
      return null;
    });
  }

  Future<Tuple3<EventBus, EventBus, EventBus>> initSubscriptions(
      Store<S> store) async {
    await Fastter.instance.request(new Request(
      query: '''subscription {
          ${name}sAdded { ...$name }
        }
        $fragment
        ''',
    ));
    await Fastter.instance.request(new Request(
      query: '''subscription {
          ${name}sUpdated { ...$name }
        }
        $fragment
        ''',
    ));
    await Fastter.instance.request(new Request(
      query: '''subscription {
          ${name}sDeleted { ...$name }
        }
        $fragment
        ''',
    ));
    final addEvent = Fastter.instance.addSubscription('${name}sAdded');
    final updateEvent = Fastter.instance.addSubscription('${name}sUpdated');
    final deleteEvent = Fastter.instance.addSubscription('${name}sDeleted');
    addEvent.on<Map<String, dynamic>>().listen((data) {
      store.dispatch(AddCompletedAction<T>(fromJson(data)));
    });
    updateEvent.on<Map<String, dynamic>>().listen((data) {
      final item = fromJson(data);
      store.dispatch(UpdateCompletedAction<T>(item.id, item));
    });
    deleteEvent.on<Map<String, dynamic>>().listen((data) {
      final item = fromJson(data);
      store.dispatch(DeleteCompletedAction<T>(item.id));
    });
    return Tuple3<EventBus, EventBus, EventBus>(
      addEvent,
      updateEvent,
      deleteEvent,
    );
  }
}
