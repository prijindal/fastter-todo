import 'package:fastter_dart/models/user.model.dart';
import 'package:fastter_dart/store/labels.dart';
import 'package:fastter_dart/store/notifications.dart';
import 'package:fastter_dart/store/projects.dart';
import 'package:fastter_dart/store/todocomments.dart';
import 'package:fastter_dart/store/todoreminders.dart';
import 'package:fastter_dart/store/user.dart';
import 'package:fastter_todo/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share/share.dart';

import 'package:fastter_dart/fastter/fastter.dart';
import 'package:fastter_dart/fastter/fastter_bloc.dart';
import 'package:fastter_dart/models/base.model.dart';
import 'package:fastter_dart/models/label.model.dart';
import 'package:fastter_dart/models/project.model.dart';
import 'package:fastter_dart/models/settings.model.dart';
import 'package:fastter_dart/models/todo.model.dart';
import 'package:fastter_dart/models/todocomment.model.dart';
import 'package:fastter_dart/models/todoreminder.model.dart';
import 'package:fastter_dart/models/notification.model.dart'
    as notification_model;
import 'package:fastter_dart/store/selectedtodos.dart';
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
  Widget build(BuildContext context) => BlocBuilder<UserEvent, UserState>(
        bloc: fastterUser,
        builder: (context, userState) =>
            BlocBuilder<FastterEvent<Project>, ListState<Project>>(
              bloc: fastterProjects,
              builder: (context, projectsState) =>
                  BlocBuilder<FastterEvent<Label>, ListState<Label>>(
                    bloc: fastterLabels,
                    builder: (context, labelsState) =>
                        BlocBuilder<FastterEvent<Todo>, ListState<Todo>>(
                          bloc: fastterTodos,
                          builder: (context, todosState) =>
                              BlocBuilder<SelectedTodoEvent, List<String>>(
                                bloc: selectedTodosBloc,
                                builder: (context, selectedtodos) =>
                                    _HomeAppBar(
                                      projectSyncStart: () => fastterProjects
                                          .dispatch(SyncEvent<Project>()),
                                      labelSyncStart: () => fastterLabels
                                          .dispatch(SyncEvent<Label>()),
                                      todoSyncStart: () => fastterTodos
                                          .dispatch(SyncEvent<Todo>()),
                                      todoCommentsSyncStart: () =>
                                          fastterTodoComments.dispatch(
                                              SyncEvent<TodoComment>()),
                                      todoRemindersSyncStart: () =>
                                          fastterTodoReminders.dispatch(
                                              SyncEvent<TodoReminder>(<String,
                                                  dynamic>{
                                            'completed': false,
                                          })),
                                      notificationsSyncStart: () =>
                                          fastterNotifications.dispatch(
                                              SyncEvent<
                                                  notification_model
                                                      .Notification>()),
                                      filter: filter,
                                      title: title,
                                      projects: projectsState,
                                      labels: labelsState,
                                      todos: todosState,
                                      updateTodo: (id, updated) =>
                                          fastterTodos.dispatch(
                                              UpdateEvent<Todo>(id, updated)),
                                      deleteSelected: () {
                                        for (final todoid in selectedtodos) {
                                          fastterTodos.dispatch(
                                              DeleteEvent<Todo>(todoid));
                                          selectedTodosBloc.dispatch(
                                              UnSelectTodoEvent(todoid));
                                        }
                                      },
                                      deleteAll: () {
                                        for (final todo in todosState.items
                                            .where((todo) => fastterTodos
                                                .filterObject(todo, filter))) {
                                          fastterTodos.dispatch(
                                              DeleteEvent<Todo>(todo.id));
                                        }
                                      },
                                      selectedtodos: selectedtodos,
                                      frontPage:
                                          userState.user?.settings?.frontPage ??
                                              FrontPage(
                                                route: '/',
                                                title: 'Inbox',
                                              ),
                                      updateSortBy: (sortBy) =>
                                          fastterTodos.dispatch(
                                              SetSortByEvent<Todo>(sortBy)),
                                    ),
                              ),
                        ),
                  ),
            ),
      );
}

enum _PopupAction {
  delete,
  deleteall,
  editproject,
  editlabel,
  copy,
  share,
  attach,
  refresh
}

enum _SortAction { duedate, title, priority }

class _HomeAppBar extends StatelessWidget {
  const _HomeAppBar({
    @required this.labelSyncStart,
    @required this.projectSyncStart,
    @required this.todoSyncStart,
    @required this.todoCommentsSyncStart,
    @required this.todoRemindersSyncStart,
    @required this.notificationsSyncStart,
    @required this.selectedtodos,
    @required this.deleteSelected,
    @required this.deleteAll,
    @required this.projects,
    @required this.labels,
    @required this.todos,
    @required this.filter,
    @required this.title,
    @required this.updateTodo,
    @required this.updateSortBy,
    @required this.frontPage,
    Key key,
  }) : super(key: key);

  final VoidCallback projectSyncStart;
  final VoidCallback labelSyncStart;
  final VoidCallback todoSyncStart;
  final VoidCallback todoCommentsSyncStart;
  final VoidCallback todoRemindersSyncStart;
  final VoidCallback notificationsSyncStart;
  final Map<String, dynamic> filter;
  final List<String> selectedtodos;
  final VoidCallback deleteSelected;
  final VoidCallback deleteAll;
  final ListState<Project> projects;
  final ListState<Label> labels;
  final ListState<Todo> todos;
  final String title;
  final void Function(String, Todo) updateTodo;
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
          final Map map = history.last.arguments;
          if (map.containsKey('project')) {
            final Project project = map['project'];
            title = project.title;
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

  Future<void> _attachSelected(BuildContext context) async {
    final parent = await showDialog<Todo>(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text('Select a parent'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    title: const Text('None'),
                    onTap: () => Navigator.of(context).pop(null),
                  ),
                  ...todos.items
                      .where((todo) => fastterTodos.filterObject(todo, filter))
                      .map(
                        (todo) => ListTile(
                              title: Text(todo.title),
                              onTap: () => Navigator.of(context).pop(todo),
                            ),
                      )
                      .toList(),
                ],
              ),
            ),
          ),
    );
    for (final todo
        in todos.items.where((todo) => selectedtodos.contains(todo.id))) {
      todo.parent = parent;
      updateTodo(todo.id, todo);
    }
  }

  Future<void> _refresh() async {
    todoSyncStart();
    projectSyncStart();
    labelSyncStart();
    todoCommentsSyncStart();
    todoRemindersSyncStart();
    notificationsSyncStart();
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
        onSelected: (action) {
          if (action == _SortAction.duedate) {
            updateSortBy('dueDate');
          } else if (action == _SortAction.priority) {
            updateSortBy('priority');
          } else if (action == _SortAction.title) {
            updateSortBy('title');
          }
        },
        icon: const Icon(
          Icons.sort,
          color: Colors.white,
        ),
        itemBuilder: (context) => [
              const PopupMenuItem(
                enabled: false,
                child: Text('Sort By'),
              ),
              const PopupMenuDivider(),
              PopupMenuItem<_SortAction>(
                enabled: todos.sortBy != 'dueDate',
                value: _SortAction.duedate,
                child: const Text('Due Date'),
              ),
              PopupMenuItem<_SortAction>(
                enabled: todos.sortBy != 'priority',
                value: _SortAction.priority,
                child: const Text('Priority'),
              ),
              PopupMenuItem<_SortAction>(
                enabled: todos.sortBy != 'title',
                value: _SortAction.title,
                child: const Text('Title'),
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
            } else if (value == _PopupAction.attach) {
              _attachSelected(context);
            }
          } else {
            if (value == _PopupAction.deleteall) {
              _deleteAll(context);
            } else if (value == _PopupAction.editproject) {
              _editProject(context);
            } else if (value == _PopupAction.editlabel) {
              _editLabel(context);
            } else if (value == _PopupAction.refresh) {
              _refresh();
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
                child: Text('Attach To'),
                value: _PopupAction.attach,
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
                child: Text('Refresh'),
                value: _PopupAction.refresh,
              ),
            );
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
        isMaterialAppTheme: true,
        data: selectedtodos.isNotEmpty ? whiteTheme : primaryTheme,
        child: SliverAppBar(
          pinned: false,
          floating: true,
          snap: true,
          automaticallyImplyLeading:
              getCurrentBreakpoint(context) == ResponsiveBreakpoints.potrait,
          leading: selectedtodos.isNotEmpty
              ? BlocBuilder<SelectedTodoEvent, List<String>>(
                  bloc: selectedTodosBloc,
                  builder: (context, state) => IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          for (final id in state) {
                            selectedTodosBloc.dispatch(UnSelectTodoEvent(id));
                          }
                        },
                      ),
                )
              : getCurrentBreakpoint(context) == ResponsiveBreakpoints.potrait
                  ? IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    )
                  : null,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(),
              AnimatedCrossFade(
                duration: kThemeAnimationDuration,
                firstChild: Text(
                  'Connecting...',
                  style: Theme.of(context)
                      .textTheme
                      .body1
                      .apply(color: Colors.white),
                ),
                secondChild: Container(),
                crossFadeState: Fastter.getInstance().isSocketConnected
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
              ),
            ],
          ),
          actions: [
            if (selectedtodos.isEmpty)
              IconButton(
                icon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onPressed: () => _onSearch(context),
              ),
            if (selectedtodos.isEmpty) _buildSortAction(context),
            if (selectedtodos.isEmpty)
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
                color: Colors.white,
              ),
            _buildPopupAction(context),
          ],
        ),
      );
}
