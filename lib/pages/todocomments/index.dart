import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:watch_it/watch_it.dart';

import '../../db/db_crud_operations.dart';
import '../../models/core.dart';
import '../../models/local_db_state.dart';
import 'todo_comment_input.dart';
import 'todo_comment_item.dart';

@RoutePage()
class TodoCommentsScreen extends WatchingWidget {
  const TodoCommentsScreen({
    super.key,
    @PathParam() required this.todoId,
  });

  final String todoId;

  @override
  Widget build(BuildContext context) {
    final comments = watchPropertyValue((LocalDbState state) =>
        state.comments.where((a) => a.todo == todoId).toList());
    final todo = watchPropertyValue(
        (LocalDbState state) => state.todos.firstWhere((f) => f.id == todoId));
    return _TodoCommentsScreen(
      todo: todo,
      todoComments: comments,
    );
  }
}

class _TodoCommentsScreen extends StatefulWidget {
  const _TodoCommentsScreen({
    required this.todo,
    required this.todoComments,
  });

  final TodoData todo;
  final List<CommentData> todoComments;

  @override
  _TodoCommentsScreenState createState() => _TodoCommentsScreenState();
}

class _TodoCommentsScreenState extends State<_TodoCommentsScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<String> _selectedComments = [];

  void _toggleSelected(CommentData todoComment) {
    setState(() {
      if (_selectedComments.contains(todoComment.id)) {
        _selectedComments.remove(todoComment.id);
      } else {
        _selectedComments.add(todoComment.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: TodoCommentsAppBar(
          selectedComments: _selectedComments,
          todo: widget.todo,
          todoComments: widget.todoComments,
          onClear: () {
            setState(_selectedComments.clear);
          },
        ),
        body: Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (widget.todoComments.isEmpty)
              const Flexible(
                child: Center(
                  child: Text('No Comments'),
                ),
              )
            else
              Flexible(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: widget.todoComments.reversed
                        .map(
                          (todoComment) => TodoCommentItem(
                            todoComment: todoComment,
                            onLongPress: () => _toggleSelected(todoComment),
                            onTap: _selectedComments.isEmpty
                                ? () {}
                                : () => _toggleSelected(todoComment),
                            selected:
                                _selectedComments.contains(todoComment.id),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            TodoCommentInput(
              todo: widget.todo,
              onAdded: () {
                _scrollController
                    .jumpTo(_scrollController.position.maxScrollExtent);
              },
            ),
          ],
        ),
      );
}

class TodoCommentsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const TodoCommentsAppBar({
    super.key,
    required this.onClear,
    required this.todo,
    this.selectedComments = const <String>[],
    required this.todoComments,
    this.preferredSize = const Size.fromHeight(kToolbarHeight),
  });

  final VoidCallback onClear;
  final TodoData todo;
  final List<String> selectedComments;
  final List<CommentData> todoComments;

  @override
  final Size preferredSize;

  String _commentsToString() {
    final strBuffer = StringBuffer('');
    for (final comment
        in todoComments.where((f) => selectedComments.contains(f.id))) {
      strBuffer.writeln(comment.content);
    }
    return strBuffer.toString();
  }

  void _shareSelectedComment() {
    SharePlus.instance.share(
      ShareParams(
        text: _commentsToString(),
      ),
    );
  }

  Future<void> _copySelectedComment(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: _commentsToString()));
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard'),
      ),
    );
  }

  Future<void> _deleteSelectedComment(BuildContext context) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure'),
        content: Text('This will delete ${selectedComments.length} comments'),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: const Text('Yes'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
    if (shouldDelete == true && context.mounted) {
      await GetIt.I<DbCrudOperations>().comment.delete(selectedComments);
    }
  }

  List<Widget> _buildActions(BuildContext context) {
    if (selectedComments.isEmpty) {
      return [];
    } else {
      return [
        IconButton(
          icon: const Icon(Icons.content_copy),
          onPressed: () => _copySelectedComment(context),
          tooltip: 'Copy',
        ),
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: _shareSelectedComment,
          tooltip: 'Share',
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => _deleteSelectedComment(context),
          tooltip: 'Delete',
        )
      ];
    }
  }

  @override
  Widget build(BuildContext context) => PopScope(
        canPop: selectedComments.isEmpty,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) {
            onClear();
          }
        },
        child: AppBar(
          title: Text(selectedComments.isEmpty
              ? todo.title
              : '${selectedComments.length} Comments selected'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: selectedComments.isEmpty
                ? () => {AutoRouter.of(context).maybePop()}
                : onClear,
            tooltip: 'Back',
          ),
          actions: _buildActions(context),
        ),
      );
}
