import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../models/base.model.dart';
import '../models/todo.model.dart';
import '../store/fastter/fastter_action.dart';
import '../store/state.dart';
import '../components/homeappbar.dart';
import '../components/todoinput.dart';
import '../components/homeappdrawer.dart';
import '../components/todoitem.dart';

class InboxScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Store<AppState>>(
      converter: (Store<AppState> store) => store,
      builder: (BuildContext context, Store<AppState> store) {
        return _InboxScreen(
          todos: store.state.todos,
          syncStart: () => store.dispatch(StartSync<Todo>()),
        );
      },
    );
  }
}

class _InboxScreen extends StatefulWidget {
  final ListState<Todo> todos;
  final VoidCallback syncStart;

  _InboxScreen({
    Key key,
    @required this.todos,
    @required this.syncStart,
  }) : super(key: key);

  __InboxScreenState createState() => __InboxScreenState();
}

class __InboxScreenState extends State<_InboxScreen> {
  @override
  void initState() {
    widget.syncStart();
    super.initState();
  }

  Widget buildBody() {
    if (widget.todos.fetching || widget.todos.items.isEmpty) {
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
          children: widget.todos.items
              .map(
                (todo) => TodoItem(
                      todo: todo,
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
