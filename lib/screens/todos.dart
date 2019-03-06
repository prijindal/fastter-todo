import 'package:flutter/material.dart';

import '../components/todolist.dart';

class AllTodosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TodoList();
  }
}

class InboxScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TodoList(
      filter: {'project': null},
    );
  }
}

DateTime now = DateTime.now();
DateTime startOfToday = new DateTime(now.year, now.month, now.day);

class TodayScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TodoList(
      filter: {
        '_operators': {
          'dueDate': {
            'gte': startOfToday,
            'lte': startOfToday.add(const Duration(days: 1)),
          },
        },
      },
    );
  }
}

class SevenDayScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TodoList(
      filter: {
        '_operators': {
          'dueDate': {
            'gte': startOfToday,
            'lte': startOfToday.add(const Duration(days: 7)),
          },
        },
      },
    );
  }
}
