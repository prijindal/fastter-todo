import '../../models/base.model.dart';
import 'fastter_action.dart';

ListState<T> Function(ListState<T> state, dynamic action)
    createListDataRedux<T extends BaseModel>() {
  return (ListState<T> state, dynamic action) {
    if (action is StartSync<T>) {
      return ListState<T>(
        items: state.items,
        fetching: true,
      );
    } else if (action is SyncCompletedAction<T>) {
      return ListState<T>(
        items: action.items,
        fetching: false,
      );
    } else if (action is AddItem<T>) {
      state.items.add(action.item);
      return ListState<T>(
        items: state.items,
        fetching: true,
      );
    } else if (action is AddCompletedAction<T>) {
      if (state.items.singleWhere((item) => item.id != action.item.id) !=
          null) {
        state.items.add(action.item);
      } else {
        final itemindex =
            state.items.indexWhere((item) => item.id == action.item.id);
        state.items[itemindex] = action.item;
      }
      return ListState<T>(
        items: state.items,
        fetching: false,
      );
    } else if (action is DeleteItem<T>) {
      return ListState<T>(
        items: state.items.where((T item) => item.id != action.itemid).toList(),
        fetching: true,
      );
    } else if (action is DeleteCompletedAction<T>) {
      return ListState<T>(
        items: state.items.where((T item) => item.id != action.itemid).toList(),
        fetching: false,
      );
    } else if (action is UpdateItem<T>) {
      return ListState<T>(
        fetching: true,
        items: state.items
            .map<T>(
              (T item) => item.id == action.itemid ? action.item : item,
            )
            .toList(),
      );
    } else if (action is UpdateCompletedAction<T>) {
      return ListState<T>(
        fetching: false,
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
