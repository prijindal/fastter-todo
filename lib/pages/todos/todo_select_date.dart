import 'package:flutter/material.dart';

Future<DateTime?> todoSelectDate(BuildContext context,
    [DateTime? initialDate,
    bool? allowNull,
    DateTime? firstDate,
    DateTime? lastDate]) {
  final now = DateTime.now();
  final selectedDate = showDatePicker(
    context: context,
    initialDate: initialDate ?? now,
    firstDate: firstDate ?? now.subtract(const Duration(days: 365)),
    lastDate: lastDate ?? now.add(const Duration(days: 365)),
  );
  return selectedDate;
}
