import 'package:uuid/uuid.dart';
import '../models/base.model.dart';
import '../models/lazyaction.model.dart';

Uuid _uuid = Uuid();

class AddLazyAction {
  AddLazyAction(this.action) : uuid = _uuid.v1();
  final BaseModel action;
  final String uuid;
}

class DeleteLazyAction {
  DeleteLazyAction(this.type, this.actionid) : uuid = _uuid.v1();
  final String actionid;
  final Type type;
  final String uuid;
}

class UpdateLazyAction {
  UpdateLazyAction(this.actionid, this.action) : uuid = _uuid.v1();
  final String actionid;
  final BaseModel action;
  final String uuid;
}

class RemoveLazyAction {
  RemoveLazyAction(this.uuid);
  final String uuid;
}

class InitLazyActions {}

List<LazyAction> lazyActionReducer(List<LazyAction> state, dynamic action) {
  if (action is AddLazyAction) {
    final list = List<LazyAction>.from(state);
    return list
      ..add(LazyAction(
        action.uuid,
        ActionType.add,
        action.action.runtimeType,
        action: action.action.toJson(),
      ));
  } else if (action is DeleteLazyAction) {
    final list = List<LazyAction>.from(state);
    return list
      ..add(LazyAction(
        action.uuid,
        ActionType.delete,
        action.type,
        actionid: action.actionid,
      ));
  } else if (action is UpdateLazyAction) {
    final list = List<LazyAction>.from(state);
    return list
      ..add(LazyAction(
        action.uuid,
        ActionType.update,
        action.action.runtimeType,
        action: action.action.toJson(),
        actionid: action.actionid,
      ));
  } else if (action is RemoveLazyAction) {
    final list = state;
    return list..removeWhere((lazyaction) => lazyaction.uuid == action.uuid);
  }
  return state;
}
