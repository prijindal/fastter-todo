// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Todo _$TodoFromJson(Map<String, dynamic> json) {
  return Todo(
      id: json['_id'] as String,
      title: json['title'] as String,
      completed: json['completed'] as bool,
      dueDate: json['dueDate'] == null
          ? null
          : dateFromJson(json['dueDate'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : dateFromJson(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : dateFromJson(json['updatedAt'] as String),
      project: json['project'] == null
          ? null
          : Project.fromJson(json['project'] as Map<String, dynamic>));
}

Map<String, dynamic> _$TodoToJson(Todo instance) => <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'completed': instance.completed,
      'dueDate': instance.dueDate?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'project': instance.project
    };