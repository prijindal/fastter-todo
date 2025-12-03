// This is a generated file - do not edit.
//
// Generated from application_services/v1/entity.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// SearchEntityHistoryRequest
class EntityHistoryOrderField extends $pb.ProtobufEnum {
  static const EntityHistoryOrderField ENTITY_HISTORY_ORDER_FIELD_UNSPECIFIED =
      EntityHistoryOrderField._(
          0, _omitEnumNames ? '' : 'ENTITY_HISTORY_ORDER_FIELD_UNSPECIFIED');
  static const EntityHistoryOrderField ENTITY_HISTORY_ORDER_FIELD_CREATED_AT =
      EntityHistoryOrderField._(
          1, _omitEnumNames ? '' : 'ENTITY_HISTORY_ORDER_FIELD_CREATED_AT');
  static const EntityHistoryOrderField ENTITY_HISTORY_ORDER_FIELD_UPDATED_AT =
      EntityHistoryOrderField._(
          2, _omitEnumNames ? '' : 'ENTITY_HISTORY_ORDER_FIELD_UPDATED_AT');

  static const $core.List<EntityHistoryOrderField> values =
      <EntityHistoryOrderField>[
    ENTITY_HISTORY_ORDER_FIELD_UNSPECIFIED,
    ENTITY_HISTORY_ORDER_FIELD_CREATED_AT,
    ENTITY_HISTORY_ORDER_FIELD_UPDATED_AT,
  ];

  static final $core.List<EntityHistoryOrderField?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static EntityHistoryOrderField? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const EntityHistoryOrderField._(super.value, super.name);
}

class EntityHistoryOrderValue extends $pb.ProtobufEnum {
  static const EntityHistoryOrderValue ENTITY_HISTORY_ORDER_VALUE_UNSPECIFIED =
      EntityHistoryOrderValue._(
          0, _omitEnumNames ? '' : 'ENTITY_HISTORY_ORDER_VALUE_UNSPECIFIED');
  static const EntityHistoryOrderValue ENTITY_HISTORY_ORDER_VALUE_ASC =
      EntityHistoryOrderValue._(
          1, _omitEnumNames ? '' : 'ENTITY_HISTORY_ORDER_VALUE_ASC');
  static const EntityHistoryOrderValue ENTITY_HISTORY_ORDER_VALUE_DESC =
      EntityHistoryOrderValue._(
          2, _omitEnumNames ? '' : 'ENTITY_HISTORY_ORDER_VALUE_DESC');

  static const $core.List<EntityHistoryOrderValue> values =
      <EntityHistoryOrderValue>[
    ENTITY_HISTORY_ORDER_VALUE_UNSPECIFIED,
    ENTITY_HISTORY_ORDER_VALUE_ASC,
    ENTITY_HISTORY_ORDER_VALUE_DESC,
  ];

  static final $core.List<EntityHistoryOrderValue?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static EntityHistoryOrderValue? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const EntityHistoryOrderValue._(super.value, super.name);
}

class EntityAction extends $pb.ProtobufEnum {
  static const EntityAction ENTITY_ACTION_UNSPECIFIED =
      EntityAction._(0, _omitEnumNames ? '' : 'ENTITY_ACTION_UNSPECIFIED');
  static const EntityAction ENTITY_ACTION_CREATE =
      EntityAction._(1, _omitEnumNames ? '' : 'ENTITY_ACTION_CREATE');
  static const EntityAction ENTITY_ACTION_UPDATE =
      EntityAction._(2, _omitEnumNames ? '' : 'ENTITY_ACTION_UPDATE');
  static const EntityAction ENTITY_ACTION_DELETE =
      EntityAction._(3, _omitEnumNames ? '' : 'ENTITY_ACTION_DELETE');

  static const $core.List<EntityAction> values = <EntityAction>[
    ENTITY_ACTION_UNSPECIFIED,
    ENTITY_ACTION_CREATE,
    ENTITY_ACTION_UPDATE,
    ENTITY_ACTION_DELETE,
  ];

  static final $core.List<EntityAction?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static EntityAction? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const EntityAction._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
