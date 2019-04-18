import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:share/share.dart';

import 'package:fastter_dart/fastter/fastter_action.dart';
import 'package:fastter_dart/models/base.model.dart';
import 'package:fastter_dart/models/todo.model.dart';
import 'package:fastter_dart/models/todocomment.model.dart';
import 'package:fastter_dart/store/state.dart';

import '../components/todocommentinput.dart';
import '../components/todocommentitem.dart';
import '../helpers/theme.dart';

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
            ),
      );
}

class _TodoCommentsScreen extends StatefulWidget {
  const _TodoCommentsScreen({
    @required this.todo,
    @required this.todoComments,
    @required this.syncStart,
    Key key,
  }) : super(key: key);

  final Todo todo;
  final ListState<TodoComment> todoComments;
  final VoidCallback syncStart;

  @override
  _TodoCommentsScreenState createState() => _TodoCommentsScreenState();
}

class _TodoCommentsScreenState extends State<_TodoCommentsScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<String> _selectedComments = [];

  @override
  void initState() {
    widget.syncStart();
    super.initState();
  }

  void _toggleSelected(TodoComment todoComment) {
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
          onClear: () {
            setState(_selectedComments.clear);
          },
        ),
        body: Container(
          color: Theme.of(context).backgroundColor,
          child: Flex(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (widget.todoComments.items.isEmpty)
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
                      children: widget.todoComments.items.reversed
                          .map(
                            (todoComment) => TodoCommentItem(
                                  todoComment: todoComment,
                                  onLongPress: () =>
                                      _toggleSelected(todoComment),
                                  onTap: _selectedComments.isEmpty
                                      ? null
                                      : () => _toggleSelected(todoComment),
                                  selected: _selectedComments
                                      .contains(todoComment.id),
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
                  }),
            ],
          ),
        ),
      );
}

class TodoCommentsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  TodoCommentsAppBar({
    @required this.onClear,
    @required this.todo,
    this.selectedComments = const <String>[],
    Key key,
    this.preferredSize = const Size.fromHeight(kToolbarHeight),
  }) : super(key: key);

  final List<String> selectedComments;
  final VoidCallback onClear;
  final Todo todo;

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, Store<AppState>>(
        converter: (store) => store,
        builder: (context, store) {
          final todoComments = store.state.todoComments.items
              .where((todocomment) =>
                  todocomment.todo != null &&
                  todocomment.todo.id == todo.id &&
                  selectedComments.contains(todocomment.id))
              .toList();
          return _TodoCommentsAppBar(
            onClear: onClear,
            todo: todo,
            todoComments: ListState<TodoComment>(
              items: todoComments,
            ),
            deleteSelectedComment: () {
              final futures = <Future<TodoComment>>[];
              for (final todoComment in todoComments) {
                final action = DeleteItem<TodoComment>(todoComment.id);
                store.dispatch(action);
                futures.add(action.completer.future);
              }
              return Future.wait<TodoComment>(futures);
            },
            addComments: (comments) {
              final futures = <Future<TodoComment>>[];
              for (final todoComment in comments) {
                final action = AddItem<TodoComment>(todoComment);
                store.dispatch(action);
                futures.add(action.completer.future);
              }
              return Future.wait<TodoComment>(futures);
            },
          );
        },
      );
}

class _TodoCommentsAppBar extends StatelessWidget {
  _TodoCommentsAppBar({
    @required this.onClear,
    @required this.todo,
    @required this.todoComments,
    @required this.deleteSelectedComment,
    @required this.addComments,
    Key key,
  }) : super(key: key);

  final VoidCallback onClear;
  final Todo todo;
  final ListState<TodoComment> todoComments;
  final Future<List<TodoComment>> Function() deleteSelectedComment;
  final Future<List<TodoComment>> Function(List<TodoComment>) addComments;

  String _commentsToString() {
    final strBuffer = StringBuffer('');
    for (final comment in todoComments.items) {
      strBuffer.writeln(comment.content);
    }
    return strBuffer.toString();
  }

  void _shareSelectedComment() {
    Share.share(_commentsToString());
  }

  Future<void> _copySelectedComment(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: _commentsToString()));
    Scaffold.of(context).showSnackBar(
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
            content:
                Text('This will delete ${todoComments.items.length} comments'),
            actions: <Widget>[
              FlatButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              FlatButton(
                child: const Text('Yes'),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          ),
    );
    if (shouldDelete == true) {
      final deletedComments = await this.deleteSelectedComment();
      onClear();
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('${deletedComments.length} Comments Deleted'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () => addComments(deletedComments
                .map((comment) => TodoComment(
                      type: comment.type,
                      content: comment.content,
                      todo: comment.todo,
                    ))
                .toList()),
          ),
        ),
      );
    }
  }

  List<Widget> _buildActions(BuildContext context) {
    if (todoComments.items.isEmpty) {
      return [];
    } else {
      return [
        IconButton(
          icon: const Icon(Icons.content_copy),
          onPressed: () => _copySelectedComment(context),
        ),
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: _shareSelectedComment,
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => _deleteSelectedComment(context),
        )
      ];
    }
  }

  @override
  Widget build(BuildContext context) => AnimatedTheme(
        data: todoComments.items.isEmpty ? primaryTheme : whiteTheme,
        child: AppBar(
          title: Text(todoComments.items.isEmpty
              ? todo.title
              : '${todoComments.items.length} Comments selected'),
          leading: todoComments.items.isEmpty
              ? null
              : IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: onClear,
                ),
          actions: _buildActions(context),
        ),
      );
}
