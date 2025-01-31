import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:watch_it/watch_it.dart';

import '../../components/adaptive_scaffold.dart';
import '../../components/main_drawer.dart';
import '../../helpers/breakpoints.dart';
import '../../helpers/todos_filters.dart';
import '../../models/local_state.dart';
import 'todoeditbar/index.dart';
import 'todogrid.dart';
import 'todoinputbar.dart';
import 'todolist.dart';

class TodoListScaffold extends WatchingStatefulWidget {
  const TodoListScaffold({
    super.key,
    required this.appBar,
    required this.filters,
  });

  final TodosFilters filters;

  /// An app bar to display at the top of the scaffold.
  final PreferredSizeWidget appBar;

  @override
  State<TodoListScaffold> createState() => _TodoListScaffoldState();
}

class _TodoListScaffoldState extends State<TodoListScaffold> {
  bool _showInput = false;
  final HotKey _hotKeyN = HotKey(
    key: PhysicalKeyboardKey.keyN,
    modifiers: [HotKeyModifier.control],
    // Set hotkey scope (default is HotKeyScope.system)
    scope: HotKeyScope.inapp, // Set as inapp-wide hotkey.
  );
  final HotKey _hotKeyEscape = HotKey(
    key: PhysicalKeyboardKey.escape,
    // Set hotkey scope (default is HotKeyScope.system)
    scope: HotKeyScope.inapp, // Set as inapp-wide hotkey.
  );

  @override
  initState() {
    super.initState();
    if (isDesktop) {
      hotKeyManager.register(
        _hotKeyN,
        keyDownHandler: (hotKey) {
          setState(() {
            _showInput = true;
          });
        },
      );
      hotKeyManager.register(
        _hotKeyEscape,
        keyDownHandler: (hotKey) {
          setState(() {
            _showInput = false;
          });
        },
      );
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (isDesktop) {
      hotKeyManager.unregister(_hotKeyN);
      hotKeyManager.unregister(_hotKeyEscape);
    }
  }

  Widget? _buildFab(bool isSelected) {
    if (isSelected || _showInput) {
      return null;
    }
    return FloatingActionButton(
      onPressed: () {
        setState(() {
          _showInput = true;
        });
      },
      tooltip: 'New Todo',
      key: Key("New Todo"),
      child: const Icon(Icons.add),
    );
  }

  Widget? _buildBottom(bool isSelected) {
    if (_showInput) {
      return BottomSheet(
        enableDrag: false,
        onClosing: () {
          setState(() {
            _showInput = true;
          });
        },
        builder: (context) => TodoInputBar(
          initialProject: widget.filters.projectFilter != "inbox"
              ? widget.filters.projectFilter
              : null,
          onBackButton: () {
            setState(() {
              _showInput = false;
            });
          },
        ),
      );
    }
    if (isSelected == false) {
      return null;
    }
    return BottomSheet(
      enableDrag: false,
      onClosing: () {
        GetIt.I<LocalStateNotifier>().clearSelectedTodoIds();
      },
      builder: (_) => TodoEditBar(),
    );
  }

  Widget _buildBody() {
    final todosView =
        watchPropertyValue((LocalStateNotifier state) => state.todosView);
    return todosView == TodosView.list
        ? TodoList(
            filters: widget.filters,
          )
        : TodoGrid(
            filters: widget.filters,
          );
  }

  @override
  Widget build(BuildContext context) {
    final isSelectedNotEmpty = watchPropertyValue((LocalStateNotifier state) {
      return state.selectedTodoIds.isNotEmpty;
    });
    return AdaptiveScaffold(
      appBar: widget.appBar,
      drawer: MainDrawer(),
      body: _buildBody(),
      floatingActionButton: _buildFab(isSelectedNotEmpty),
      bottomSheet: _buildBottom(isSelectedNotEmpty),
    );
  }
}
