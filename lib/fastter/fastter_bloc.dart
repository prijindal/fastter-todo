import 'package:bloc/bloc.dart';
import 'package:uuid/uuid.dart';
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
  }) : super(ListState<T>()) {
    on((FastterEvent<T> event, emit) async {
      if (event is InitStateEvent<T>) {
        emit(event.initState);
      } else if (event is AddEvent<T>) {
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
      } else if (event is UpdateEvent<T>) {
        var list = state.items
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
      } else if (event is SetSortByEvent<T>) {
        emit(state.copyWith(
          sortBy: event.sortBy,
        ));
      }
    });
  }

  final String name;
  final String fragment;
  final T Function(Map<String, dynamic>) fromJson;
  final Map<String, dynamic> Function(T) toInput;
  final bool Function(T object, Map<String, dynamic> filter) filterObject;
}
