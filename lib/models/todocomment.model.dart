import 'package:json_annotation/json_annotation.dart';

import 'base.model.dart';
import 'todo.model.dart';
part 'todocomment.model.g.dart';

enum TodoCommentType {
  image,
  text,
}

@JsonSerializable()
class TodoComment extends BaseModel {
  TodoComment({
    this.id,
    this.content,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.todo,
  });

  factory TodoComment.fromJson(Map<String, dynamic> json) =>
      _$TodoCommentFromJson(json);

  @JsonKey(name: '_id', nullable: false)
  @override
  final String id;
  final TodoCommentType type;
  final String content;

  final DateTime createdAt;

  final DateTime updatedAt;

  Todo todo;

  @override
  Map<String, dynamic> toJson() => _$TodoCommentToJson(this);
}
