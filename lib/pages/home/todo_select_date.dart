import 'package:flutter/material.dart';

Future<DateTime?> todoSelectDate(BuildContext context,
    [DateTime? initialDate, bool? allowNull]) {
  final now = DateTime.now();
  final selectedDate = showDatePicker(
    context: context,
    initialDate: initialDate ?? now,
    firstDate: now.subtract(const Duration(days: 365)),
    lastDate: now.add(const Duration(days: 365)),
  );
  return selectedDate;
}
