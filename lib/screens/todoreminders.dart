import 'dart:async';
import 'package:fastter_dart/store/todoreminders.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import 'package:fastter_dart/fastter/fastter_bloc.dart';
import 'package:fastter_dart/models/base.model.dart';
import 'package:fastter_dart/models/todo.model.dart';
import 'package:fastter_dart/models/todoreminder.model.dart';

import '../helpers/todouihelpers.dart';

class TodoRemindersScreen extends StatelessWidget {
  const TodoRemindersScreen({
    @required this.todo,
    Key key,
  }) : super(key: key);

  final Todo todo;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<FastterBloc<TodoReminder>, ListState<TodoReminder>>(
        bloc: fastterTodoReminders,
        builder: (context, state) => _TodoRemindersScreen(
              todo: todo,
              todoReminders: ListState<TodoReminder>(
                items: state.items
                    .where((todoreminder) =>
                        todoreminder.todo != null &&
                        todoreminder.todo.id == todo.id &&
                        todoreminder.completed == false)
                    .toList(),
              ),
              addReminder: (reminder) {
                final action = AddEvent<TodoReminder>(reminder);
                fastterTodoReminders.dispatch(action);
                return action.completer.future;
              },
              deleteReminder: (reminderid) {
                final action = DeleteEvent<TodoReminder>(reminderid);
                fastterTodoReminders.dispatch(action);
                return action.completer.future;
              },
            ),
      );
}

class _TodoRemindersScreen extends StatelessWidget {
  _TodoRemindersScreen({
    @required this.todo,
    @required this.todoReminders,
    @required this.addReminder,
    @required this.deleteReminder,
    Key key,
  }) : super(key: key);

  final Todo todo;
  final ListState<TodoReminder> todoReminders;
  final Future<TodoReminder> Function(TodoReminder) addReminder;
  final Future<TodoReminder> Function(String) deleteReminder;

  final ScrollController scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _newReminder(BuildContext context) async {
    final now = DateTime.now();
    final dateResponse = await todoSelectDate(context, now, false);
    if (dateResponse != null) {
      final date = dateResponse.dateTime;
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(minute: date.minute, hour: date.hour),
      );
      if (time != null) {
        final newTime =
            DateTime(date.year, date.month, date.day, time.hour, time.minute);
        final newReminder = await addReminder(
          TodoReminder(
            time: newTime.toUtc(),
            title: 'New Reminder',
            todo: todo,
            completed: false,
          ),
        );
        if (newReminder != null) {
          _scaffoldKey.currentState.showSnackBar(
            SnackBar(
              content: const Text('New Reminder Created'),
              action: SnackBarAction(
                label: 'Undo',
                onPressed: () => deleteReminder(newReminder.id),
              ),
            ),
          );
        }
      }
    }
  }

  String _formattedTime(TodoReminder todoReminder) =>
      DateFormat('EEE dd MMM y, hh:mm a').format(todoReminder.time.toLocal());

  @override
  Widget build(BuildContext context) => Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(todo.title),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _newReminder(context),
          child: const Icon(Icons.add),
        ),
        body: Container(
          child: Flex(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (todoReminders.items.isEmpty)
                const Flexible(
                  child: Center(
                    child: Text('No Reminders'),
                  ),
                )
              else
                Flexible(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      children: todoReminders.items.reversed
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
        ),
      );
}
