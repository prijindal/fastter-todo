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

String dateFromNowFormatter(DateTime date) {
  date = date.toLocal();
  final now = DateTime.now();
  final diff = date.difference(now);
  if (diff.inMinutes <= 1) {
    if (diff.inDays > 30) {
      return DateFormat.yMMMd().add_jm().format(date);
    } else if (diff.inDays > 7) {
      return '${diff.inDays} days ago, at ${DateFormat().add_jm().format(date)}';
    } else if (diff.inDays > 1) {
      return 'Last ${DateFormat.EEEE().format(date)}, at ${DateFormat().add_jm().format(date)}';
    } else if (diff.inDays == 1) {
      return 'Yesterday at ${DateFormat().add_jm().format(date)}';
    } else if (diff.inDays == 0) {
      return 'Today at ${DateFormat().add_jm().format(date)}';
    }
  }
  return DateFormat.yMMMd().add_jm().format(date);
}
