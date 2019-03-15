import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../components/todocommentitem.dart';
import '../components/todocommentinput.dart';
import 'package:fastter_dart/fastter/fastter_action.dart';
import 'package:fastter_dart/models/base.model.dart';
import 'package:fastter_dart/models/todo.model.dart';
import 'package:fastter_dart/models/todocomment.model.dart';
import 'package:fastter_dart/store/state.dart';

class TodoCommentsScreen extends StatelessWidget {
  const TodoCommentsScreen({
    @required this.todo,
    Key key,
  }) : super(key: key);

  final Todo todo;

  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, Store<AppState>>(
        converter: (store) => store,
        builder: (context, store) => _TodoCommentsScreen(
              todo: todo,
              todoComments: ListState<TodoComment>(
                items: store.state.todoComments.items
                    .where((todocomment) =>
                        todocomment.todo != null &&
                        todocomment.todo.id == todo.id)
                    .toList(),
              ),
              syncStart: () => store.dispatch(StartSync<TodoComment>()),
              addComment: (TodoComment comment) =>
                  store.dispatch(AddItem<TodoComment>(comment)),
            ),
      );
}

class _TodoCommentsScreen extends StatefulWidget {
  const _TodoCommentsScreen({
    @required this.todo,
    @required this.todoComments,
    @required this.addComment,
    @required this.syncStart,
    Key key,
  }) : super(key: key);

  final Todo todo;
  final ListState<TodoComment> todoComments;
  final void Function(TodoComment) addComment;
  final VoidCallback syncStart;

  _TodoCommentsScreenState createState() => _TodoCommentsScreenState();
}

class _TodoCommentsScreenState extends State<_TodoCommentsScreen> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    widget.syncStart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.todo.title),
      ),
      body: Container(
        color: Theme.of(context).backgroundColor,
        child: Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            widget.todoComments.items.isEmpty
                ? Flexible(
                    child: Center(
                      child: Text("No Comments"),
                    ),
                  )
                : Flexible(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        children: widget.todoComments.items.reversed
                            .map(
                              (todoComment) => TodoCommentItem(
                                    todoComment: todoComment,
                                  ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
            TodoCommentInput(
                todo: widget.todo,
                onAdded: () {
                  scrollController
                      .jumpTo(scrollController.position.maxScrollExtent);
                }),
          ],
        ),
      ),
    );
  }
}
