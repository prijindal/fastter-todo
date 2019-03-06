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
