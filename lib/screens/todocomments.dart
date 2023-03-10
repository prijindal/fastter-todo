import 'dart:io';

import '../store/todocomments.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

import '../fastter/fastter_bloc.dart';
import '../models/base.model.dart';
import '../models/todo.model.dart';
import '../models/todocomment.model.dart';

import '../components/todocommentinput.dart';
import '../components/todocommentitem.dart';
import '../helpers/theme.dart';
import '../helpers/flutter_persistor.dart';

class TodoCommentsScreen extends StatelessWidget {
  const TodoCommentsScreen({
    required this.todo,
    super.key,
  });

  final Todo todo;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<FastterBloc<TodoComment>, ListState<TodoComment>>(
        bloc: fastterTodoComments,
        builder: (context, state) => _TodoCommentsScreen(
          todo: todo,
          todoComments: ListState<TodoComment>(
            items: state.items
                .where((todocomment) =>
                    todocomment.todo != null && todocomment.todo.id == todo.id)
                .toList(),
          ),
          syncStart: () => FlutterPersistor.getInstance().load(),
        ),
      );
}

class _TodoCommentsScreen extends StatefulWidget {
  const _TodoCommentsScreen({
    required this.todo,
    required this.todoComments,
    required this.syncStart,
  });

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
                  }),
            ],
          ),
        ),
      );
}

class TodoCommentsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const TodoCommentsAppBar({
    required this.onClear,
    required this.todo,
    this.selectedComments = const <String>[],
    super.key,
    this.preferredSize = const Size.fromHeight(kToolbarHeight),
  });

  final List<String> selectedComments;
  final VoidCallback onClear;
  final Todo todo;

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<FastterBloc<TodoComment>, ListState<TodoComment>>(
        bloc: fastterTodoComments,
        builder: (context, state) {
          final todoComments = state.items
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
                final action = DeleteEvent<TodoComment>(todoComment.id);
                fastterTodoComments.add(action);
                futures.add(action.completer.future);
              }
              return Future.wait<TodoComment>(futures);
            },
            addComments: (comments) {
              final futures = <Future<TodoComment>>[];
              for (final todoComment in comments) {
                final action = AddEvent<TodoComment>(todoComment);
                fastterTodoComments.add(action);
                futures.add(action.completer.future);
              }
              return Future.wait<TodoComment>(futures);
            },
          );
        },
      );
}

class _TodoCommentsAppBar extends StatelessWidget {
  const _TodoCommentsAppBar({
    required this.onClear,
    required this.todo,
    required this.todoComments,
    required this.deleteSelectedComment,
    required this.addComments,
  });

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
        content: Text('This will delete ${todoComments.items.length} comments'),
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
    if (shouldDelete == true) {
      final deletedComments = await this.deleteSelectedComment();
      onClear();
      ScaffoldMessenger.of(context).showSnackBar(
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

  Future<bool> _onWillPop() async {
    if (todoComments.items.isEmpty) {
      return true;
    }
    onClear();
    return false;
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: _onWillPop,
        child: AnimatedTheme(
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
                    tooltip: 'Back',
                  ),
            actions: _buildActions(context),
          ),
        ),
      );
}
