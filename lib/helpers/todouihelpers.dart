import 'package:intl/intl.dart';
import 'package:flutter/widgets.dart';
import '../components/date_picker.dart';

Future<DatePickerResponse> todoSelectDate(BuildContext context,
    [DateTime initialDate]) {
  final now = DateTime.now();
  final selectedDate = showDatePicker(
    context: context,
    initialDate: initialDate == null ? now : initialDate,
    firstDate: now.subtract(const Duration(days: 365)),
    lastDate: now.add(const Duration(days: 365)),
  );
  return selectedDate;
}

String dueDateFormatter(DateTime dueDate) {
  final now = DateTime.now();
  final diff = dueDate.difference(now);
  if (diff.inDays > -2 && diff.inDays < 2) {
    if (dueDate.day == now.day) {
      return 'Today';
    } else if (dueDate.day == now.day + 1) {
      return 'Tomorrow';
    } else if (dueDate.day == now.day - 1) {
      return 'Yesterday';
    }
  }
  if (diff.inDays < 7 && diff.inDays > 0) {
    return DateFormat.EEEE().format(dueDate);
  } else if (now.year == dueDate.year) {
    return DateFormat.MMMd().format(dueDate);
  }
  return DateFormat.yMMMd().format(dueDate);
}
