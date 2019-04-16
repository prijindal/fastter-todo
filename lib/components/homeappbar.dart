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
import '../helpers/responsive.dart';
import '../helpers/theme.dart';
import '../screens/editlabel.dart';
import '../screens/editproject.dart';
import '../screens/search.dart';

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
              updateSortBy: (String sortBy) =>
                  store.dispatch(SetSortBy<Todo>(sortBy)),
            ),
      );
}

enum _PopupAction { delete, deleteall, editproject, editlabel, copy, share }

enum _SortAction { duedate, title, priority }

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
    @required this.updateSortBy,
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
  final void Function(String) updateSortBy;
  final FrontPage frontPage;

  Project get _project => projects.items
      .singleWhere((item) => item.id == filter['project'], orElse: () => null);

  Label get _label => labels.items
      .singleWhere((item) => item.id == filter['label'], orElse: () => null);

  Widget _buildTitle() {
    if (selectedtodos.isNotEmpty) {
      return Text('${selectedtodos.length.toString()} '
          'Todo${selectedtodos.length > 1 ? 's' : ''} selected');
    }
    if (this.title != null) {
      return Text(this.title);
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
      const SnackBar(
        content: Text('Copied to clipboard'),
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

  Widget _buildSortAction(BuildContext context) => PopupMenuButton<_SortAction>(
        onSelected: (_SortAction action) {
          if (action == _SortAction.duedate) {
            updateSortBy('dueDate');
          } else if (action == _SortAction.priority) {
            updateSortBy('priority');
          } else if (action == _SortAction.title) {
            updateSortBy('title');
          }
        },
        icon: const Icon(Icons.sort),
        itemBuilder: (context) => const [
              PopupMenuItem(
                enabled: false,
                child: Text('Sort By'),
              ),
              PopupMenuDivider(),
              PopupMenuItem<_SortAction>(
                value: _SortAction.duedate,
                child: Text('Due Date'),
              ),
              PopupMenuItem<_SortAction>(
                value: _SortAction.priority,
                child: Text('Priority'),
              ),
              PopupMenuItem<_SortAction>(
                value: _SortAction.title,
                child: Text('Title'),
              )
            ],
      );

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
              const PopupMenuItem<_PopupAction>(
                child: Text('Copy'),
                value: _PopupAction.copy,
              ),
              const PopupMenuItem<_PopupAction>(
                child: Text('Share'),
                value: _PopupAction.share,
              ),
              const PopupMenuItem<_PopupAction>(
                child: Text('Delete'),
                value: _PopupAction.delete,
              )
            ];
          } else {
            final items = <PopupMenuItem<_PopupAction>>[];
            if (_project != null) {
              items.add(
                const PopupMenuItem<_PopupAction>(
                  child: Text('Edit Project'),
                  value: _PopupAction.editproject,
                ),
              );
            }
            if (_label != null) {
              items.add(
                const PopupMenuItem<_PopupAction>(
                  child: Text('Edit Label'),
                  value: _PopupAction.editlabel,
                ),
              );
            }
            items.add(
              const PopupMenuItem<_PopupAction>(
                child: Text('Delete All'),
                value: _PopupAction.deleteall,
              ),
            );
            return items;
          }
        },
      );

  void _onSearch(BuildContext context) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (context) => const SearchScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => AnimatedTheme(
        data: selectedtodos.isNotEmpty ? whiteTheme : primaryTheme,
        child: SliverAppBar(
          pinned: false,
          floating: true,
          snap: true,
          leading: AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            child: selectedtodos.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: unSelectAll,
                  )
                : getCurrentBreakpoint(context) == ResponsiveBreakpoints.potrait
                    ? IconButton(
                        icon: const Icon(Icons.menu),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                      )
                    : null,
          ),
          title: _buildTitle(),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => _onSearch(context),
            ),
            _buildSortAction(context),
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
            _buildPopupAction(context),
          ],
        ),
      );
}
