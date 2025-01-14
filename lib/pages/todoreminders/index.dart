import 'package:auto_route/auto_route.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/core.dart';
import '../../models/db_selector.dart';
import '../../models/local_db_state.dart';
import '../todos/todo_select_date.dart';

@RoutePage()
class TodoRemindersScreen extends StatelessWidget {
  const TodoRemindersScreen({
    super.key,
    @PathParam() required this.todoId,
  });

  final String todoId;

  @override
  Widget build(BuildContext context) => Consumer<LocalDbState>(
        builder: (context, localDbState, _) => _TodoRemindersScreen(
          todo: localDbState.todos.firstWhere((f) => f.id == todoId),
          reminders:
              localDbState.reminders.where((a) => a.todo == todoId).toList(),
        ),
      );
}

class _TodoRemindersScreen extends StatelessWidget {
  const _TodoRemindersScreen({required this.todo, required this.reminders});

  final TodoData todo;
  final List<ReminderData> reminders;

  Future<void> _newReminder(BuildContext context) async {
    final now = DateTime.now();
    final dateResponse = await todoSelectDate(context, now, false);
    if (dateResponse != null && context.mounted) {
      final date = dateResponse;
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(minute: date.minute, hour: date.hour),
      );
      if (time != null) {
        final newTime =
            DateTime(date.year, date.month, date.day, time.hour, time.minute);
        // ignore: use_build_context_synchronously
        await Provider.of<DbSelector>(context, listen: false)
            .database
            .managers
            .reminder
            .create((o) => o(
                  time: newTime.toUtc(),
                  title: "New Reminder",
                  todo: todo.id,
                  completed: drift.Value(false),
                ));
      }
    }
  }

  String _formattedTime(ReminderData todoReminder) =>
      DateFormat('EEE dd MMM y, hh:mm a').format(todoReminder.time.toLocal());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(todo.title),
      ),
      body: Flex(
        direction: Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (reminders.isEmpty)
            const Flexible(
              child: Center(
                child: Text('No Reminders'),
              ),
            )
          else
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: reminders.reversed
                      .map(
                        (todoReminder) => ListTile(
                          title: Text(todoReminder.title),
                          subtitle: Text(_formattedTime(todoReminder)),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _newReminder(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
