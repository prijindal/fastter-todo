import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../models/base.model.dart';
import '../models/todo.model.dart';
import '../store/fastter_store_creators.dart';
import '../store/store.dart';
import '../store/todos.dart';
import '../components/homeappbar.dart';
import '../components/todoinput.dart';
import '../components/homeappdrawer.dart';

class InboxScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Store<AppState>>(
      converter: (Store<AppState> store) => store,
      builder: (BuildContext context, Store<AppState> store) {
        return _InboxScreen(
          todos: store.state.todos,
          syncStart: () => store.dispatch(SyncStartAction<Todo>()),
          syncCompleted: (List<Todo> datas) =>
              store.dispatch(SyncCompletedAction<Todo>(datas)),
        );
      },
    );
  }
}

class _InboxScreen extends StatefulWidget {
  final ListState<Todo> todos;
  final VoidCallback syncStart;
  final void Function(List<Todo> datas) syncCompleted;

  _InboxScreen({
    Key key,
    @required this.todos,
    @required this.syncCompleted,
    @required this.syncStart,
  }) : super(key: key);

  __InboxScreenState createState() => __InboxScreenState();
}

class __InboxScreenState extends State<_InboxScreen> {
  @override
  void initState() {
    widget.syncStart();
    super.initState();
    todosQueries.syncQuery().then((response) {
      widget.syncCompleted(response);
    });
  }

  Widget buildBody() {
    if (widget.todos.fetching) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Flex(
      direction: Axis.vertical,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        ListView(
          shrinkWrap: true,
          children: widget.todos.datas
              .map(
                (todo) => ListTile(
                      key: new Key(todo.id),
                      title: Text(todo.title),
                    ),
              )
              .toList(),
        ),
        TodoInput(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(),
      drawer: HomeAppDrawer(),
      body: Container(
        child: buildBody(),
      ),
    );
  }
}
