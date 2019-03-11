import 'package:meta/meta.dart';
import '../models/base.model.dart';
import 'fastter_action.dart';
import 'fastter_queries.dart';
import 'fastter_middleware.dart';

class FastterListRedux<T extends BaseModel, S> {
  GraphQLQueries<T, S> queries;
  ListDataMiddleware<T, S> middleware;
  final String name;
  final String fragment;
  final T Function(Map<String, dynamic>) fromJson;
  final Map<String, dynamic> Function(T) toInput;
  final bool Function(T object, Map<String, dynamic> filter) filterObject;

  FastterListRedux({
    @required this.name,
    @required this.fragment,
    @required this.fromJson,
    @required this.toInput,
    @required this.filterObject,
  }) {
    queries = GraphQLQueries<T, S>(
      name: name,
      fragment: fragment,
      fromJson: fromJson,
      toInput: toInput,
    );
    middleware = ListDataMiddleware<T, S>(queries: queries);
  }

  ListState<T> Function(ListState<T> state, dynamic action) get reducer =>
      _createListDataRedux();

  ListState<T> Function(ListState<T> state, dynamic action)
      _createListDataRedux() {
    return (ListState<T> state, dynamic action) {
      if (action is StartSync<T>) {
        return ListState<T>(
          items: state.items
              .where((T obj) => filterObject(obj, action.filter))
              .toList(),
          fetching: true,
          adding: state.adding,
        );
      } else if (action is SyncCompletedAction<T>) {
        return ListState<T>(
          items: action.items,
          fetching: false,
        );
      } else if (action is AddItem<T>) {
        state.items.insert(0, action.item);
        return ListState<T>(
          items: state.items,
          fetching: state.fetching,
          adding: true,
        );
      } else if (action is AddCompletedAction<T>) {
        state.items.removeWhere((item) => item.id == null);
        if (state.items.where((item) => item.id == action.item.id).length ==
            0) {
          state.items.insert(0, action.item);
        } else {
          final itemindex =
              state.items.indexWhere((item) => item.id == action.item.id);
          state.items[itemindex] = action.item;
        }
        return ListState<T>(
          items: state.items,
          fetching: state.fetching,
          adding: false,
        );
      } else if (action is DeleteItem<T>) {
        return ListState<T>(
          items:
              state.items.where((T item) => item.id != action.itemid).toList(),
          fetching: state.fetching,
          adding: state.adding,
          deleting: true,
        );
      } else if (action is DeleteCompletedAction<T>) {
        return ListState<T>(
          items:
              state.items.where((T item) => item.id != action.itemid).toList(),
          fetching: state.fetching,
          adding: state.adding,
          deleting: false,
        );
      } else if (action is UpdateItem<T>) {
        return ListState<T>(
          fetching: state.fetching,
          updating: true,
          adding: state.adding,
          items: state.items
              .map<T>(
                (T item) => item.id == action.itemid ? action.item : item,
              )
              .toList(),
        );
      } else if (action is UpdateCompletedAction<T>) {
        return ListState<T>(
          fetching: state.fetching,
          updating: false,
          adding: state.adding,
          items: state.items
              .map<T>(
                (T item) => item.id == action.itemid ? action.item : item,
              )
              .toList(),
        );
      } else if (action is ClearAll<T>) {
        return ListState();
      }
      return state;
    };
  }
}
