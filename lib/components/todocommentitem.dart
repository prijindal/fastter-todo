import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../helpers/todouihelpers.dart';
import '../fastter/fastter_action.dart';
import '../models/todocomment.model.dart';
import '../store/state.dart';

class TodoCommentItem extends StatelessWidget {
  final TodoComment todoComment;

  TodoCommentItem({Key key, this.todoComment}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, Store<AppState>>(
        converter: (store) => store,
        builder: (context, store) => _TodoCommentItem(
              todoComment: todoComment,
              deleteComment: () =>
                  store.dispatch(DeleteItem<TodoComment>(todoComment.id)),
            ),
      );
}

class _TodoCommentItem extends StatelessWidget {
  const _TodoCommentItem({
    @required this.todoComment,
    @required this.deleteComment,
    Key key,
  }) : super(key: key);

  final TodoComment todoComment;
  final void Function() deleteComment;

  Future<bool> _confirmDelete(BuildContext context) => showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Are You sure?'),
              actions: <Widget>[
                FlatButton(
                  child: const Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                FlatButton(
                  child: const Text('Yes'),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            ),
      );

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(todoComment.id),
      confirmDismiss: (direction) => _confirmDelete(context),
      onDismissed: (direction) {
        deleteComment();
        Scaffold.of(context).removeCurrentSnackBar();
        Scaffold.of(context).showSnackBar(
            SnackBar(content: Text('${todoComment.content} deleted')));
      },
      background: Flex(
        direction: Axis.horizontal,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: const Icon(Icons.delete),
          ),
          Flexible(
            child: Container(),
          ),
        ],
      ),
      secondaryBackground: Flex(
        direction: Axis.horizontal,
        children: [
          Flexible(
            child: Container(),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: const Icon(Icons.delete),
          ),
        ],
      ),
      child: Card(
        child: ListTile(
          title: Text(todoComment.content),
          subtitle: Text(dateFromNowFormatter(todoComment.createdAt)),
        ),
      ),
    );
  }
}
