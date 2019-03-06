import 'package:flutter/material.dart';

Future<DateTime> todoSelectDate(BuildContext context) {
  DateTime now = DateTime.now();
  Future<DateTime> selectedDate = showDatePicker(
    context: context,
    initialDate: now,
    firstDate: now.subtract(const Duration(days: 365)),
    lastDate: now.add(const Duration(days: 365)),
  );
  return selectedDate;
}
