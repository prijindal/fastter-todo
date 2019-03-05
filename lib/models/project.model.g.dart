// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Project _$ProjectFromJson(Map<String, dynamic> json) {
  return Project(
      id: json['_id'] as String,
      title: json['title'] as String,
      color: json['color'] as String,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String));
}

Map<String, dynamic> _$ProjectToJson(Project instance) => <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'color': instance.color,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String()
    };
