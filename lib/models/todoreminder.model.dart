import 'package:json_annotation/json_annotation.dart';

import 'base.model.dart';
import 'todo.model.dart';
part 'todoreminder.model.g.dart';

enum TodoReminderType {
  image,
  text,
}

@JsonSerializable()
class TodoReminder extends BaseModel {
  TodoReminder({
    String? id,
    required this.title,
    required this.time,
    required this.completed,
    required this.todo,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(
          id: id,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  factory TodoReminder.fromJson(Map<String, dynamic> json) =>
      _$TodoReminderFromJson(json);

  final String title;
  final DateTime time;
  final bool completed;

  Todo todo;

  @override
  Map<String, dynamic> toJson() => _$TodoReminderToJson(this);
}
