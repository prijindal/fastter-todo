import 'package:json_annotation/json_annotation.dart';

import 'base.model.dart';
part 'todo.model.g.dart';

@JsonSerializable()
class Todo extends BaseModel {
  Todo({
    this.id,
    this.title,
    this.completed,
    this.dueDate,
    this.createdAt,
    this.updatedAt,
  });

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);

  @JsonKey(name: '_id', nullable: false)
  final String id;
  final String title;
  final bool completed;
  final DateTime dueDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  Map<String, dynamic> toJson() => _$TodoToJson(this);
}
