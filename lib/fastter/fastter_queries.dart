import 'package:drift/drift.dart';
import 'package:meta/meta.dart';
import 'package:tuple/tuple.dart';
import 'package:event_bus/event_bus.dart';
import './fastter.dart';
import '../fastter/fastter_events.dart';
import '../models/base.model.dart';
import '../tables/tables.dart';

class GraphQLQueries<T extends BaseModel> {
  GraphQLQueries({
    required this.name,
    required this.fragment,
    required this.fromJson,
    required this.toInput,
    // required this.table,
  });

  final String name;
  // final ResultSetImplementation<TableInfo<T, DataClass>, T> table;
  final String fragment;
  final T Function(Map<String, dynamic>) fromJson;
  final Map<String, dynamic> Function(T) toInput;

  String get capitalized => name.replaceRange(0, 1, name[0].toUpperCase());

  T _fromJson(dynamic d) => fromJson(d);

  // Future<List<T>> syncQuery([
  //   Map<String, dynamic> filter = const <String, dynamic>{},
  //   String extraFields = '',
  // ]) {
  //   return MyDatabase.instance.select(table).get();
  // }

  Future<List<T>> syncQuery([
    Map<String, dynamic> filter = const <String, dynamic>{},
    String extraFields = '',
  ]) =>
      Fastter.instance
          .request(
        SingleRequest(
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
          final List<dynamic> list = response['${name}s'];
          return list.map<T>(_fromJson).toList();
        }
        return [];
      });

  Future<T?> addMutation(dynamic object) => Fastter.instance
          .request(
        SingleRequest(
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

  Future<T?> deleteMutation(String id) => Fastter.instance
          .request(
        SingleRequest(
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

  String get updateQuery => '''
          mutation(\$object:UpdateById${capitalized}Input!){
            update$capitalized(record: \$object) {
                record {
                  ...$name
                }
              }
            }
            $fragment
          ''';

  Future<T?> updateMutation(String id, dynamic object) {
    final input = toInput(object);
    input['_id'] = id;
    return Fastter.instance
        .request(
      SingleRequest(
        query: updateQuery,
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

  void updateManyMutation(Map<String, T> body) {
    final queries = body.keys
        .map<dynamic>((id) {
          final dynamic input = toInput(body[id]!);
          input['_id'] = id;
          return input;
        })
        .map((dynamic input) => Request(
              query: updateQuery,
              variables: <String, dynamic>{'object': input},
            ))
        .toList();
    Fastter.instance.multipleRequest(MultipleRequest(
      queries: queries,
    ));
  }

  Tuple3<EventBus, EventBus, EventBus>? initSubscriptions(
      void Function(FastterEvent<T> event) dispatch) {
    if (Fastter.getInstance().socket == null) {
      return null;
    }
    Fastter.instance.multipleRequest(MultipleRequest(
      queries: [
        Request(
          query: '''subscription {
            ${name}sAdded { ...$name }
          }
          $fragment
          ''',
        ),
        Request(
          query: '''subscription {
            ${name}sUpdated { ...$name }
          }
          $fragment
          ''',
        ),
        Request(
          query: '''subscription {
            ${name}sDeleted { ...$name }
          }
          $fragment
          ''',
        )
      ],
    ));
    final addEvent = Fastter.instance.addSubscription('${name}sAdded');
    final updateEvent = Fastter.instance.addSubscription('${name}sUpdated');
    final deleteEvent = Fastter.instance.addSubscription('${name}sDeleted');
    addEvent.on<Map<String, dynamic>>().listen((data) {
      dispatch(AddEventLocal<T>(fromJson(data)));
    });
    updateEvent.on<Map<String, dynamic>>().listen((data) {
      final item = fromJson(data);
      dispatch(UpdateEventLocal<T>(item.id, item));
    });
    deleteEvent.on<Map<String, dynamic>>().listen((data) {
      final item = fromJson(data);
      dispatch(DeleteEventLocal<T>(item.id));
    });
    return Tuple3<EventBus, EventBus, EventBus>(
      addEvent,
      updateEvent,
      deleteEvent,
    );
  }
}
