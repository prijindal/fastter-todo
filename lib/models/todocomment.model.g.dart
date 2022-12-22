// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todocomment.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TodoComment _$TodoCommentFromJson(Map<String, dynamic> json) => TodoComment(
      id: json['_id'] as String?,
      content: json['content'] as String,
      type: $enumDecode(_$TodoCommentTypeEnumMap, json['type']),
      todo: Todo.fromJson(json['todo'] as Map<String, dynamic>),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$TodoCommentToJson(TodoComment instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'type': _$TodoCommentTypeEnumMap[instance.type]!,
      'content': instance.content,
      'todo': instance.todo,
    };

const _$TodoCommentTypeEnumMap = {
  TodoCommentType.image: 'image',
  TodoCommentType.text: 'text',
  TodoCommentType.video: 'video',
};
