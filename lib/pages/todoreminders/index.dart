import 'package:auto_route/auto_route.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/core.dart';
import '../../models/drift.dart';
import '../todos/todo_select_date.dart';

@RoutePage()
class TodoRemindersScreen extends StatelessWidget {
  const TodoRemindersScreen({
    super.key,
    @PathParam() required this.todoId,
  });

  final String todoId;

  @override
  Widget build(BuildContext context) => StreamBuilder<TodoData>(
        stream: MyDatabase.instance.managers.todo
            .filter((f) => f.id.equals(todoId))
            .watchSingle(),
        builder: (context, todoSnapshot) => StreamBuilder<List<ReminderData>>(
          stream: MyDatabase.instance.managers.reminder
              .filter((f) => f.todo.id.equals(todoId))
              .watch(),
          builder: (context, remindersSnapshot) =>
              (!remindersSnapshot.hasData || !todoSnapshot.hasData)
                  ? Center(child: Text("Loading..."))
                  : _TodoRemindersScreen(
                      todo: todoSnapshot.requireData,
                      reminders: remindersSnapshot.requireData,
                    ),
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
        await MyDatabase.instance.managers.reminder.create((o) => o(
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
