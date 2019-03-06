import 'package:meta/meta.dart';
import 'package:redux/redux.dart';
import '../models/base.model.dart';

import './fastter_action.dart';
import './fastter_queries.dart';

// T is the basemodel and s is the state
class ListDataMiddleware<T extends BaseModel, S> extends MiddlewareClass<S> {
  final GraphQLQueries queries;
  ListDataMiddleware({@required this.queries});

  @override
  void call(Store<S> store, action, NextDispatcher next) {
    if (action is StartSync<T>) {
      queries.syncQuery(action.filter).then((items) {
        store.dispatch(SyncCompletedAction<T>(items));
        action.completer.complete(items);
      });
    } else if (action is AddItem<T>) {
      queries.addMutation(action.item).then((item) {
        store.dispatch(AddCompletedAction<T>(item));
      });
    }
    next(action);
  }
}
