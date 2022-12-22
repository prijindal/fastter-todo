// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Notification _$NotificationFromJson(Map<String, dynamic> json) => Notification(
      id: json['_id'] as String?,
      title: json['title'] as String,
      body: json['body'] as String,
      read: json['read'] as bool,
      data: json['data'] as Map<String, dynamic>,
      route: json['route'] as String,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$NotificationToJson(Notification instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'title': instance.title,
      'body': instance.body,
      'read': instance.read,
      'data': instance.data,
      'route': instance.route,
    };
