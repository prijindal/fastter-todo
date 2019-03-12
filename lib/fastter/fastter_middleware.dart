import 'package:meta/meta.dart';
import 'package:redux/redux.dart';
import '../models/base.model.dart';

import './fastter_action.dart';
import './fastter_queries.dart';

// T is the basemodel and s is the state
class ListDataMiddleware<T extends BaseModel, S> extends MiddlewareClass<S> {
  ListDataMiddleware({@required this.queries});

  final GraphQLQueries<T, S> queries;

  @override
  void call(Store<S> store, dynamic action, NextDispatcher next) {
    if (action is StartSync<T>) {
      queries.syncQuery(action.filter).then((items) {
        store.dispatch(SyncCompletedAction<T>(items));
        action.completer.complete(items);
      });
    } else if (action is AddItem<T>) {
      queries.addMutation(action.item).then((item) {
        store.dispatch(AddCompletedAction<T>(item));
      });
    } else if (action is DeleteItem<T>) {
      queries.deleteMutation(action.itemid).then((item) {
        store.dispatch(DeleteCompletedAction<T>(item.id));
      });
    } else if (action is UpdateItem<T>) {
      queries.updateMutation(action.itemid, action.item).then((item) {
        store.dispatch(UpdateCompletedAction<T>(item.id, item));
      });
    }
    next(action);
  }
}
