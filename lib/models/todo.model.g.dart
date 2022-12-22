// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Todo _$TodoFromJson(Map<String, dynamic> json) => Todo(
      id: json['_id'] as String?,
      title: json['title'] as String,
      completed: json['completed'] as bool? ?? false,
      priority: json['priority'] as int?,
      dueDate: json['dueDate'] == null
          ? null
          : DateTime.parse(json['dueDate'] as String),
      encrypted: json['encrypted'] as bool? ?? false,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      parent: json['parent'] == null
          ? null
          : Todo.fromJson(json['parent'] as Map<String, dynamic>),
      project: json['project'] == null
          ? null
          : Project.fromJson(json['project'] as Map<String, dynamic>),
      labels: (json['labels'] as List<dynamic>?)
              ?.map((e) => Label.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Label>[],
    );

Map<String, dynamic> _$TodoToJson(Todo instance) => <String, dynamic>{
      '_id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'title': instance.title,
      'priority': instance.priority,
      'completed': instance.completed,
      'encrypted': instance.encrypted,
      'dueDate': instance.dueDate.toIso8601String(),
      'parent': instance.parent,
      'project': instance.project,
      'labels': instance.labels,
    };
