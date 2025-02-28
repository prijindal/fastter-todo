import 'package:intl/intl.dart';

String dueDateFormatter(DateTime? dateUtc) {
  if (dateUtc == null) {
    return "";
  }
  final dueDate = DateTime(dateUtc.year, dateUtc.month, dateUtc.day);
  final nowTime = DateTime.now();
  final now = DateTime(nowTime.year, nowTime.month, nowTime.day);
  final diff = dueDate.difference(now);
  if (diff.inDays == 0) {
    return 'Today';
  } else if (diff.inDays == 1) {
    return 'Tomorrow';
  } else if (diff.inDays == -1) {
    return 'Yesterday';
  } else if (diff.inDays < 7 && diff.inDays > 0) {
    return DateFormat.EEEE().format(dueDate);
  } else if (now.year == dueDate.year) {
    return DateFormat.MMMd().format(dueDate);
  }
  return DateFormat.yMMMd().format(dueDate);
}

String dateFromNowFormatter(DateTime dateUtc) {
  final date = DateTime(dateUtc.year, dateUtc.month, dateUtc.day, dateUtc.hour,
      dateUtc.minute, dateUtc.second, dateUtc.millisecond, dateUtc.microsecond);
  final nowTime = DateTime.now();
  final now = DateTime(nowTime.year, nowTime.month, nowTime.day);
  final diff = date.difference(now);
  if (diff.inMinutes <= 1) {
    if (diff.inDays > 30) {
      return DateFormat.yMMMd().add_jm().format(date);
    } else if (diff.inDays > 7) {
      return '${diff.inDays} days ago, at '
          '${DateFormat().add_jm().format(date)}';
    } else if (diff.inDays > 1) {
      return 'Last ${DateFormat.EEEE().format(date)}, '
          'at ${DateFormat().add_jm().format(date)}';
    } else if (diff.inDays == 1) {
      return 'Yesterday at ${DateFormat().add_jm().format(date)}';
    } else if (diff.inDays == 0) {
      return 'Today at ${DateFormat().add_jm().format(date)}';
    }
  }
  return DateFormat.yMMMd().add_jm().format(date);
}
