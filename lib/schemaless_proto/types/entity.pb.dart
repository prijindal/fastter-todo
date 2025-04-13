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

import '../google/protobuf/timestamp.pb.dart' as $5;
import 'entity.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'entity.pbenum.dart';

/// ListEntityTypesResponse
class ListEntityTypesResponse extends $pb.GeneratedMessage {
  factory ListEntityTypesResponse({
    $core.Iterable<$core.String>? entityType,
  }) {
    final $result = create();
    if (entityType != null) {
      $result.entityType.addAll(entityType);
    }
    return $result;
  }
  ListEntityTypesResponse._() : super();
  factory ListEntityTypesResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListEntityTypesResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListEntityTypesResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'types'), createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'EntityType', protoName: 'EntityType')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListEntityTypesResponse clone() => ListEntityTypesResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListEntityTypesResponse copyWith(void Function(ListEntityTypesResponse) updates) => super.copyWith((message) => updates(message as ListEntityTypesResponse)) as ListEntityTypesResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListEntityTypesResponse create() => ListEntityTypesResponse._();
  ListEntityTypesResponse createEmptyInstance() => create();
  static $pb.PbList<ListEntityTypesResponse> createRepeated() => $pb.PbList<ListEntityTypesResponse>();
  @$core.pragma('dart2js:noInline')
  static ListEntityTypesResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListEntityTypesResponse>(create);
  static ListEntityTypesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get entityType => $_getList(0);
}

class EntityHistoryRequestOrder extends $pb.GeneratedMessage {
  factory EntityHistoryRequestOrder({
    EntityHistoryOrderField? field_1,
    EntityHistoryOrderValue? value,
  }) {
    final $result = create();
    if (field_1 != null) {
      $result.field_1 = field_1;
    }
    if (value != null) {
      $result.value = value;
    }
    return $result;
  }
  EntityHistoryRequestOrder._() : super();
  factory EntityHistoryRequestOrder.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory EntityHistoryRequestOrder.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'EntityHistoryRequestOrder', package: const $pb.PackageName(_omitMessageNames ? '' : 'types'), createEmptyInstance: create)
    ..e<EntityHistoryOrderField>(1, _omitFieldNames ? '' : 'Field', $pb.PbFieldType.OE, protoName: 'Field', defaultOrMaker: EntityHistoryOrderField.CreatedAt, valueOf: EntityHistoryOrderField.valueOf, enumValues: EntityHistoryOrderField.values)
    ..e<EntityHistoryOrderValue>(2, _omitFieldNames ? '' : 'Value', $pb.PbFieldType.OE, protoName: 'Value', defaultOrMaker: EntityHistoryOrderValue.ASC, valueOf: EntityHistoryOrderValue.valueOf, enumValues: EntityHistoryOrderValue.values)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  EntityHistoryRequestOrder clone() => EntityHistoryRequestOrder()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  EntityHistoryRequestOrder copyWith(void Function(EntityHistoryRequestOrder) updates) => super.copyWith((message) => updates(message as EntityHistoryRequestOrder)) as EntityHistoryRequestOrder;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EntityHistoryRequestOrder create() => EntityHistoryRequestOrder._();
  EntityHistoryRequestOrder createEmptyInstance() => create();
  static $pb.PbList<EntityHistoryRequestOrder> createRepeated() => $pb.PbList<EntityHistoryRequestOrder>();
  @$core.pragma('dart2js:noInline')
  static EntityHistoryRequestOrder getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EntityHistoryRequestOrder>(create);
  static EntityHistoryRequestOrder? _defaultInstance;

  @$pb.TagNumber(1)
  EntityHistoryOrderField get field_1 => $_getN(0);
  @$pb.TagNumber(1)
  set field_1(EntityHistoryOrderField v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasField_1() => $_has(0);
  @$pb.TagNumber(1)
  void clearField_1() => $_clearField(1);

  @$pb.TagNumber(2)
  EntityHistoryOrderValue get value => $_getN(1);
  @$pb.TagNumber(2)
  set value(EntityHistoryOrderValue v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearValue() => $_clearField(2);
}

class EntityHistoryRequestDateParam extends $pb.GeneratedMessage {
  factory EntityHistoryRequestDateParam({
    $5.Timestamp? gte,
    $5.Timestamp? lte,
  }) {
    final $result = create();
    if (gte != null) {
      $result.gte = gte;
    }
    if (lte != null) {
      $result.lte = lte;
    }
    return $result;
  }
  EntityHistoryRequestDateParam._() : super();
  factory EntityHistoryRequestDateParam.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory EntityHistoryRequestDateParam.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'EntityHistoryRequestDateParam', package: const $pb.PackageName(_omitMessageNames ? '' : 'types'), createEmptyInstance: create)
    ..aOM<$5.Timestamp>(1, _omitFieldNames ? '' : 'gte', subBuilder: $5.Timestamp.create)
    ..aOM<$5.Timestamp>(2, _omitFieldNames ? '' : 'lte', subBuilder: $5.Timestamp.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  EntityHistoryRequestDateParam clone() => EntityHistoryRequestDateParam()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  EntityHistoryRequestDateParam copyWith(void Function(EntityHistoryRequestDateParam) updates) => super.copyWith((message) => updates(message as EntityHistoryRequestDateParam)) as EntityHistoryRequestDateParam;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EntityHistoryRequestDateParam create() => EntityHistoryRequestDateParam._();
  EntityHistoryRequestDateParam createEmptyInstance() => create();
  static $pb.PbList<EntityHistoryRequestDateParam> createRepeated() => $pb.PbList<EntityHistoryRequestDateParam>();
  @$core.pragma('dart2js:noInline')
  static EntityHistoryRequestDateParam getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EntityHistoryRequestDateParam>(create);
  static EntityHistoryRequestDateParam? _defaultInstance;

  @$pb.TagNumber(1)
  $5.Timestamp get gte => $_getN(0);
  @$pb.TagNumber(1)
  set gte($5.Timestamp v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasGte() => $_has(0);
  @$pb.TagNumber(1)
  void clearGte() => $_clearField(1);
  @$pb.TagNumber(1)
  $5.Timestamp ensureGte() => $_ensure(0);

  @$pb.TagNumber(2)
  $5.Timestamp get lte => $_getN(1);
  @$pb.TagNumber(2)
  set lte($5.Timestamp v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasLte() => $_has(1);
  @$pb.TagNumber(2)
  void clearLte() => $_clearField(2);
  @$pb.TagNumber(2)
  $5.Timestamp ensureLte() => $_ensure(1);
}

class EntityHistoryRequestHostIDParam extends $pb.GeneratedMessage {
  factory EntityHistoryRequestHostIDParam({
    $core.String? eq,
    $core.String? neq,
  }) {
    final $result = create();
    if (eq != null) {
      $result.eq = eq;
    }
    if (neq != null) {
      $result.neq = neq;
    }
    return $result;
  }
  EntityHistoryRequestHostIDParam._() : super();
  factory EntityHistoryRequestHostIDParam.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory EntityHistoryRequestHostIDParam.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'EntityHistoryRequestHostIDParam', package: const $pb.PackageName(_omitMessageNames ? '' : 'types'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'eq')
    ..aOS(2, _omitFieldNames ? '' : 'neq')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  EntityHistoryRequestHostIDParam clone() => EntityHistoryRequestHostIDParam()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  EntityHistoryRequestHostIDParam copyWith(void Function(EntityHistoryRequestHostIDParam) updates) => super.copyWith((message) => updates(message as EntityHistoryRequestHostIDParam)) as EntityHistoryRequestHostIDParam;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EntityHistoryRequestHostIDParam create() => EntityHistoryRequestHostIDParam._();
  EntityHistoryRequestHostIDParam createEmptyInstance() => create();
  static $pb.PbList<EntityHistoryRequestHostIDParam> createRepeated() => $pb.PbList<EntityHistoryRequestHostIDParam>();
  @$core.pragma('dart2js:noInline')
  static EntityHistoryRequestHostIDParam getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EntityHistoryRequestHostIDParam>(create);
  static EntityHistoryRequestHostIDParam? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get eq => $_getSZ(0);
  @$pb.TagNumber(1)
  set eq($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasEq() => $_has(0);
  @$pb.TagNumber(1)
  void clearEq() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get neq => $_getSZ(1);
  @$pb.TagNumber(2)
  set neq($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasNeq() => $_has(1);
  @$pb.TagNumber(2)
  void clearNeq() => $_clearField(2);
}

class EntityHistoryRequestEntityNameParam extends $pb.GeneratedMessage {
  factory EntityHistoryRequestEntityNameParam({
    $core.Iterable<$core.String>? in_1,
  }) {
    final $result = create();
    if (in_1 != null) {
      $result.in_1.addAll(in_1);
    }
    return $result;
  }
  EntityHistoryRequestEntityNameParam._() : super();
  factory EntityHistoryRequestEntityNameParam.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory EntityHistoryRequestEntityNameParam.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'EntityHistoryRequestEntityNameParam', package: const $pb.PackageName(_omitMessageNames ? '' : 'types'), createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'in')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  EntityHistoryRequestEntityNameParam clone() => EntityHistoryRequestEntityNameParam()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  EntityHistoryRequestEntityNameParam copyWith(void Function(EntityHistoryRequestEntityNameParam) updates) => super.copyWith((message) => updates(message as EntityHistoryRequestEntityNameParam)) as EntityHistoryRequestEntityNameParam;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EntityHistoryRequestEntityNameParam create() => EntityHistoryRequestEntityNameParam._();
  EntityHistoryRequestEntityNameParam createEmptyInstance() => create();
  static $pb.PbList<EntityHistoryRequestEntityNameParam> createRepeated() => $pb.PbList<EntityHistoryRequestEntityNameParam>();
  @$core.pragma('dart2js:noInline')
  static EntityHistoryRequestEntityNameParam getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EntityHistoryRequestEntityNameParam>(create);
  static EntityHistoryRequestEntityNameParam? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get in_1 => $_getList(0);
}

class EntityHistoryRequestParams extends $pb.GeneratedMessage {
  factory EntityHistoryRequestParams({
    EntityHistoryRequestDateParam? createdAt,
    EntityHistoryRequestHostIDParam? hostID,
    EntityHistoryRequestEntityNameParam? entityName,
  }) {
    final $result = create();
    if (createdAt != null) {
      $result.createdAt = createdAt;
    }
    if (hostID != null) {
      $result.hostID = hostID;
    }
    if (entityName != null) {
      $result.entityName = entityName;
    }
    return $result;
  }
  EntityHistoryRequestParams._() : super();
  factory EntityHistoryRequestParams.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory EntityHistoryRequestParams.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'EntityHistoryRequestParams', package: const $pb.PackageName(_omitMessageNames ? '' : 'types'), createEmptyInstance: create)
    ..aOM<EntityHistoryRequestDateParam>(1, _omitFieldNames ? '' : 'CreatedAt', protoName: 'CreatedAt', subBuilder: EntityHistoryRequestDateParam.create)
    ..aOM<EntityHistoryRequestHostIDParam>(2, _omitFieldNames ? '' : 'HostID', protoName: 'HostID', subBuilder: EntityHistoryRequestHostIDParam.create)
    ..aOM<EntityHistoryRequestEntityNameParam>(3, _omitFieldNames ? '' : 'EntityName', protoName: 'EntityName', subBuilder: EntityHistoryRequestEntityNameParam.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  EntityHistoryRequestParams clone() => EntityHistoryRequestParams()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  EntityHistoryRequestParams copyWith(void Function(EntityHistoryRequestParams) updates) => super.copyWith((message) => updates(message as EntityHistoryRequestParams)) as EntityHistoryRequestParams;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EntityHistoryRequestParams create() => EntityHistoryRequestParams._();
  EntityHistoryRequestParams createEmptyInstance() => create();
  static $pb.PbList<EntityHistoryRequestParams> createRepeated() => $pb.PbList<EntityHistoryRequestParams>();
  @$core.pragma('dart2js:noInline')
  static EntityHistoryRequestParams getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EntityHistoryRequestParams>(create);
  static EntityHistoryRequestParams? _defaultInstance;

  @$pb.TagNumber(1)
  EntityHistoryRequestDateParam get createdAt => $_getN(0);
  @$pb.TagNumber(1)
  set createdAt(EntityHistoryRequestDateParam v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCreatedAt() => $_has(0);
  @$pb.TagNumber(1)
  void clearCreatedAt() => $_clearField(1);
  @$pb.TagNumber(1)
  EntityHistoryRequestDateParam ensureCreatedAt() => $_ensure(0);

  @$pb.TagNumber(2)
  EntityHistoryRequestHostIDParam get hostID => $_getN(1);
  @$pb.TagNumber(2)
  set hostID(EntityHistoryRequestHostIDParam v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasHostID() => $_has(1);
  @$pb.TagNumber(2)
  void clearHostID() => $_clearField(2);
  @$pb.TagNumber(2)
  EntityHistoryRequestHostIDParam ensureHostID() => $_ensure(1);

  @$pb.TagNumber(3)
  EntityHistoryRequestEntityNameParam get entityName => $_getN(2);
  @$pb.TagNumber(3)
  set entityName(EntityHistoryRequestEntityNameParam v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasEntityName() => $_has(2);
  @$pb.TagNumber(3)
  void clearEntityName() => $_clearField(3);
  @$pb.TagNumber(3)
  EntityHistoryRequestEntityNameParam ensureEntityName() => $_ensure(2);
}

class SearchEntityHistoryRequest extends $pb.GeneratedMessage {
  factory SearchEntityHistoryRequest({
    EntityHistoryRequestParams? params,
    $core.Iterable<EntityHistoryRequestOrder>? order,
  }) {
    final $result = create();
    if (params != null) {
      $result.params = params;
    }
    if (order != null) {
      $result.order.addAll(order);
    }
    return $result;
  }
  SearchEntityHistoryRequest._() : super();
  factory SearchEntityHistoryRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SearchEntityHistoryRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SearchEntityHistoryRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'types'), createEmptyInstance: create)
    ..aOM<EntityHistoryRequestParams>(1, _omitFieldNames ? '' : 'Params', protoName: 'Params', subBuilder: EntityHistoryRequestParams.create)
    ..pc<EntityHistoryRequestOrder>(2, _omitFieldNames ? '' : 'Order', $pb.PbFieldType.PM, protoName: 'Order', subBuilder: EntityHistoryRequestOrder.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SearchEntityHistoryRequest clone() => SearchEntityHistoryRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SearchEntityHistoryRequest copyWith(void Function(SearchEntityHistoryRequest) updates) => super.copyWith((message) => updates(message as SearchEntityHistoryRequest)) as SearchEntityHistoryRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SearchEntityHistoryRequest create() => SearchEntityHistoryRequest._();
  SearchEntityHistoryRequest createEmptyInstance() => create();
  static $pb.PbList<SearchEntityHistoryRequest> createRepeated() => $pb.PbList<SearchEntityHistoryRequest>();
  @$core.pragma('dart2js:noInline')
  static SearchEntityHistoryRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SearchEntityHistoryRequest>(create);
  static SearchEntityHistoryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  EntityHistoryRequestParams get params => $_getN(0);
  @$pb.TagNumber(1)
  set params(EntityHistoryRequestParams v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasParams() => $_has(0);
  @$pb.TagNumber(1)
  void clearParams() => $_clearField(1);
  @$pb.TagNumber(1)
  EntityHistoryRequestParams ensureParams() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<EntityHistoryRequestOrder> get order => $_getList(1);
}

/// EntityHistory
class EntityHistory extends $pb.GeneratedMessage {
  factory EntityHistory({
    $core.String? iD,
    $core.String? entityName,
    $5.Timestamp? createdAt,
    $5.Timestamp? updatedAt,
    $core.String? hostID,
    $core.String? entityID,
    EntityAction? action,
    $core.List<$core.int>? payload,
  }) {
    final $result = create();
    if (iD != null) {
      $result.iD = iD;
    }
    if (entityName != null) {
      $result.entityName = entityName;
    }
    if (createdAt != null) {
      $result.createdAt = createdAt;
    }
    if (updatedAt != null) {
      $result.updatedAt = updatedAt;
    }
    if (hostID != null) {
      $result.hostID = hostID;
    }
    if (entityID != null) {
      $result.entityID = entityID;
    }
    if (action != null) {
      $result.action = action;
    }
    if (payload != null) {
      $result.payload = payload;
    }
    return $result;
  }
  EntityHistory._() : super();
  factory EntityHistory.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory EntityHistory.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'EntityHistory', package: const $pb.PackageName(_omitMessageNames ? '' : 'types'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'ID', protoName: 'ID')
    ..aOS(2, _omitFieldNames ? '' : 'EntityName', protoName: 'EntityName')
    ..aOM<$5.Timestamp>(3, _omitFieldNames ? '' : 'CreatedAt', protoName: 'CreatedAt', subBuilder: $5.Timestamp.create)
    ..aOM<$5.Timestamp>(4, _omitFieldNames ? '' : 'UpdatedAt', protoName: 'UpdatedAt', subBuilder: $5.Timestamp.create)
    ..aOS(5, _omitFieldNames ? '' : 'HostID', protoName: 'HostID')
    ..aOS(6, _omitFieldNames ? '' : 'EntityID', protoName: 'EntityID')
    ..e<EntityAction>(7, _omitFieldNames ? '' : 'Action', $pb.PbFieldType.OE, protoName: 'Action', defaultOrMaker: EntityAction.CREATE, valueOf: EntityAction.valueOf, enumValues: EntityAction.values)
    ..a<$core.List<$core.int>>(8, _omitFieldNames ? '' : 'Payload', $pb.PbFieldType.OY, protoName: 'Payload')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  EntityHistory clone() => EntityHistory()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  EntityHistory copyWith(void Function(EntityHistory) updates) => super.copyWith((message) => updates(message as EntityHistory)) as EntityHistory;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EntityHistory create() => EntityHistory._();
  EntityHistory createEmptyInstance() => create();
  static $pb.PbList<EntityHistory> createRepeated() => $pb.PbList<EntityHistory>();
  @$core.pragma('dart2js:noInline')
  static EntityHistory getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EntityHistory>(create);
  static EntityHistory? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get iD => $_getSZ(0);
  @$pb.TagNumber(1)
  set iD($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasID() => $_has(0);
  @$pb.TagNumber(1)
  void clearID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get entityName => $_getSZ(1);
  @$pb.TagNumber(2)
  set entityName($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasEntityName() => $_has(1);
  @$pb.TagNumber(2)
  void clearEntityName() => $_clearField(2);

  @$pb.TagNumber(3)
  $5.Timestamp get createdAt => $_getN(2);
  @$pb.TagNumber(3)
  set createdAt($5.Timestamp v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasCreatedAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearCreatedAt() => $_clearField(3);
  @$pb.TagNumber(3)
  $5.Timestamp ensureCreatedAt() => $_ensure(2);

  @$pb.TagNumber(4)
  $5.Timestamp get updatedAt => $_getN(3);
  @$pb.TagNumber(4)
  set updatedAt($5.Timestamp v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasUpdatedAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearUpdatedAt() => $_clearField(4);
  @$pb.TagNumber(4)
  $5.Timestamp ensureUpdatedAt() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.String get hostID => $_getSZ(4);
  @$pb.TagNumber(5)
  set hostID($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasHostID() => $_has(4);
  @$pb.TagNumber(5)
  void clearHostID() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get entityID => $_getSZ(5);
  @$pb.TagNumber(6)
  set entityID($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasEntityID() => $_has(5);
  @$pb.TagNumber(6)
  void clearEntityID() => $_clearField(6);

  @$pb.TagNumber(7)
  EntityAction get action => $_getN(6);
  @$pb.TagNumber(7)
  set action(EntityAction v) { $_setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasAction() => $_has(6);
  @$pb.TagNumber(7)
  void clearAction() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.List<$core.int> get payload => $_getN(7);
  @$pb.TagNumber(8)
  set payload($core.List<$core.int> v) { $_setBytes(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasPayload() => $_has(7);
  @$pb.TagNumber(8)
  void clearPayload() => $_clearField(8);
}

/// EntityActionRequest
class EntityActionRequest extends $pb.GeneratedMessage {
  factory EntityActionRequest({
    $core.String? hostID,
    $core.String? actionId,
    $core.String? entityName,
    EntityAction? action,
    $5.Timestamp? createdAt,
    $core.String? entityId,
    $core.List<$core.int>? payload,
    $core.String? requestID,
  }) {
    final $result = create();
    if (hostID != null) {
      $result.hostID = hostID;
    }
    if (actionId != null) {
      $result.actionId = actionId;
    }
    if (entityName != null) {
      $result.entityName = entityName;
    }
    if (action != null) {
      $result.action = action;
    }
    if (createdAt != null) {
      $result.createdAt = createdAt;
    }
    if (entityId != null) {
      $result.entityId = entityId;
    }
    if (payload != null) {
      $result.payload = payload;
    }
    if (requestID != null) {
      $result.requestID = requestID;
    }
    return $result;
  }
  EntityActionRequest._() : super();
  factory EntityActionRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory EntityActionRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'EntityActionRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'types'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'HostID', protoName: 'HostID')
    ..aOS(2, _omitFieldNames ? '' : 'ActionId', protoName: 'ActionId')
    ..aOS(3, _omitFieldNames ? '' : 'EntityName', protoName: 'EntityName')
    ..e<EntityAction>(4, _omitFieldNames ? '' : 'Action', $pb.PbFieldType.OE, protoName: 'Action', defaultOrMaker: EntityAction.CREATE, valueOf: EntityAction.valueOf, enumValues: EntityAction.values)
    ..aOM<$5.Timestamp>(5, _omitFieldNames ? '' : 'CreatedAt', protoName: 'CreatedAt', subBuilder: $5.Timestamp.create)
    ..aOS(6, _omitFieldNames ? '' : 'EntityId', protoName: 'EntityId')
    ..a<$core.List<$core.int>>(7, _omitFieldNames ? '' : 'Payload', $pb.PbFieldType.OY, protoName: 'Payload')
    ..aOS(8, _omitFieldNames ? '' : 'RequestID', protoName: 'RequestID')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  EntityActionRequest clone() => EntityActionRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  EntityActionRequest copyWith(void Function(EntityActionRequest) updates) => super.copyWith((message) => updates(message as EntityActionRequest)) as EntityActionRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EntityActionRequest create() => EntityActionRequest._();
  EntityActionRequest createEmptyInstance() => create();
  static $pb.PbList<EntityActionRequest> createRepeated() => $pb.PbList<EntityActionRequest>();
  @$core.pragma('dart2js:noInline')
  static EntityActionRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EntityActionRequest>(create);
  static EntityActionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get hostID => $_getSZ(0);
  @$pb.TagNumber(1)
  set hostID($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasHostID() => $_has(0);
  @$pb.TagNumber(1)
  void clearHostID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get actionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set actionId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasActionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearActionId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get entityName => $_getSZ(2);
  @$pb.TagNumber(3)
  set entityName($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasEntityName() => $_has(2);
  @$pb.TagNumber(3)
  void clearEntityName() => $_clearField(3);

  @$pb.TagNumber(4)
  EntityAction get action => $_getN(3);
  @$pb.TagNumber(4)
  set action(EntityAction v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasAction() => $_has(3);
  @$pb.TagNumber(4)
  void clearAction() => $_clearField(4);

  @$pb.TagNumber(5)
  $5.Timestamp get createdAt => $_getN(4);
  @$pb.TagNumber(5)
  set createdAt($5.Timestamp v) { $_setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasCreatedAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearCreatedAt() => $_clearField(5);
  @$pb.TagNumber(5)
  $5.Timestamp ensureCreatedAt() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.String get entityId => $_getSZ(5);
  @$pb.TagNumber(6)
  set entityId($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasEntityId() => $_has(5);
  @$pb.TagNumber(6)
  void clearEntityId() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.List<$core.int> get payload => $_getN(6);
  @$pb.TagNumber(7)
  set payload($core.List<$core.int> v) { $_setBytes(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasPayload() => $_has(6);
  @$pb.TagNumber(7)
  void clearPayload() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get requestID => $_getSZ(7);
  @$pb.TagNumber(8)
  set requestID($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasRequestID() => $_has(7);
  @$pb.TagNumber(8)
  void clearRequestID() => $_clearField(8);
}

class EntityActionResponse extends $pb.GeneratedMessage {
  factory EntityActionResponse({
    $core.String? requestID,
    EntityActionResponseStatus? status,
  }) {
    final $result = create();
    if (requestID != null) {
      $result.requestID = requestID;
    }
    if (status != null) {
      $result.status = status;
    }
    return $result;
  }
  EntityActionResponse._() : super();
  factory EntityActionResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory EntityActionResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'EntityActionResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'types'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'RequestID', protoName: 'RequestID')
    ..e<EntityActionResponseStatus>(2, _omitFieldNames ? '' : 'Status', $pb.PbFieldType.OE, protoName: 'Status', defaultOrMaker: EntityActionResponseStatus.Success, valueOf: EntityActionResponseStatus.valueOf, enumValues: EntityActionResponseStatus.values)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  EntityActionResponse clone() => EntityActionResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  EntityActionResponse copyWith(void Function(EntityActionResponse) updates) => super.copyWith((message) => updates(message as EntityActionResponse)) as EntityActionResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EntityActionResponse create() => EntityActionResponse._();
  EntityActionResponse createEmptyInstance() => create();
  static $pb.PbList<EntityActionResponse> createRepeated() => $pb.PbList<EntityActionResponse>();
  @$core.pragma('dart2js:noInline')
  static EntityActionResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EntityActionResponse>(create);
  static EntityActionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get requestID => $_getSZ(0);
  @$pb.TagNumber(1)
  set requestID($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasRequestID() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequestID() => $_clearField(1);

  @$pb.TagNumber(2)
  EntityActionResponseStatus get status => $_getN(1);
  @$pb.TagNumber(2)
  set status(EntityActionResponseStatus v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
