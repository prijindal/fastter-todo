import 'package:flutter/material.dart';

import '../components/todolist.dart';

class AllTodosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const TodoList(
        categoryView: true,
      );
}

class InboxScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const TodoList(
        filter: <String, dynamic>{'project': null},
        title: 'Inbox',
      );
}

DateTime now = DateTime.now();
DateTime startOfToday = DateTime(now.year, now.month, now.day, 0, 0, 0, 0);

class TodayScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => TodoList(
        title: 'Today',
        categoryView: true,
        filter: <String, dynamic>{
          '_operators': {
            'dueDate': {
              'lte': startOfToday.add(const Duration(days: 1)),
            },
          },
        },
      );
}

class SevenDayScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => TodoList(
        title: '7 Days',
        categoryView: true,
        filter: <String, dynamic>{
          '_operators': {
            'dueDate': {
              'lte': startOfToday.add(const Duration(days: 7)),
            },
          },
        },
      );
}
