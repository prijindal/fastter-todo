import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../screens/loading.dart';
import '../models/base.model.dart';
import '../models/todo.model.dart';
import '../models/user.model.dart';
import '../store/fastter_store_creators.dart';
import '../store/store.dart';
import '../store/todos.dart';
import '../store/currentuser.dart';
import '../helpers/fastter.dart' show fastter, Request;

class HomeContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Store<AppState>>(
      converter: (Store<AppState> store) => store,
      builder: (BuildContext context, Store<AppState> store) {
        return _HomeContainer(
            user: store.state.user,
            onLogout: () => store.dispatch(LogoutUserAction()),
            todos: store.state.todos,
            todoSyncCompleted: (List<Todo> datas) =>
                store.dispatch(SyncCompletedAction<Todo>(datas)));
      },
    );
  }
}

class _HomeContainer extends StatefulWidget {
  _HomeContainer({
    @required this.user,
    @required this.onLogout,
    @required this.todos,
    @required this.todoSyncCompleted,
  });
  final User user;
  final void Function() onLogout;
  final ListState<Todo> todos;
  final void Function(List<Todo> datas) todoSyncCompleted;

  _HomeContainerState createState() => _HomeContainerState();
}

class _HomeContainerState extends State<_HomeContainer> {
  @override
  void initState() {
    super.initState();
    todosQueries.syncQuery().then((response) {
      widget.todoSyncCompleted(response);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text("Todo App"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: widget.onLogout,
          )
        ],
      ),
      body: Container(
          child: ListView(
        children: widget.todos.datas
            .map(
              (todo) => ListTile(
                    key: new Key(todo.id),
                    title: Text(todo.title),
                  ),
            )
            .toList(),
      )),
    );
  }
}
