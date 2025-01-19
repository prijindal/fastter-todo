import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/core.dart';
import '../../../models/db_manager.dart';
import '../../../models/local_db_state.dart';
import '../../../models/local_state.dart';
import '../tagselector.dart';
import 'change_date_button.dart';
import 'change_priority_button.dart';
import 'change_project_button.dart';
import 'comment_button.dart';
import 'delete_selected_todos_button.dart';
import 'edit_button.dart';
import 'mark_completed_button.dart';
import 'reminder_button.dart';

class TodoEditBar extends StatelessWidget {
  const TodoEditBar({super.key});

  @override
  Widget build(BuildContext context) =>
      Selector<LocalStateNotifier, List<String>>(
        selector: (context, localState) => localState.selectedTodoIds,
        builder: (context, selectedTodoIds, _) =>
            Selector<LocalDbState, List<TodoData>>(
          selector: (_, state) =>
              state.todos.where((a) => selectedTodoIds.contains(a.id)).toList(),
          builder: (context, selectedTodos, _) => _TodoEditBar(
            selectedTodos: selectedTodos,
          ),
        ),
      );
}

class _TodoEditBar extends StatefulWidget {
  const _TodoEditBar({
    required this.selectedTodos,
  });

  final List<TodoData> selectedTodos;

  @override
  State<_TodoEditBar> createState() => _TodoEditBarState();
}

class _TodoEditBarState extends State<_TodoEditBar> {
  bool _expanded = false;

  Widget _buildExpanded() {
    return ListView(
      shrinkWrap: true,
      children: [],
    );
  }

  Widget _buildCollapsed() {
    return TodoEditBarCollapsed(
      selectedTodos: widget.selectedTodos,
      onExpand: () {
        setState(() {
          _expanded = true;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) =>
      _expanded ? _buildExpanded() : _buildCollapsed();
}

class TodoEditBarCollapsed extends StatelessWidget {
  const TodoEditBarCollapsed({
    super.key,
    required this.selectedTodos,
    required this.onExpand,
  });

  final List<TodoData> selectedTodos;
  final VoidCallback onExpand;

  List<Widget> _buildButtons(BuildContext context) {
    if (selectedTodos.isEmpty) return [];
    if (selectedTodos.length <= 1) {
      return <Widget>[
        ChangeDateButton(
          selectedTodos: selectedTodos,
        ),
        EditButton(todo: selectedTodos.first),
        ChangeProjectButton(
          selectedTodos: selectedTodos,
        ),
        CommentButton(
          todo: selectedTodos.first,
        ),
        TagSelector(
          expanded: false,
          selectedTags: selectedTodos.first.tags,
          onSelected: (selectedTags) async =>
              await Provider.of<DbManager>(context, listen: false)
                  .database
                  .managers
                  .todo
                  .filter((f) => f.id.equals(selectedTodos.first.id))
                  .update(
                    (o) => o(
                      tags: drift.Value(selectedTags),
                    ),
                  ),
        ),
        ChangePriorityButton(
          selectedTodos: selectedTodos,
        ),
        ReminderButton(
          todo: selectedTodos.first,
        ),
        // TODO
        // _SubtaskButton(context),
        DeleteSelectedTodosButton(),
        // IconButton(
        //   onPressed: onExpand,
        //   icon: Icon(Icons.more),
        // )
      ];
    }
    return <Widget>[
      MarkCompletedButton(),
      ChangeDateButton(
        selectedTodos: selectedTodos,
      ),
      ChangeProjectButton(
        selectedTodos: selectedTodos,
      ),
      TagSelector(
        expanded: false,
        selectedTags: selectedTodos.map((a) => a.tags).reduce(
              (value, element) => value..addAll(element),
            ),
        onSelected: (selectedTags) async =>
            await Provider.of<DbManager>(context, listen: false)
                .database
                .managers
                .todo
                .filter((f) => f.id.isIn(selectedTodos.map((a) => a.id)))
                .update(
                  (o) => o(
                    tags: drift.Value(selectedTags),
                  ),
                ),
      ),
      ChangePriorityButton(
        selectedTodos: selectedTodos,
      ),
      DeleteSelectedTodosButton()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8.0),
      height: 50,
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        // spacing: 8.0,
        children: _buildButtons(context),
      ),
    );
  }
}
