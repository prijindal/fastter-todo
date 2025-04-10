//
//  Generated code. Do not modify.
//  source: types/entity.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// SearchEntityHistoryRequest
class EntityHistoryOrderField extends $pb.ProtobufEnum {
  static const EntityHistoryOrderField CreatedAt = EntityHistoryOrderField._(0, _omitEnumNames ? '' : 'CreatedAt');
  static const EntityHistoryOrderField UpdatedAt = EntityHistoryOrderField._(1, _omitEnumNames ? '' : 'UpdatedAt');

  static const $core.List<EntityHistoryOrderField> values = <EntityHistoryOrderField> [
    CreatedAt,
    UpdatedAt,
  ];

  static final $core.Map<$core.int, EntityHistoryOrderField> _byValue = $pb.ProtobufEnum.initByValue(values);
  static EntityHistoryOrderField? valueOf($core.int value) => _byValue[value];

  const EntityHistoryOrderField._(super.v, super.n);
}

class EntityHistoryOrderValue extends $pb.ProtobufEnum {
  static const EntityHistoryOrderValue ASC = EntityHistoryOrderValue._(0, _omitEnumNames ? '' : 'ASC');
  static const EntityHistoryOrderValue DESC = EntityHistoryOrderValue._(1, _omitEnumNames ? '' : 'DESC');

  static const $core.List<EntityHistoryOrderValue> values = <EntityHistoryOrderValue> [
    ASC,
    DESC,
  ];

  static final $core.Map<$core.int, EntityHistoryOrderValue> _byValue = $pb.ProtobufEnum.initByValue(values);
  static EntityHistoryOrderValue? valueOf($core.int value) => _byValue[value];

  const EntityHistoryOrderValue._(super.v, super.n);
}

class EntityAction extends $pb.ProtobufEnum {
  static const EntityAction CREATE = EntityAction._(0, _omitEnumNames ? '' : 'CREATE');
  static const EntityAction UPDATE = EntityAction._(1, _omitEnumNames ? '' : 'UPDATE');
  static const EntityAction DELETE = EntityAction._(2, _omitEnumNames ? '' : 'DELETE');

  static const $core.List<EntityAction> values = <EntityAction> [
    CREATE,
    UPDATE,
    DELETE,
  ];

  static final $core.Map<$core.int, EntityAction> _byValue = $pb.ProtobufEnum.initByValue(values);
  static EntityAction? valueOf($core.int value) => _byValue[value];

  const EntityAction._(super.v, super.n);
}

class EntityActionResponseStatus extends $pb.ProtobufEnum {
  static const EntityActionResponseStatus Success = EntityActionResponseStatus._(0, _omitEnumNames ? '' : 'Success');
  static const EntityActionResponseStatus Error = EntityActionResponseStatus._(1, _omitEnumNames ? '' : 'Error');

  static const $core.List<EntityActionResponseStatus> values = <EntityActionResponseStatus> [
    Success,
    Error,
  ];

  static final $core.Map<$core.int, EntityActionResponseStatus> _byValue = $pb.ProtobufEnum.initByValue(values);
  static EntityActionResponseStatus? valueOf($core.int value) => _byValue[value];

  const EntityActionResponseStatus._(super.v, super.n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
