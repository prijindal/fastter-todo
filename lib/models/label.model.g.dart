// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'label.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Label _$LabelFromJson(Map<String, dynamic> json) => Label(
      id: json['_id'] as String?,
      title: json['title'] as String,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$LabelToJson(Label instance) => <String, dynamic>{
      '_id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'title': instance.title,
    };
