import 'package:meta/meta.dart';
import 'package:redux/redux.dart';
import '../../models/base.model.dart';

import './fastter_action.dart';
import './fastter_queries.dart';
import '../state.dart';

class ListDataMiddleware<T extends BaseModel>
    extends MiddlewareClass<AppState> {
  final GraphQLQueries queries;
  ListDataMiddleware({@required this.queries});

  @override
  void call(Store<AppState> store, action, NextDispatcher next) {
    if (action is StartSync<T>) {
      queries.syncQuery().then((items) {
        store.dispatch(SyncCompletedAction<T>(items));
      });
    } else if (action is AddItem<T>) {
      // add item query, then store.dispatch(AddCompletedAction(data));
    }
    next(action);
  }
}
