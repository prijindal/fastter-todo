import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

Future<DateTime> todoSelectDate(BuildContext context, [DateTime initalDate]) {
  DateTime now = DateTime.now();
  Future<DateTime> selectedDate = showDatePicker(
    context: context,
    initialDate: initalDate == null ? now : initalDate,
    firstDate: now.subtract(const Duration(days: 365)),
    lastDate: now.add(const Duration(days: 365)),
  ).then((date) {
    return new DateTime(date.year, date.month, date.day, 0, 0, 0);
  });
  return selectedDate;
}

String dueDateFormatter(DateTime dueDate) {
  DateTime now = DateTime.now();
  Duration diff = dueDate.difference(now);
  if (diff.inDays > -2 && diff.inDays < 2) {
    if (dueDate.day == now.day) {
      return "Today";
    } else if (dueDate.day == now.day + 1) {
      return "Tomorrow";
    } else if (dueDate.day == now.day - 1) {
      return "Yesterday";
    }
  }
  if (diff.inDays < 7 && diff.inDays > 0) {
    return DateFormat.EEEE().format(dueDate);
  } else if (now.year == dueDate.year) {
    return DateFormat.MMMd().format(dueDate);
  }
  return DateFormat.yMMMd().format(dueDate);
}
