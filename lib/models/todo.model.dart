import 'package:json_annotation/json_annotation.dart';

import 'base.model.dart';
import 'project.model.dart';
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
    this.project,
    this.loading,
  });

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);

  @JsonKey(name: '_id', nullable: false)
  final String id;
  String title;
  bool completed = false;

  @JsonKey(ignore: true)
  bool loading = false;

  DateTime dueDate;

  final DateTime createdAt;

  final DateTime updatedAt;

  Project project;

  Map<String, dynamic> toJson() => _$TodoToJson(this);
}
