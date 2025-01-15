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

class _TodoRemindersScreen extends StatefulWidget {
  const _TodoRemindersScreen({required this.todo, required this.reminders});

  final TodoData todo;
  final List<ReminderData> reminders;

  @override
  State<_TodoRemindersScreen> createState() => _TodoRemindersScreenState();
}

class _TodoRemindersScreenState extends State<_TodoRemindersScreen> {
  List<String> _selectedReminders = [];

  Future<void> _newReminder(BuildContext context) async {
    final now = DateTime.now();
    final dateResponse = await todoSelectDate(context, now, false, now);
    if (dateResponse != null && context.mounted) {
      final date = dateResponse;
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(minute: now.minute, hour: now.hour),
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
                  todo: widget.todo.id,
                  completed: drift.Value(false),
                ));
        // ignore: use_build_context_synchronously
        await Provider.of<LocalDbState>(context, listen: false).refresh();
      }
    }
  }

  void _toggleSelected(ReminderData todoReminder) {
    setState(() {
      if (_selectedReminders.contains(todoReminder.id)) {
        _selectedReminders.remove(todoReminder.id);
      } else {
        _selectedReminders.add(todoReminder.id);
      }
    });
  }

  Future<void> _deleteSelectedReminders(BuildContext context) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure'),
        content:
            Text('This will delete ${_selectedReminders.length} reminders'),
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
    if (shouldDelete == true && context.mounted) {
      await Provider.of<DbSelector>(context, listen: false)
          .database
          .managers
          .reminder
          .filter((f) => f.id.isIn(_selectedReminders))
          .delete();
      // ignore: use_build_context_synchronously
      await Provider.of<LocalDbState>(context, listen: false).refresh();
    }
  }

  List<Widget> _buildActions(BuildContext context) {
    if (_selectedReminders.isEmpty) {
      return [];
    } else {
      return [
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => _deleteSelectedReminders(context),
          tooltip: 'Delete',
        )
      ];
    }
  }

  String _formattedTime(ReminderData todoReminder) =>
      DateFormat('EEE dd MMM y, hh:mm a').format(todoReminder.time.toLocal());

  void _onClear() {
    setState(() {
      _selectedReminders = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _selectedReminders.isEmpty,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          _onClear();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_selectedReminders.isEmpty
              ? widget.todo.title
              : "${_selectedReminders.length} Reminders selected"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _selectedReminders.isEmpty
                ? () => {AutoRouter.of(context).maybePop()}
                : _onClear,
            tooltip: 'Back',
          ),
          actions: _buildActions(context),
        ),
        body: _buildBody(),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _newReminder(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Flex _buildBody() {
    return Flex(
      direction: Axis.vertical,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (widget.reminders.isEmpty)
          const Flexible(
            child: Center(
              child: Text('No Reminders'),
            ),
          )
        else
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                children: widget.reminders.reversed
                    .map(
                      (todoReminder) => ListTile(
                        title: Text(todoReminder.title),
                        subtitle: Text(_formattedTime(todoReminder)),
                        onLongPress: () => _toggleSelected(todoReminder),
                        onTap: _selectedReminders.isEmpty
                            ? () {}
                            : () => _toggleSelected(todoReminder),
                        selected: _selectedReminders.contains(todoReminder.id),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
      ],
    );
  }
}
