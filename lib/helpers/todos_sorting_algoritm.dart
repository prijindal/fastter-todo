import '../models/core.dart';

class TodosSortingAlgorithm {
  final String title;
  final int Function(TodoData, TodoData) compare;

  TodosSortingAlgorithm({
    required this.title,
    required this.compare,
  });

  factory TodosSortingAlgorithm.priority() => TodosSortingAlgorithm(
        title: "By Priority",
        compare: (a, b) => b.priority.compareTo(a.priority),
      );

  factory TodosSortingAlgorithm.dueDate() => TodosSortingAlgorithm(
        title: "By Due Date",
        compare: (a, b) {
          final aDueDate = a.due_date;
          final bDueDate = b.due_date;
          if (bDueDate == null && aDueDate == null) {
            return 0;
          }
          if (bDueDate == null) {
            return -1;
          }
          if (aDueDate == null) {
            return 1;
          }
          return aDueDate.compareTo(bDueDate);
        },
      );

  factory TodosSortingAlgorithm.creationTime() => TodosSortingAlgorithm(
        title: "By Creation Time",
        compare: (a, b) {
          return b.created_at.compareTo(a.created_at);
        },
      );

  factory TodosSortingAlgorithm.completion() => TodosSortingAlgorithm(
        title: "By Completion",
        compare: (a, b) {
          if (a.completed == b.completed) {
            return 0;
          }
          if (a.completed) {
            return 1;
          }
          if (b.completed) {
            return -1;
          }
          return 0;
        },
      );

  factory TodosSortingAlgorithm.base() {
    final completionSorting = TodosSortingAlgorithm.completion();
    final prioritySorting = TodosSortingAlgorithm.priority();
    final dueDateSorting = TodosSortingAlgorithm.dueDate();
    final creationTimeSorting = TodosSortingAlgorithm.creationTime();
    return TodosSortingAlgorithm(
      title: "Default",
      compare: (a, b) {
        final completionSort = completionSorting.compare(a, b);
        if (completionSort != 0) {
          return completionSort;
        }
        final prioritySort = prioritySorting.compare(a, b);
        if (prioritySort != 0) {
          return prioritySort;
        }
        final dueDateSort = dueDateSorting.compare(a, b);
        if (dueDateSort != 0) {
          return dueDateSort;
        }
        return creationTimeSorting.compare(a, b);
      },
    );
  }
}
