// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todocomment.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TodoComment _$TodoCommentFromJson(Map<String, dynamic> json) {
  return TodoComment(
      id: json['_id'] as String,
      content: json['content'] as String,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      todo: json['todo'] == null
          ? null
          : Todo.fromJson(json['todo'] as Map<String, dynamic>));
}

Map<String, dynamic> _$TodoCommentToJson(TodoComment instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'content': instance.content,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'todo': instance.todo
    };
