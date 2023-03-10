import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

import '../bloc.dart';
import '../helpers/flutter_persistor.dart';
import '../fastter/fastter_bloc.dart';
import '../helpers/navigator.dart';
import '../helpers/responsive.dart';
import '../helpers/theme.dart';
import '../models/base.model.dart';
import '../models/label.model.dart';
import '../models/project.model.dart';
import '../models/settings.model.dart';
import '../models/todo.model.dart';
import '../models/user.model.dart';
import '../screens/editlabel.dart';
import '../screens/editproject.dart';
import '../screens/search.dart';
import '../store/labels.dart';
import '../store/projects.dart';
import '../store/selectedtodos.dart';
import '../store/todos.dart';
import '../store/user.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({
    required this.filter,
    required this.title,
    this.preferredSize = const Size.fromHeight(kToolbarHeight),
  });

  final Map<String, dynamic> filter;
  final String title;

  @override
  final Size preferredSize;
  @override
  Widget build(BuildContext context) => BlocBuilder<UserBloc, UserState>(
        bloc: fastterUser,
        builder: (context, userState) =>
            BlocBuilder<FastterBloc<Project>, ListState<Project>>(
          bloc: fastterProjects,
          builder: (context, projectsState) =>
              BlocBuilder<FastterBloc<Label>, ListState<Label>>(
            bloc: fastterLabels,
            builder: (context, labelsState) =>
                BlocBuilder<FastterBloc<Todo>, ListState<Todo>>(
              bloc: fastterTodos,
              builder: (context, todosState) =>
                  BlocBuilder<SelectedTodosBloc, List<String>>(
                bloc: selectedTodosBloc,
                builder: (context, selectedtodos) => _HomeAppBar(
                  filter: filter,
                  title: title,
                  projects: projectsState,
                  labels: labelsState,
                  todos: todosState,
                  updateTodo: (id, updated) =>
                      fastterTodos.add(UpdateEvent<Todo>(id, updated)),
                  deleteSelected: () {
                    for (final todoid in selectedtodos) {
                      fastterTodos.add(DeleteEvent<Todo>(todoid));
                      selectedTodosBloc.add(UnSelectTodoEvent(todoid));
                    }
                  },
                  deleteAll: () {
                    for (final todo in todosState.items.where(
                        (todo) => fastterTodos.filterObject(todo, filter))) {
                      fastterTodos.add(DeleteEvent<Todo>(todo.id));
                    }
                  },
                  selectedtodos: selectedtodos,
                  frontPage: userState.user?.settings?.frontPage ??
                      FrontPage(
                        route: '/',
                        title: 'Inbox',
                      ),
                  updateSortBy: (sortBy) =>
                      fastterTodos.add(SetSortByEvent<Todo>(sortBy)),
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

enum _SortAction { duedate, title, priority, project }

class _HomeAppBar extends StatelessWidget {
  const _HomeAppBar({
    required this.selectedtodos,
    required this.deleteSelected,
    required this.deleteAll,
    required this.projects,
    required this.labels,
    required this.todos,
    required this.filter,
    required this.title,
    required this.updateTodo,
    required this.updateSortBy,
    required this.frontPage,
  });

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

  Project? get _project {
    final filteredProjects = projects.items.where(
      (item) => item.id == filter['project'],
    );
    return filteredProjects.isEmpty ? null : filteredProjects.first;
  }

  Label? get _label {
    final filteredLabels = labels.items.where(
      (item) => item.id == filter['label'],
    );
    return filteredLabels.isEmpty ? null : filteredLabels.first;
  }

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
    String title = "Todos";
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
          title = _project!.title;
        } else {
          final map = history.last.arguments;
          if (map != null && map.containsKey('project')) {
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
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
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
    ScaffoldMessenger.of(context).showSnackBar(
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
    FlutterPersistor.getInstance().load();
  }

  void _deleteAll(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure'),
        content: const Text('This will delete all tasks'),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
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
          label: _label!,
        ),
      ),
    );
  }

  void _editProject(BuildContext context) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (context) => EditProjectScreen(
          project: _project!,
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
          } else if (action == _SortAction.project) {
            updateSortBy('project');
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
          ),
          PopupMenuItem<_SortAction>(
            enabled: todos.sortBy != 'project',
            value: _SortAction.project,
            child: const Text('Project'),
          )
        ],
        tooltip: 'Due Date',
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
                value: _PopupAction.copy,
                child: Text('Copy'),
              ),
              const PopupMenuItem<_PopupAction>(
                value: _PopupAction.share,
                child: Text('Share'),
              ),
              const PopupMenuItem<_PopupAction>(
                value: _PopupAction.attach,
                child: Text('Attach To'),
              ),
              const PopupMenuItem<_PopupAction>(
                value: _PopupAction.delete,
                child: Text('Delete'),
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
        tooltip: 'More',
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
        // isMaterialAppTheme: true,
        data: selectedtodos.isNotEmpty ? whiteTheme : primaryTheme,
        child: AppBar(
          automaticallyImplyLeading:
              getCurrentBreakpoint(context) == ResponsiveBreakpoints.potrait,
          leading: selectedtodos.isNotEmpty
              ? BlocBuilder<SelectedTodosBloc, List<String>>(
                  bloc: selectedTodosBloc,
                  builder: (context, state) => IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      for (final id in state) {
                        selectedTodosBloc.add(UnSelectTodoEvent(id));
                      }
                    },
                    tooltip: 'Unselect',
                  ),
                )
              : getCurrentBreakpoint(context) == ResponsiveBreakpoints.potrait
                  ? IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                      tooltip: 'Drawer',
                    )
                  : null,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_buildTitle()],
          ),
          actions: [
            if (selectedtodos.isEmpty)
              IconButton(
                icon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onPressed: () => _onSearch(context),
                tooltip: 'Search',
              ),
            if (selectedtodos.isEmpty) _buildSortAction(context),
            if (selectedtodos.isEmpty)
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
                color: Colors.white,
                tooltip: 'Notifications',
              ),
            _buildPopupAction(context),
          ],
        ),
      );
}
