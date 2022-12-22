// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todoreminder.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TodoReminder _$TodoReminderFromJson(Map<String, dynamic> json) => TodoReminder(
      id: json['_id'] as String?,
      title: json['title'] as String,
      time: DateTime.parse(json['time'] as String),
      completed: json['completed'] as bool,
      todo: Todo.fromJson(json['todo'] as Map<String, dynamic>),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$TodoReminderToJson(TodoReminder instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'title': instance.title,
      'time': instance.time.toIso8601String(),
      'completed': instance.completed,
      'todo': instance.todo,
    };
