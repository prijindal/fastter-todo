// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todocomment.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TodoComment _$TodoCommentFromJson(Map<String, dynamic> json) {
  return TodoComment(
      id: json['_id'] as String,
      content: json['content'] as String,
      type: _$enumDecodeNullable(_$TodoCommentTypeEnumMap, json['type']),
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
      'type': _$TodoCommentTypeEnumMap[instance.type],
      'content': instance.content,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'todo': instance.todo
    };

T _$enumDecode<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }
  return enumValues.entries
      .singleWhere((e) => e.value == source,
          orElse: () => throw ArgumentError(
              '`$source` is not one of the supported values: '
              '${enumValues.values.join(', ')}'))
      .key;
}

T _$enumDecodeNullable<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source);
}

const _$TodoCommentTypeEnumMap = <TodoCommentType, dynamic>{
  TodoCommentType.image: 'image',
  TodoCommentType.text: 'text'
};
