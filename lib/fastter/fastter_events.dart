import 'dart:async';
import '../models/base.model.dart';

abstract class FastterEvent<T extends BaseModel> {}

class InitStateEvent<T extends BaseModel> extends FastterEvent<T> {
  InitStateEvent(this.initState);

  final ListState<T> initState;
}

// class SetFetching<T extends BaseModel> extends FastterEvent<T> {}

// class SyncEvent<T extends BaseModel> extends FastterEvent<T> {
//   SyncEvent([this.filter = const <String, dynamic>{}])
//       : completer = Completer<List<T>>();
//   final Completer<List<T>> completer;

//   Map<String, dynamic> filter;
// }

// class SyncEventCompleted<T extends BaseModel> extends FastterEvent<T> {
//   SyncEventCompleted(this.items);

//   final List<T> items;
// }

class AddEvent<T extends BaseModel> extends FastterEvent<T> {
  AddEvent(this.item) : completer = Completer<T>();
  final T item;
  final Completer<T> completer;
}

// class AddEventLocal<T extends BaseModel> extends FastterEvent<T> {
//   AddEventLocal(this.item);
//   final T item;
// }

class DeleteEvent<T extends BaseModel> extends FastterEvent<T> {
  DeleteEvent(this.itemid) : completer = Completer<T>();
  final String itemid;
  final Completer<T> completer;
}

// class DeleteEventLocal<T extends BaseModel> extends FastterEvent<T> {
//   DeleteEventLocal(this.itemid);
//   final String itemid;
// }

class UpdateEvent<T extends BaseModel> extends FastterEvent<T> {
  UpdateEvent(this.itemid, this.item) : completer = Completer<T>();
  final String itemid;
  final T item;
  final Completer<T> completer;
}

// class UpdateEventLocal<T extends BaseModel> extends FastterEvent<T> {
//   UpdateEventLocal(this.itemid, this.item);
//   final String itemid;
//   final T item;
// }

class UpdateManyEvent<T extends BaseModel> extends FastterEvent<T> {
  UpdateManyEvent(this.body);
  final Map<String, T> body;
}

class SetSortByEvent<T extends BaseModel> extends FastterEvent<T> {
  SetSortByEvent(this.sortBy);

  final String sortBy;
}
