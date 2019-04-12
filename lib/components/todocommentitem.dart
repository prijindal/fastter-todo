import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

import 'package:fastter_dart/fastter/fastter_action.dart';
import 'package:fastter_dart/models/todocomment.model.dart';
import 'package:fastter_dart/store/state.dart';

import '../helpers/todouihelpers.dart';

class TodoCommentItem extends StatelessWidget {
  const TodoCommentItem({Key key, this.todoComment}) : super(key: key);

  final TodoComment todoComment;

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

  Widget _buildContent() {
    print(todoComment.type);
    if (todoComment.type == TodoCommentType.image) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.network(
            todoComment.content,
            height: 200,
          ),
        ],
      );
    } else if (todoComment.type == TodoCommentType.video) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Chewie(
            controller: ChewieController(
              videoPlayerController: VideoPlayerController.network(
                todoComment.content,
              ),
              aspectRatio: 3 / 2,
            ),
          ),
        ],
      );
    }
    return Text(todoComment.content);
  }

  @override
  Widget build(BuildContext context) => Dismissible(
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
            title: _buildContent(),
            subtitle: Text(dateFromNowFormatter(todoComment.createdAt)),
          ),
        ),
      );
}
