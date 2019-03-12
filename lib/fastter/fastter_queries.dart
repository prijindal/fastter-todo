import 'package:flutter/foundation.dart';
import 'package:redux/redux.dart';
import 'package:tuple/tuple.dart';
import 'package:event_bus/event_bus.dart';
import '../models/base.model.dart';
import './fastter.dart';

import 'fastter_action.dart';

class GraphQLQueries<T extends BaseModel, S> {
  GraphQLQueries({
    @required this.name,
    @required this.fragment,
    @required this.fromJson,
    @required this.toInput,
  });

  final String name;
  final String fragment;
  final T Function(Map<String, dynamic>) fromJson;
  final Map<String, dynamic> Function(T) toInput;

  String get capitalized => name.replaceRange(0, 1, name[0].toUpperCase());

  Future<List<T>> syncQuery([
    Map<String, dynamic> filter = const <String, dynamic>{},
    String extraFields = '',
  ]) =>
      Fastter.instance
          .request(
        Request(
          query: '''
            query(\$filter:FilterFindMany${capitalized}Input){
              ${name}s(filter:\$filter) {
                ...$name
                $extraFields
              }
            }
            $fragment
          ''',
          variables: <String, dynamic>{
            'filter': filter,
          },
        ),
      )
          .then((response) {
        if (response.containsKey('${name}s')) {
          return (response['${name}s'] as List<dynamic>)
              .map<T>((dynamic data) => fromJson(data))
              .toList();
        }
        return null;
      });

  Future<T> addMutation(dynamic object) => Fastter.instance
          .request(
        Request(
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
          variables: <String, dynamic>{
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

  Future<T> deleteMutation(String id) => Fastter.instance
          .request(
        Request(
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
          variables: <String, dynamic>{
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

  Future<T> updateMutation(String id, dynamic object) {
    final input = toInput(object);
    input['_id'] = id;
    return Fastter.instance
        .request(
      Request(
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
        variables: <String, dynamic>{
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
    await Fastter.instance.request(Request(
      query: '''subscription {
          ${name}sAdded { ...$name }
        }
        $fragment
        ''',
    ));
    await Fastter.instance.request(Request(
      query: '''subscription {
          ${name}sUpdated { ...$name }
        }
        $fragment
        ''',
    ));
    await Fastter.instance.request(Request(
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
