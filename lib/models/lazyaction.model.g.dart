// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lazyaction.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LazyAction _$LazyActionFromJson(Map<String, dynamic> json) => LazyAction(
      json['uuid'] as String,
      $enumDecode(_$ActionTypeEnumMap, json['actionType']),
      _typeFromJson(json['type'] as String),
      actionid: json['actionid'] as String?,
      action: json['action'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$LazyActionToJson(LazyAction instance) =>
    <String, dynamic>{
      'action': instance.action,
      'actionid': instance.actionid,
      'actionType': _$ActionTypeEnumMap[instance.actionType]!,
      'type': _typeToJson(instance.type),
      'uuid': instance.uuid,
    };

const _$ActionTypeEnumMap = {
  ActionType.add: 'add',
  ActionType.delete: 'delete',
  ActionType.update: 'update',
};
