import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/core.dart';
import '../../../models/db_selector.dart';
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
        builder: (context, selectedTodoIds, _) => StreamBuilder<List<TodoData>>(
          initialData: selectedTodoIds
              .map(
                // Mocked data for init screen
                (a) => TodoData(
                  id: a,
                  title: a,
                  priority: 1,
                  completed: false,
                  creationTime: DateTime.now(),
                  tags: [],
                ),
              )
              .toList(),
          stream: Provider.of<DbSelector>(context, listen: false)
              .database
              .managers
              .todo
              .filter((f) => f.id.isIn(selectedTodoIds))
              .watch(),
          builder: (context, selectedTodos) => _TodoEditBar(
            selectedTodos: selectedTodos.requireData,
          ),
        ),
      );
}

class _TodoEditBar extends StatelessWidget {
  const _TodoEditBar({
    required this.selectedTodos,
  });

  final List<TodoData> selectedTodos;

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
              await Provider.of<DbSelector>(context, listen: false)
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
        DeleteSelectedTodosButton()
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
            await Provider.of<DbSelector>(context, listen: false)
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
  Widget build(BuildContext context) => Card(
        elevation: 20,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 4),
          height: 60,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: _buildButtons(context),
          ),
        ),
      );
}
