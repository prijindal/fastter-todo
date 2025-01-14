import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/date_fomatters.dart';
import '../../models/core.dart';
import '../../models/db_selector.dart';

class TodoCommentItem extends StatelessWidget {
  const TodoCommentItem({
    super.key,
    required this.todoComment,
    required this.onLongPress,
    required this.onTap,
    required this.selected,
  });

  final CommentData todoComment;
  final VoidCallback onLongPress;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) => _TodoCommentItem(
        todoComment: todoComment,
        deleteComment: () async {
          await Provider.of<DbSelector>(context, listen: false)
              .database
              .managers
              .comment
              .filter((f) => f.id.equals(todoComment.id))
              .delete();
        },
        onLongPress: onLongPress,
        onTap: onTap,
        selected: selected,
      );
}

class _TodoCommentItem extends StatelessWidget {
  const _TodoCommentItem({
    required this.todoComment,
    required this.deleteComment,
    required this.onLongPress,
    required this.onTap,
    required this.selected,
  });

  final CommentData todoComment;
  final Future<void> Function() deleteComment;
  final VoidCallback onLongPress;
  final VoidCallback onTap;
  final bool selected;

  Future<bool?> _confirmDelete(BuildContext context) => showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Are You sure?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
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
      final imageProvider = MemoryImage(todoComment.content);
      return Image(
        image: imageProvider,
      );
      // TODO: use some image viwer
      // return ImageViewer(
      //   imageProvider,
      // );
    } else if (todoComment.type == TodoCommentType.video) {
      // TODO: use video viewer
      return Text(String.fromCharCodes(todoComment.content));
    }
    // TODO: linkify text
    return Text(String.fromCharCodes(todoComment.content));
  }

  Future<void> _onDismissed(
      BuildContext context, DismissDirection direction) async {
    await deleteComment();
  }

  @override
  Widget build(BuildContext context) => Dismissible(
        key: Key(todoComment.id),
        confirmDismiss: (direction) => _confirmDelete(context),
        onDismissed: (direction) => _onDismissed(context, direction),
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
            onTap: onTap,
            selected: selected,
            title: _buildContent(context),
            subtitle: Text(dateFromNowFormatter(todoComment.creationTime)),
          ),
        ),
      );
}
