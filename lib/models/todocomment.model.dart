import 'package:json_annotation/json_annotation.dart';

import 'base.model.dart';
import 'todo.model.dart';
part 'todocomment.model.g.dart';

enum TodoCommentType {
  image,
  text,
  video,
}

@JsonSerializable()
class TodoComment extends BaseModel {
  TodoComment({
    String? id,
    required this.content,
    required this.type,
    required this.todo,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(
          id: id,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  factory TodoComment.fromJson(Map<String, dynamic> json) =>
      _$TodoCommentFromJson(json);

  final TodoCommentType type;
  final String content;

  Todo todo;

  @override
  Map<String, dynamic> toJson() => _$TodoCommentToJson(this);
}
