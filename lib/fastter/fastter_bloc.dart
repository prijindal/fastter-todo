import 'package:bloc/bloc.dart';
import '../fastter/fastter_queries.dart';
import '../models/base.model.dart';

import 'fastter_events.dart';

export 'fastter_events.dart';

class FastterBloc<T extends BaseModel>
    extends Bloc<FastterEvent<T>, ListState<T>> {
  FastterBloc({
    required this.name,
    required this.fragment,
    required this.fromJson,
    required this.toInput,
    required this.filterObject,
  })  : queries = GraphQLQueries<T>(
          name: name,
          fragment: fragment,
          fromJson: fromJson,
          toInput: toInput,
        ),
        super(ListState<T>()) {
    on((FastterEvent<T> event, emit) async {
      if (event is InitStateEvent<T>) {
        emit(event.initState);
      } else if (event is SetFetching<T>) {
        emit(state.copyWith(
          fetching: true,
        ));
      } else if (event is SyncEvent<T>) {
        emit(state.copyWith(
          fetching: true,
        ));
        final list = await queries.syncQuery();
        add(SyncEventCompleted<T>(list));
        event.completer.complete(list);
      } else if (event is SyncEventCompleted<T>) {
        emit(state.copyWith(
          items: event.items,
          fetching: false,
        ));
      } else if (event is AddEvent<T>) {
        final list = state.items..insert(0, event.item);
        emit(state.copyWith(
          items: list,
        ));
        final addedItem = await queries.addMutation(event.item);
        list.removeWhere((item) => item.id == null);
        if (list.where((item) => item.id == addedItem?.id).isEmpty) {
          list.insert(0, addedItem!);
        } else {
          final itemindex = list.indexWhere((item) => item.id == addedItem?.id);
          list[itemindex] = addedItem!;
        }
        emit(state.copyWith(
          items: list,
        ));
        event.completer.complete(addedItem);
      } else if (event is AddEventLocal<T>) {
        final list = state.items..insert(0, event.item);
        emit(state.copyWith(
          items: list,
        ));
      } else if (event is DeleteEvent<T>) {
        var list =
            state.items.where((item) => item.id != event.itemid).toList();
        emit(state.copyWith(
          items: list,
        ));
        final deletedItem = await queries.deleteMutation(event.itemid);
        list = list.where((item) => item.id != event.itemid).toList();
        emit(state.copyWith(
          items: list,
        ));
        event.completer.complete(deletedItem);
      } else if (event is DeleteEventLocal<T>) {
        final list =
            state.items.where((item) => item.id != event.itemid).toList();
        emit(state.copyWith(
          items: list,
        ));
      } else if (event is UpdateEvent<T>) {
        var list = state.items
            .map<T>(
              (item) => item.id == event.itemid ? event.item : item,
            )
            .toList();
        emit(state.copyWith(
          items: list,
        ));
        final updatedItem =
            await queries.updateMutation(event.itemid, event.item);
        list = list
            .map<T>(
              (item) => item.id == updatedItem?.id ? updatedItem! : item,
            )
            .toList();
        emit(state.copyWith(
          items: list,
        ));
        event.completer.complete(updatedItem);
      } else if (event is UpdateEventLocal<T>) {
        final list = state.items
            .map<T>(
              (item) => item.id == event.itemid ? event.item : item,
            )
            .toList();
        emit(state.copyWith(
          items: list,
        ));
      } else if (event is UpdateManyEvent<T>) {
        final list = state.items
            .map<T>(
              (item) =>
                  event.body.containsKey(item.id) ? event.body[item.id]! : item,
            )
            .toList();
        emit(state.copyWith(
          items: list,
        ));
        queries.updateManyMutation(event.body);
        emit(state.copyWith(
          items: list,
        ));
      } else if (event is SetSortByEvent<T>) {
        emit(state.copyWith(
          sortBy: event.sortBy,
        ));
      }
    });
  }

  final GraphQLQueries<T> queries;
  final String name;
  final String fragment;
  final T Function(Map<String, dynamic>) fromJson;
  final Map<String, dynamic> Function(T) toInput;
  final bool Function(T object, Map<String, dynamic> filter) filterObject;
}
