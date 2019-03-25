import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:share/share.dart';

import 'package:fastter_dart/fastter/fastter_action.dart';
import 'package:fastter_dart/models/base.model.dart';
import 'package:fastter_dart/models/label.model.dart';
import 'package:fastter_dart/models/project.model.dart';
import 'package:fastter_dart/models/settings.model.dart';
import 'package:fastter_dart/models/todo.model.dart';
import 'package:fastter_dart/store/selectedtodos.dart';
import 'package:fastter_dart/store/state.dart';
import 'package:fastter_dart/store/todos.dart';

import '../helpers/navigator.dart';
import '../helpers/theme.dart';
import '../screens/editlabel.dart';
import '../screens/editproject.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({
    @required this.filter,
    @required this.title,
    this.preferredSize = const Size.fromHeight(kToolbarHeight),
  });

  final Map<String, dynamic> filter;
  final String title;

  @override
  final Size preferredSize;
  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, Store<AppState>>(
        converter: (store) => store,
        builder: (context, store) => _HomeAppBar(
              selectedtodos: store.state.selectedTodos,
              filter: filter,
              title: title,
              unSelectAll: () {
                for (final todoid in store.state.selectedTodos) {
                  store.dispatch(UnSelectTodo(todoid));
                }
              },
              projects: store.state.projects,
              labels: store.state.labels,
              todos: store.state.todos,
              deleteSelected: () {
                for (final todoid in store.state.selectedTodos) {
                  store.dispatch(DeleteItem<Todo>(todoid));
                  store.dispatch(UnSelectTodo(todoid));
                }
              },
              deleteAll: () {
                for (final todo in store.state.todos.items
                    .where((todo) => fastterTodos.filterObject(todo, filter))) {
                  store.dispatch(DeleteItem<Todo>(todo.id));
                }
              },
              frontPage: store.state.user.user?.settings?.frontPage ??
                  FrontPage(
                    route: '/',
                    title: 'Inbox',
                  ),
            ),
      );
}

enum _PopupAction { delete, deleteall, editproject, editlabel, copy, share }

class _HomeAppBar extends StatelessWidget {
  const _HomeAppBar({
    @required this.selectedtodos,
    @required this.deleteSelected,
    @required this.unSelectAll,
    @required this.deleteAll,
    @required this.projects,
    @required this.labels,
    @required this.todos,
    @required this.filter,
    @required this.title,
    @required this.frontPage,
    Key key,
  }) : super(key: key);

  final Map<String, dynamic> filter;
  final List<String> selectedtodos;
  final VoidCallback deleteSelected;
  final VoidCallback deleteAll;
  final VoidCallback unSelectAll;
  final ListState<Project> projects;
  final ListState<Label> labels;
  final ListState<Todo> todos;
  final String title;
  final FrontPage frontPage;

  Project get _project => projects.items
      .singleWhere((item) => item.id == filter['project'], orElse: () => null);

  Label get _label => labels.items
      .singleWhere((item) => item.id == filter['label'], orElse: () => null);

  Widget _buildTitle() {
    if (this.title != null) {
      return Text(this.title);
    }
    if (selectedtodos.isNotEmpty) {
      return Text('${selectedtodos.length.toString()} '
          'Todo${selectedtodos.length > 1 ? 's' : ''} selected');
    }
    String routeName;
    if (history.isNotEmpty) {
      routeName = history.last.routeName;
    } else {
      routeName = frontPage.route;
    }
    String title;
    switch (routeName) {
      case '/':
        title = 'Inbox';
        break;
      case '/all':
        title = 'All Todos';
        break;
      case '/today':
        title = 'Today';
        break;
      case '/7days':
        title = '7 Days';
        break;
      case '/todos':
        if (_project != null) {
          title = _project.title;
        } else {
          final map = history.last.arguments as Map;
          if (map.containsKey('project')) {
            title = (map['project'] as Project).title;
          }
        }
        break;
      default:
        title = 'Todo App';
    }
    return Text(title);
  }

  void _deleteSelected(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text('Are you sure'),
            content: Text('This will delete ${selectedtodos.length} tasks'),
            actions: <Widget>[
              FlatButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              FlatButton(
                child: const Text('Yes'),
                onPressed: () {
                  Navigator.of(context).pop();
                  deleteSelected();
                },
              ),
            ],
          ),
    );
  }

  String _tasksToString() {
    final strBuffer = StringBuffer('');
    for (final todo
        in todos.items.where((todo) => selectedtodos.contains(todo.id))) {
      strBuffer.writeln(todo.title);
    }
    return strBuffer.toString();
  }

  Future<void> _copySelected(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: _tasksToString()));
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: const Text('Copied to clipboard'),
      ),
    );
  }

  void _shareSelected(BuildContext context) {
    Share.share(_tasksToString());
  }

  void _deleteAll(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text('Are you sure'),
            content: const Text('This will delete all tasks'),
            actions: <Widget>[
              FlatButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              FlatButton(
                child: const Text('Yes'),
                onPressed: () {
                  Navigator.of(context).pop();
                  deleteAll();
                },
              ),
            ],
          ),
    );
  }

  void _editLabel(BuildContext context) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (context) => EditLabelScreen(
              label: _label,
            ),
      ),
    );
  }

  void _editProject(BuildContext context) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (context) => EditProjectScreen(
              project: _project,
            ),
      ),
    );
  }

  Widget _buildPopupAction(BuildContext context) =>
      PopupMenuButton<_PopupAction>(
        onSelected: (value) {
          if (selectedtodos.isNotEmpty) {
            if (value == _PopupAction.delete) {
              _deleteSelected(context);
            } else if (value == _PopupAction.copy) {
              _copySelected(context);
            } else if (value == _PopupAction.share) {
              _shareSelected(context);
            }
          } else {
            if (value == _PopupAction.deleteall) {
              _deleteAll(context);
            } else if (value == _PopupAction.editproject) {
              _editProject(context);
            } else if (value == _PopupAction.editlabel) {
              _editLabel(context);
            }
          }
        },
        icon: const Icon(Icons.more_vert),
        itemBuilder: (context) {
          if (selectedtodos.isNotEmpty) {
            return [
              PopupMenuItem<_PopupAction>(
                child: const Text('Copy'),
                value: _PopupAction.copy,
              ),
              PopupMenuItem<_PopupAction>(
                child: const Text('Share'),
                value: _PopupAction.share,
              ),
              PopupMenuItem<_PopupAction>(
                child: const Text('Delete'),
                value: _PopupAction.delete,
              )
            ];
          } else {
            final items = <PopupMenuItem<_PopupAction>>[];
            if (_project != null) {
              items.add(PopupMenuItem<_PopupAction>(
                child: const Text('Edit Project'),
                value: _PopupAction.editproject,
              ));
            }
            if (_label != null) {
              items.add(PopupMenuItem<_PopupAction>(
                child: const Text('Edit Label'),
                value: _PopupAction.editlabel,
              ));
            }
            items.add(PopupMenuItem<_PopupAction>(
              child: const Text('Delete All'),
              value: _PopupAction.deleteall,
            ));
            return items;
          }
        },
      );

  @override
  Widget build(BuildContext context) => AnimatedTheme(
        data: selectedtodos.isNotEmpty ? whiteTheme : primaryTheme,
        child: AppBar(
          leading: selectedtodos.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: unSelectAll,
                )
              : IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    homeScaffoldKey.currentState.openDrawer();
                  },
                ),
          title: _buildTitle(),
          actions: [
            _buildPopupAction(context),
          ],
        ),
      );
}
