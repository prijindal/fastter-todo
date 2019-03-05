import '../models/base.model.dart';

class Action<T extends BaseModel> {}

// To be checked by thunk
class StartSync<T extends BaseModel> extends Action<T> {}

class AddItem<T extends BaseModel> extends Action<T> {
  AddItem(this.item);
  final T item;
}

class SyncCompletedAction<T extends BaseModel> extends Action<T> {
  SyncCompletedAction(this.items);
  final List<T> items;
}

// To be checked by just the reducer
class AddCompletedAction<T extends BaseModel> extends Action<T> {
  AddCompletedAction(this.item);
  final T item;
}

class DeleteCompletedAction<T extends BaseModel> extends Action<T> {
  DeleteCompletedAction(this.itemid);
  final String itemid;
}

class UpdateCompletedAction<T extends BaseModel> extends Action<T> {
  UpdateCompletedAction(this.itemid, this.item);
  final String itemid;
  final T item;
}

class ClearAll<T extends BaseModel> extends Action<T> {}
