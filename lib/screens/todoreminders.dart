import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:fastter_dart/fastter/fastter_action.dart';
import 'package:fastter_dart/models/base.model.dart';
import 'package:fastter_dart/models/todo.model.dart';
import 'package:fastter_dart/models/todoreminder.model.dart';
import 'package:fastter_dart/store/state.dart';

import '../helpers/todouihelpers.dart';

class TodoRemindersScreen extends StatelessWidget {
  const TodoRemindersScreen({
    @required this.todo,
    Key key,
  }) : super(key: key);

  final Todo todo;

  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, Store<AppState>>(
        converter: (store) => store,
        builder: (context, store) => _TodoRemindersScreen(
              todo: todo,
              todoReminders: ListState<TodoReminder>(
                items: store.state.todoReminders.items
                    .where((todoreminder) =>
                        todoreminder.todo != null &&
                        todoreminder.todo.id == todo.id &&
                        todoreminder.completed == false)
                    .toList(),
              ),
              syncStart: () => store.dispatch(StartSync<TodoReminder>()),
              addReminder: (TodoReminder reminder) =>
                  store.dispatch(AddItem<TodoReminder>(reminder)),
            ),
      );
}

class _TodoRemindersScreen extends StatefulWidget {
  const _TodoRemindersScreen({
    @required this.todo,
    @required this.todoReminders,
    @required this.addReminder,
    @required this.syncStart,
    Key key,
  }) : super(key: key);

  final Todo todo;
  final ListState<TodoReminder> todoReminders;
  final void Function(TodoReminder) addReminder;
  final VoidCallback syncStart;

  @override
  _TodoRemindersScreenState createState() => _TodoRemindersScreenState();
}

class _TodoRemindersScreenState extends State<_TodoRemindersScreen> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    widget.syncStart();
    super.initState();
  }

  void _newReminder() async {
    final now = DateTime.now();
    final dateResponse = await todoSelectDate(context, now);
    if (dateResponse != null) {
      final date = dateResponse.dateTime;
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(minute: date.minute, hour: date.hour),
      );
      final newTime =
          DateTime(date.year, date.month, date.day, time.hour, time.minute);
      widget.addReminder(
        TodoReminder(
          time: newTime,
          title: 'New Reminder',
          todo: widget.todo,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.todo.title),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _newReminder,
          child: const Icon(Icons.add),
        ),
        body: Container(
          child: Flex(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              widget.todoReminders.items.isEmpty
                  ? Flexible(
                      child: Center(
                        child: const Text('No Reminders'),
                      ),
                    )
                  : Flexible(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          children: widget.todoReminders.items.reversed
                              .map(
                                (todoReminder) => ListTile(
                                      title: Text(todoReminder.title),
                                      subtitle: Text(
                                          dueDateFormatter(todoReminder.time)),
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
