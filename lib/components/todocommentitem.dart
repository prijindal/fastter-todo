import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:fastter_dart/fastter/fastter_action.dart';
import 'package:fastter_dart/models/todocomment.model.dart';
import 'package:fastter_dart/store/state.dart';

import '../helpers/todouihelpers.dart';

class TodoCommentItem extends StatelessWidget {
  const TodoCommentItem({
    Key key,
    this.todoComment,
    this.onLongPress,
    this.selected,
  }) : super(key: key);

  final TodoComment todoComment;
  final VoidCallback onLongPress;
  final bool selected;

  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, Store<AppState>>(
        converter: (store) => store,
        builder: (context, store) => _TodoCommentItem(
              todoComment: todoComment,
              deleteComment: () =>
                  store.dispatch(DeleteItem<TodoComment>(todoComment.id)),
              onLongPress: onLongPress,
              selected: selected,
            ),
      );
}

class _TodoCommentItem extends StatelessWidget {
  const _TodoCommentItem({
    @required this.todoComment,
    @required this.deleteComment,
    this.onLongPress,
    this.selected,
    Key key,
  }) : super(key: key);

  final TodoComment todoComment;
  final void Function() deleteComment;
  final VoidCallback onLongPress;
  final bool selected;

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

  Widget _buildContent(BuildContext context) {
    if (todoComment.type == TodoCommentType.image) {
      final imageProvider = NetworkImage(todoComment.content);
      return GestureDetector(
        child: Image(
          image: imageProvider,
          height: 200,
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (BuildContext context) => Scaffold(
                    body: PhotoView(
                      imageProvider: imageProvider,
                    ),
                  ),
            ),
          );
        },
      );
    } else if (todoComment.type == TodoCommentType.video) {
      return Chewie(
        controller: ChewieController(
          videoPlayerController: VideoPlayerController.network(
            todoComment.content,
          ),
          allowFullScreen: true,
          autoInitialize: true,
          looping: true,
        ),
      );
    }
    return Linkify(
      onOpen: (link) => launch(link.url),
      text: todoComment.content,
    );
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
            onLongPress: onLongPress,
            selected: selected,
            title: _buildContent(context),
            subtitle: Text(dateFromNowFormatter(todoComment.createdAt)),
          ),
        ),
      );
}
