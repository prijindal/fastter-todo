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

import '../../google/protobuf/timestamp.pb.dart' as $0;
import 'entity.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'entity.pbenum.dart';

class ListEntityTypesRequest extends $pb.GeneratedMessage {
  factory ListEntityTypesRequest() => create();

  ListEntityTypesRequest._();

  factory ListEntityTypesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListEntityTypesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListEntityTypesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'application_services.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListEntityTypesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListEntityTypesRequest copyWith(
          void Function(ListEntityTypesRequest) updates) =>
      super.copyWith((message) => updates(message as ListEntityTypesRequest))
          as ListEntityTypesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListEntityTypesRequest create() => ListEntityTypesRequest._();
  @$core.override
  ListEntityTypesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListEntityTypesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListEntityTypesRequest>(create);
  static ListEntityTypesRequest? _defaultInstance;
}

/// ListEntityTypesResponse
class ListEntityTypesResponse extends $pb.GeneratedMessage {
  factory ListEntityTypesResponse({
    $core.Iterable<$core.String>? entityType,
  }) {
    final result = create();
    if (entityType != null) result.entityType.addAll(entityType);
    return result;
  }

  ListEntityTypesResponse._();

  factory ListEntityTypesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListEntityTypesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListEntityTypesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'application_services.v1'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'entityType')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListEntityTypesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListEntityTypesResponse copyWith(
          void Function(ListEntityTypesResponse) updates) =>
      super.copyWith((message) => updates(message as ListEntityTypesResponse))
          as ListEntityTypesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListEntityTypesResponse create() => ListEntityTypesResponse._();
  @$core.override
  ListEntityTypesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListEntityTypesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListEntityTypesResponse>(create);
  static ListEntityTypesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get entityType => $_getList(0);
}

class EntityHistoryRequestOrder extends $pb.GeneratedMessage {
  factory EntityHistoryRequestOrder({
    $core.String? field_1,
    EntityHistoryOrderValue? value,
  }) {
    final result = create();
    if (field_1 != null) result.field_1 = field_1;
    if (value != null) result.value = value;
    return result;
  }

  EntityHistoryRequestOrder._();

  factory EntityHistoryRequestOrder.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EntityHistoryRequestOrder.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EntityHistoryRequestOrder',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'application_services.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'field')
    ..aE<EntityHistoryOrderValue>(2, _omitFieldNames ? '' : 'value',
        enumValues: EntityHistoryOrderValue.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EntityHistoryRequestOrder clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EntityHistoryRequestOrder copyWith(
          void Function(EntityHistoryRequestOrder) updates) =>
      super.copyWith((message) => updates(message as EntityHistoryRequestOrder))
          as EntityHistoryRequestOrder;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EntityHistoryRequestOrder create() => EntityHistoryRequestOrder._();
  @$core.override
  EntityHistoryRequestOrder createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EntityHistoryRequestOrder getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EntityHistoryRequestOrder>(create);
  static EntityHistoryRequestOrder? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get field_1 => $_getSZ(0);
  @$pb.TagNumber(1)
  set field_1($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasField_1() => $_has(0);
  @$pb.TagNumber(1)
  void clearField_1() => $_clearField(1);

  @$pb.TagNumber(2)
  EntityHistoryOrderValue get value => $_getN(1);
  @$pb.TagNumber(2)
  set value(EntityHistoryOrderValue value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearValue() => $_clearField(2);
}

class EntityHistoryRequestDateParam extends $pb.GeneratedMessage {
  factory EntityHistoryRequestDateParam({
    $0.Timestamp? gte,
    $0.Timestamp? lte,
  }) {
    final result = create();
    if (gte != null) result.gte = gte;
    if (lte != null) result.lte = lte;
    return result;
  }

  EntityHistoryRequestDateParam._();

  factory EntityHistoryRequestDateParam.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EntityHistoryRequestDateParam.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EntityHistoryRequestDateParam',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'application_services.v1'),
      createEmptyInstance: create)
    ..aOM<$0.Timestamp>(1, _omitFieldNames ? '' : 'gte',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'lte',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EntityHistoryRequestDateParam clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EntityHistoryRequestDateParam copyWith(
          void Function(EntityHistoryRequestDateParam) updates) =>
      super.copyWith(
              (message) => updates(message as EntityHistoryRequestDateParam))
          as EntityHistoryRequestDateParam;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EntityHistoryRequestDateParam create() =>
      EntityHistoryRequestDateParam._();
  @$core.override
  EntityHistoryRequestDateParam createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EntityHistoryRequestDateParam getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EntityHistoryRequestDateParam>(create);
  static EntityHistoryRequestDateParam? _defaultInstance;

  @$pb.TagNumber(1)
  $0.Timestamp get gte => $_getN(0);
  @$pb.TagNumber(1)
  set gte($0.Timestamp value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasGte() => $_has(0);
  @$pb.TagNumber(1)
  void clearGte() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.Timestamp ensureGte() => $_ensure(0);

  @$pb.TagNumber(2)
  $0.Timestamp get lte => $_getN(1);
  @$pb.TagNumber(2)
  set lte($0.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasLte() => $_has(1);
  @$pb.TagNumber(2)
  void clearLte() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Timestamp ensureLte() => $_ensure(1);
}

class EntityHistoryRequestStringParam extends $pb.GeneratedMessage {
  factory EntityHistoryRequestStringParam({
    $core.String? eq,
    $core.String? neq,
    $core.Iterable<$core.String>? in_3,
  }) {
    final result = create();
    if (eq != null) result.eq = eq;
    if (neq != null) result.neq = neq;
    if (in_3 != null) result.in_3.addAll(in_3);
    return result;
  }

  EntityHistoryRequestStringParam._();

  factory EntityHistoryRequestStringParam.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EntityHistoryRequestStringParam.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EntityHistoryRequestStringParam',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'application_services.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'eq')
    ..aOS(2, _omitFieldNames ? '' : 'neq')
    ..pPS(3, _omitFieldNames ? '' : 'in')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EntityHistoryRequestStringParam clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EntityHistoryRequestStringParam copyWith(
          void Function(EntityHistoryRequestStringParam) updates) =>
      super.copyWith(
              (message) => updates(message as EntityHistoryRequestStringParam))
          as EntityHistoryRequestStringParam;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EntityHistoryRequestStringParam create() =>
      EntityHistoryRequestStringParam._();
  @$core.override
  EntityHistoryRequestStringParam createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EntityHistoryRequestStringParam getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EntityHistoryRequestStringParam>(
          create);
  static EntityHistoryRequestStringParam? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get eq => $_getSZ(0);
  @$pb.TagNumber(1)
  set eq($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEq() => $_has(0);
  @$pb.TagNumber(1)
  void clearEq() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get neq => $_getSZ(1);
  @$pb.TagNumber(2)
  set neq($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNeq() => $_has(1);
  @$pb.TagNumber(2)
  void clearNeq() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get in_3 => $_getList(2);
}

enum EntityHistoryRequestParam_Params { stringParams, dataParams, notSet }

class EntityHistoryRequestParam extends $pb.GeneratedMessage {
  factory EntityHistoryRequestParam({
    $core.String? field_1,
    EntityHistoryRequestStringParam? stringParams,
    EntityHistoryRequestDateParam? dataParams,
  }) {
    final result = create();
    if (field_1 != null) result.field_1 = field_1;
    if (stringParams != null) result.stringParams = stringParams;
    if (dataParams != null) result.dataParams = dataParams;
    return result;
  }

  EntityHistoryRequestParam._();

  factory EntityHistoryRequestParam.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EntityHistoryRequestParam.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, EntityHistoryRequestParam_Params>
      _EntityHistoryRequestParam_ParamsByTag = {
    2: EntityHistoryRequestParam_Params.stringParams,
    3: EntityHistoryRequestParam_Params.dataParams,
    0: EntityHistoryRequestParam_Params.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EntityHistoryRequestParam',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'application_services.v1'),
      createEmptyInstance: create)
    ..oo(0, [2, 3])
    ..aOS(1, _omitFieldNames ? '' : 'field')
    ..aOM<EntityHistoryRequestStringParam>(
        2, _omitFieldNames ? '' : 'stringParams',
        subBuilder: EntityHistoryRequestStringParam.create)
    ..aOM<EntityHistoryRequestDateParam>(3, _omitFieldNames ? '' : 'dataParams',
        subBuilder: EntityHistoryRequestDateParam.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EntityHistoryRequestParam clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EntityHistoryRequestParam copyWith(
          void Function(EntityHistoryRequestParam) updates) =>
      super.copyWith((message) => updates(message as EntityHistoryRequestParam))
          as EntityHistoryRequestParam;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EntityHistoryRequestParam create() => EntityHistoryRequestParam._();
  @$core.override
  EntityHistoryRequestParam createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EntityHistoryRequestParam getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EntityHistoryRequestParam>(create);
  static EntityHistoryRequestParam? _defaultInstance;

  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  EntityHistoryRequestParam_Params whichParams() =>
      _EntityHistoryRequestParam_ParamsByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  void clearParams() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get field_1 => $_getSZ(0);
  @$pb.TagNumber(1)
  set field_1($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasField_1() => $_has(0);
  @$pb.TagNumber(1)
  void clearField_1() => $_clearField(1);

  @$pb.TagNumber(2)
  EntityHistoryRequestStringParam get stringParams => $_getN(1);
  @$pb.TagNumber(2)
  set stringParams(EntityHistoryRequestStringParam value) =>
      $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStringParams() => $_has(1);
  @$pb.TagNumber(2)
  void clearStringParams() => $_clearField(2);
  @$pb.TagNumber(2)
  EntityHistoryRequestStringParam ensureStringParams() => $_ensure(1);

  @$pb.TagNumber(3)
  EntityHistoryRequestDateParam get dataParams => $_getN(2);
  @$pb.TagNumber(3)
  set dataParams(EntityHistoryRequestDateParam value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasDataParams() => $_has(2);
  @$pb.TagNumber(3)
  void clearDataParams() => $_clearField(3);
  @$pb.TagNumber(3)
  EntityHistoryRequestDateParam ensureDataParams() => $_ensure(2);
}

class StreamEntityHistoryRequest extends $pb.GeneratedMessage {
  factory StreamEntityHistoryRequest({
    $core.String? entityName,
    $core.Iterable<EntityHistoryRequestParam>? params,
    $core.Iterable<EntityHistoryRequestOrder>? order,
  }) {
    final result = create();
    if (entityName != null) result.entityName = entityName;
    if (params != null) result.params.addAll(params);
    if (order != null) result.order.addAll(order);
    return result;
  }

  StreamEntityHistoryRequest._();

  factory StreamEntityHistoryRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StreamEntityHistoryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StreamEntityHistoryRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'application_services.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'entityName')
    ..pPM<EntityHistoryRequestParam>(2, _omitFieldNames ? '' : 'params',
        subBuilder: EntityHistoryRequestParam.create)
    ..pPM<EntityHistoryRequestOrder>(3, _omitFieldNames ? '' : 'order',
        subBuilder: EntityHistoryRequestOrder.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StreamEntityHistoryRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StreamEntityHistoryRequest copyWith(
          void Function(StreamEntityHistoryRequest) updates) =>
      super.copyWith(
              (message) => updates(message as StreamEntityHistoryRequest))
          as StreamEntityHistoryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StreamEntityHistoryRequest create() => StreamEntityHistoryRequest._();
  @$core.override
  StreamEntityHistoryRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StreamEntityHistoryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StreamEntityHistoryRequest>(create);
  static StreamEntityHistoryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get entityName => $_getSZ(0);
  @$pb.TagNumber(1)
  set entityName($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEntityName() => $_has(0);
  @$pb.TagNumber(1)
  void clearEntityName() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<EntityHistoryRequestParam> get params => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<EntityHistoryRequestOrder> get order => $_getList(2);
}

class Entity extends $pb.GeneratedMessage {
  factory Entity({
    $core.String? id,
    $core.String? entityName,
    $0.Timestamp? createdAt,
    $0.Timestamp? updatedAt,
    $0.Timestamp? deletedAt,
    $core.List<$core.int>? payload,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (entityName != null) result.entityName = entityName;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    if (deletedAt != null) result.deletedAt = deletedAt;
    if (payload != null) result.payload = payload;
    return result;
  }

  Entity._();

  factory Entity.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Entity.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Entity',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'application_services.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'entityName')
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'deletedAt',
        subBuilder: $0.Timestamp.create)
    ..a<$core.List<$core.int>>(
        6, _omitFieldNames ? '' : 'payload', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Entity clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Entity copyWith(void Function(Entity) updates) =>
      super.copyWith((message) => updates(message as Entity)) as Entity;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Entity create() => Entity._();
  @$core.override
  Entity createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Entity getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Entity>(create);
  static Entity? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get entityName => $_getSZ(1);
  @$pb.TagNumber(2)
  set entityName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEntityName() => $_has(1);
  @$pb.TagNumber(2)
  void clearEntityName() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.Timestamp get createdAt => $_getN(2);
  @$pb.TagNumber(3)
  set createdAt($0.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasCreatedAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearCreatedAt() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensureCreatedAt() => $_ensure(2);

  @$pb.TagNumber(4)
  $0.Timestamp get updatedAt => $_getN(3);
  @$pb.TagNumber(4)
  set updatedAt($0.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasUpdatedAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearUpdatedAt() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensureUpdatedAt() => $_ensure(3);

  @$pb.TagNumber(5)
  $0.Timestamp get deletedAt => $_getN(4);
  @$pb.TagNumber(5)
  set deletedAt($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasDeletedAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearDeletedAt() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureDeletedAt() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.List<$core.int> get payload => $_getN(5);
  @$pb.TagNumber(6)
  set payload($core.List<$core.int> value) => $_setBytes(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPayload() => $_has(5);
  @$pb.TagNumber(6)
  void clearPayload() => $_clearField(6);
}

class StreamEntityHistoryResponse extends $pb.GeneratedMessage {
  factory StreamEntityHistoryResponse({
    Entity? entity,
  }) {
    final result = create();
    if (entity != null) result.entity = entity;
    return result;
  }

  StreamEntityHistoryResponse._();

  factory StreamEntityHistoryResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StreamEntityHistoryResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StreamEntityHistoryResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'application_services.v1'),
      createEmptyInstance: create)
    ..aOM<Entity>(1, _omitFieldNames ? '' : 'entity', subBuilder: Entity.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StreamEntityHistoryResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StreamEntityHistoryResponse copyWith(
          void Function(StreamEntityHistoryResponse) updates) =>
      super.copyWith(
              (message) => updates(message as StreamEntityHistoryResponse))
          as StreamEntityHistoryResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StreamEntityHistoryResponse create() =>
      StreamEntityHistoryResponse._();
  @$core.override
  StreamEntityHistoryResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StreamEntityHistoryResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StreamEntityHistoryResponse>(create);
  static StreamEntityHistoryResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Entity get entity => $_getN(0);
  @$pb.TagNumber(1)
  set entity(Entity value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEntity() => $_has(0);
  @$pb.TagNumber(1)
  void clearEntity() => $_clearField(1);
  @$pb.TagNumber(1)
  Entity ensureEntity() => $_ensure(0);
}

/// EntityActionRequest
class EntityActionRequest extends $pb.GeneratedMessage {
  factory EntityActionRequest({
    $core.String? entityName,
    EntityAction? action,
    $0.Timestamp? timestamp,
    $core.String? entityId,
    $core.List<$core.int>? payload,
    $core.String? requestId,
  }) {
    final result = create();
    if (entityName != null) result.entityName = entityName;
    if (action != null) result.action = action;
    if (timestamp != null) result.timestamp = timestamp;
    if (entityId != null) result.entityId = entityId;
    if (payload != null) result.payload = payload;
    if (requestId != null) result.requestId = requestId;
    return result;
  }

  EntityActionRequest._();

  factory EntityActionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EntityActionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EntityActionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'application_services.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'entityName')
    ..aE<EntityAction>(2, _omitFieldNames ? '' : 'action',
        enumValues: EntityAction.values)
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'timestamp',
        subBuilder: $0.Timestamp.create)
    ..aOS(4, _omitFieldNames ? '' : 'entityId')
    ..a<$core.List<$core.int>>(
        5, _omitFieldNames ? '' : 'payload', $pb.PbFieldType.OY)
    ..aOS(6, _omitFieldNames ? '' : 'requestId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EntityActionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EntityActionRequest copyWith(void Function(EntityActionRequest) updates) =>
      super.copyWith((message) => updates(message as EntityActionRequest))
          as EntityActionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EntityActionRequest create() => EntityActionRequest._();
  @$core.override
  EntityActionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EntityActionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EntityActionRequest>(create);
  static EntityActionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get entityName => $_getSZ(0);
  @$pb.TagNumber(1)
  set entityName($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEntityName() => $_has(0);
  @$pb.TagNumber(1)
  void clearEntityName() => $_clearField(1);

  @$pb.TagNumber(2)
  EntityAction get action => $_getN(1);
  @$pb.TagNumber(2)
  set action(EntityAction value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasAction() => $_has(1);
  @$pb.TagNumber(2)
  void clearAction() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.Timestamp get timestamp => $_getN(2);
  @$pb.TagNumber(3)
  set timestamp($0.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasTimestamp() => $_has(2);
  @$pb.TagNumber(3)
  void clearTimestamp() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensureTimestamp() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get entityId => $_getSZ(3);
  @$pb.TagNumber(4)
  set entityId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasEntityId() => $_has(3);
  @$pb.TagNumber(4)
  void clearEntityId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.List<$core.int> get payload => $_getN(4);
  @$pb.TagNumber(5)
  set payload($core.List<$core.int> value) => $_setBytes(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPayload() => $_has(4);
  @$pb.TagNumber(5)
  void clearPayload() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get requestId => $_getSZ(5);
  @$pb.TagNumber(6)
  set requestId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRequestId() => $_has(5);
  @$pb.TagNumber(6)
  void clearRequestId() => $_clearField(6);
}

class EntityActionResponse extends $pb.GeneratedMessage {
  factory EntityActionResponse({
    $core.String? requestId,
  }) {
    final result = create();
    if (requestId != null) result.requestId = requestId;
    return result;
  }

  EntityActionResponse._();

  factory EntityActionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EntityActionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EntityActionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'application_services.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'requestId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EntityActionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EntityActionResponse copyWith(void Function(EntityActionResponse) updates) =>
      super.copyWith((message) => updates(message as EntityActionResponse))
          as EntityActionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EntityActionResponse create() => EntityActionResponse._();
  @$core.override
  EntityActionResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EntityActionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EntityActionResponse>(create);
  static EntityActionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get requestId => $_getSZ(0);
  @$pb.TagNumber(1)
  set requestId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRequestId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequestId() => $_clearField(1);
}

class StreamEntityActionRequest extends $pb.GeneratedMessage {
  factory StreamEntityActionRequest({
    EntityActionRequest? action,
  }) {
    final result = create();
    if (action != null) result.action = action;
    return result;
  }

  StreamEntityActionRequest._();

  factory StreamEntityActionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StreamEntityActionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StreamEntityActionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'application_services.v1'),
      createEmptyInstance: create)
    ..aOM<EntityActionRequest>(1, _omitFieldNames ? '' : 'action',
        subBuilder: EntityActionRequest.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StreamEntityActionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StreamEntityActionRequest copyWith(
          void Function(StreamEntityActionRequest) updates) =>
      super.copyWith((message) => updates(message as StreamEntityActionRequest))
          as StreamEntityActionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StreamEntityActionRequest create() => StreamEntityActionRequest._();
  @$core.override
  StreamEntityActionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StreamEntityActionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StreamEntityActionRequest>(create);
  static StreamEntityActionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  EntityActionRequest get action => $_getN(0);
  @$pb.TagNumber(1)
  set action(EntityActionRequest value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAction() => $_has(0);
  @$pb.TagNumber(1)
  void clearAction() => $_clearField(1);
  @$pb.TagNumber(1)
  EntityActionRequest ensureAction() => $_ensure(0);
}

class StreamEntityActionResponse extends $pb.GeneratedMessage {
  factory StreamEntityActionResponse({
    $core.String? requestId,
  }) {
    final result = create();
    if (requestId != null) result.requestId = requestId;
    return result;
  }

  StreamEntityActionResponse._();

  factory StreamEntityActionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StreamEntityActionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StreamEntityActionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'application_services.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'requestId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StreamEntityActionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StreamEntityActionResponse copyWith(
          void Function(StreamEntityActionResponse) updates) =>
      super.copyWith(
              (message) => updates(message as StreamEntityActionResponse))
          as StreamEntityActionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StreamEntityActionResponse create() => StreamEntityActionResponse._();
  @$core.override
  StreamEntityActionResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StreamEntityActionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StreamEntityActionResponse>(create);
  static StreamEntityActionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get requestId => $_getSZ(0);
  @$pb.TagNumber(1)
  set requestId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRequestId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequestId() => $_clearField(1);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
