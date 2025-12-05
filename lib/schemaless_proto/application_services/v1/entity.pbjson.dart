// This is a generated file - do not edit.
//
// Generated from application_services/v1/entity.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use entityHistoryOrderValueDescriptor instead')
const EntityHistoryOrderValue$json = {
  '1': 'EntityHistoryOrderValue',
  '2': [
    {'1': 'ENTITY_HISTORY_ORDER_VALUE_UNSPECIFIED', '2': 0},
    {'1': 'ENTITY_HISTORY_ORDER_VALUE_ASC', '2': 1},
    {'1': 'ENTITY_HISTORY_ORDER_VALUE_DESC', '2': 2},
  ],
};

/// Descriptor for `EntityHistoryOrderValue`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List entityHistoryOrderValueDescriptor = $convert.base64Decode(
    'ChdFbnRpdHlIaXN0b3J5T3JkZXJWYWx1ZRIqCiZFTlRJVFlfSElTVE9SWV9PUkRFUl9WQUxVRV'
    '9VTlNQRUNJRklFRBAAEiIKHkVOVElUWV9ISVNUT1JZX09SREVSX1ZBTFVFX0FTQxABEiMKH0VO'
    'VElUWV9ISVNUT1JZX09SREVSX1ZBTFVFX0RFU0MQAg==');

@$core.Deprecated('Use entityActionDescriptor instead')
const EntityAction$json = {
  '1': 'EntityAction',
  '2': [
    {'1': 'ENTITY_ACTION_UNSPECIFIED', '2': 0},
    {'1': 'ENTITY_ACTION_CREATE', '2': 1},
    {'1': 'ENTITY_ACTION_UPDATE', '2': 2},
    {'1': 'ENTITY_ACTION_DELETE', '2': 3},
  ],
};

/// Descriptor for `EntityAction`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List entityActionDescriptor = $convert.base64Decode(
    'CgxFbnRpdHlBY3Rpb24SHQoZRU5USVRZX0FDVElPTl9VTlNQRUNJRklFRBAAEhgKFEVOVElUWV'
    '9BQ1RJT05fQ1JFQVRFEAESGAoURU5USVRZX0FDVElPTl9VUERBVEUQAhIYChRFTlRJVFlfQUNU'
    'SU9OX0RFTEVURRAD');

@$core.Deprecated('Use listEntityTypesRequestDescriptor instead')
const ListEntityTypesRequest$json = {
  '1': 'ListEntityTypesRequest',
};

/// Descriptor for `ListEntityTypesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listEntityTypesRequestDescriptor =
    $convert.base64Decode('ChZMaXN0RW50aXR5VHlwZXNSZXF1ZXN0');

@$core.Deprecated('Use listEntityTypesResponseDescriptor instead')
const ListEntityTypesResponse$json = {
  '1': 'ListEntityTypesResponse',
  '2': [
    {'1': 'entity_type', '3': 1, '4': 3, '5': 9, '8': {}, '10': 'entityType'},
  ],
};

/// Descriptor for `ListEntityTypesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listEntityTypesResponseDescriptor =
    $convert.base64Decode(
        'ChdMaXN0RW50aXR5VHlwZXNSZXNwb25zZRIvCgtlbnRpdHlfdHlwZRgBIAMoCUIOukgLkgEIIg'
        'ZyBBABGBRSCmVudGl0eVR5cGU=');

@$core.Deprecated('Use entityHistoryRequestOrderDescriptor instead')
const EntityHistoryRequestOrder$json = {
  '1': 'EntityHistoryRequestOrder',
  '2': [
    {'1': 'field', '3': 1, '4': 1, '5': 9, '10': 'field'},
    {
      '1': 'value',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.application_services.v1.EntityHistoryOrderValue',
      '10': 'value'
    },
  ],
};

/// Descriptor for `EntityHistoryRequestOrder`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List entityHistoryRequestOrderDescriptor = $convert.base64Decode(
    'ChlFbnRpdHlIaXN0b3J5UmVxdWVzdE9yZGVyEhQKBWZpZWxkGAEgASgJUgVmaWVsZBJGCgV2YW'
    'x1ZRgCIAEoDjIwLmFwcGxpY2F0aW9uX3NlcnZpY2VzLnYxLkVudGl0eUhpc3RvcnlPcmRlclZh'
    'bHVlUgV2YWx1ZQ==');

@$core.Deprecated('Use entityHistoryRequestDateParamDescriptor instead')
const EntityHistoryRequestDateParam$json = {
  '1': 'EntityHistoryRequestDateParam',
  '2': [
    {
      '1': 'gte',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'gte'
    },
    {
      '1': 'lte',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'lte'
    },
  ],
};

/// Descriptor for `EntityHistoryRequestDateParam`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List entityHistoryRequestDateParamDescriptor =
    $convert.base64Decode(
        'Ch1FbnRpdHlIaXN0b3J5UmVxdWVzdERhdGVQYXJhbRIsCgNndGUYASABKAsyGi5nb29nbGUucH'
        'JvdG9idWYuVGltZXN0YW1wUgNndGUSLAoDbHRlGAIgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRp'
        'bWVzdGFtcFIDbHRl');

@$core.Deprecated('Use entityHistoryRequestStringParamDescriptor instead')
const EntityHistoryRequestStringParam$json = {
  '1': 'EntityHistoryRequestStringParam',
  '2': [
    {'1': 'eq', '3': 1, '4': 1, '5': 9, '10': 'eq'},
    {'1': 'neq', '3': 2, '4': 1, '5': 9, '10': 'neq'},
    {'1': 'in', '3': 3, '4': 3, '5': 9, '10': 'in'},
  ],
};

/// Descriptor for `EntityHistoryRequestStringParam`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List entityHistoryRequestStringParamDescriptor =
    $convert.base64Decode(
        'Ch9FbnRpdHlIaXN0b3J5UmVxdWVzdFN0cmluZ1BhcmFtEg4KAmVxGAEgASgJUgJlcRIQCgNuZX'
        'EYAiABKAlSA25lcRIOCgJpbhgDIAMoCVICaW4=');

@$core.Deprecated('Use entityHistoryRequestParamDescriptor instead')
const EntityHistoryRequestParam$json = {
  '1': 'EntityHistoryRequestParam',
  '2': [
    {'1': 'field', '3': 1, '4': 1, '5': 9, '10': 'field'},
    {
      '1': 'string_params',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.application_services.v1.EntityHistoryRequestStringParam',
      '9': 0,
      '10': 'stringParams'
    },
    {
      '1': 'data_params',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.application_services.v1.EntityHistoryRequestDateParam',
      '9': 0,
      '10': 'dataParams'
    },
  ],
  '8': [
    {'1': 'params'},
  ],
};

/// Descriptor for `EntityHistoryRequestParam`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List entityHistoryRequestParamDescriptor = $convert.base64Decode(
    'ChlFbnRpdHlIaXN0b3J5UmVxdWVzdFBhcmFtEhQKBWZpZWxkGAEgASgJUgVmaWVsZBJfCg1zdH'
    'JpbmdfcGFyYW1zGAIgASgLMjguYXBwbGljYXRpb25fc2VydmljZXMudjEuRW50aXR5SGlzdG9y'
    'eVJlcXVlc3RTdHJpbmdQYXJhbUgAUgxzdHJpbmdQYXJhbXMSWQoLZGF0YV9wYXJhbXMYAyABKA'
    'syNi5hcHBsaWNhdGlvbl9zZXJ2aWNlcy52MS5FbnRpdHlIaXN0b3J5UmVxdWVzdERhdGVQYXJh'
    'bUgAUgpkYXRhUGFyYW1zQggKBnBhcmFtcw==');

@$core.Deprecated('Use streamEntityHistoryRequestDescriptor instead')
const StreamEntityHistoryRequest$json = {
  '1': 'StreamEntityHistoryRequest',
  '2': [
    {'1': 'entity_name', '3': 1, '4': 1, '5': 9, '10': 'entityName'},
    {
      '1': 'params',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.application_services.v1.EntityHistoryRequestParam',
      '10': 'params'
    },
    {
      '1': 'order',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.application_services.v1.EntityHistoryRequestOrder',
      '10': 'order'
    },
  ],
};

/// Descriptor for `StreamEntityHistoryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List streamEntityHistoryRequestDescriptor = $convert.base64Decode(
    'ChpTdHJlYW1FbnRpdHlIaXN0b3J5UmVxdWVzdBIfCgtlbnRpdHlfbmFtZRgBIAEoCVIKZW50aX'
    'R5TmFtZRJKCgZwYXJhbXMYAiADKAsyMi5hcHBsaWNhdGlvbl9zZXJ2aWNlcy52MS5FbnRpdHlI'
    'aXN0b3J5UmVxdWVzdFBhcmFtUgZwYXJhbXMSSAoFb3JkZXIYAyADKAsyMi5hcHBsaWNhdGlvbl'
    '9zZXJ2aWNlcy52MS5FbnRpdHlIaXN0b3J5UmVxdWVzdE9yZGVyUgVvcmRlcg==');

@$core.Deprecated('Use entityDescriptor instead')
const Entity$json = {
  '1': 'Entity',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'entity_name', '3': 2, '4': 1, '5': 9, '10': 'entityName'},
    {
      '1': 'created_at',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'updated_at',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
    {
      '1': 'deleted_at',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'deletedAt'
    },
    {'1': 'payload', '3': 6, '4': 1, '5': 12, '10': 'payload'},
  ],
};

/// Descriptor for `Entity`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List entityDescriptor = $convert.base64Decode(
    'CgZFbnRpdHkSDgoCaWQYASABKAlSAmlkEh8KC2VudGl0eV9uYW1lGAIgASgJUgplbnRpdHlOYW'
    '1lEjkKCmNyZWF0ZWRfYXQYAyABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgljcmVh'
    'dGVkQXQSOQoKdXBkYXRlZF9hdBgEIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCX'
    'VwZGF0ZWRBdBI5CgpkZWxldGVkX2F0GAUgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFt'
    'cFIJZGVsZXRlZEF0EhgKB3BheWxvYWQYBiABKAxSB3BheWxvYWQ=');

@$core.Deprecated('Use streamEntityHistoryResponseDescriptor instead')
const StreamEntityHistoryResponse$json = {
  '1': 'StreamEntityHistoryResponse',
  '2': [
    {
      '1': 'entity',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.application_services.v1.Entity',
      '10': 'entity'
    },
  ],
};

/// Descriptor for `StreamEntityHistoryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List streamEntityHistoryResponseDescriptor =
    $convert.base64Decode(
        'ChtTdHJlYW1FbnRpdHlIaXN0b3J5UmVzcG9uc2USNwoGZW50aXR5GAEgASgLMh8uYXBwbGljYX'
        'Rpb25fc2VydmljZXMudjEuRW50aXR5UgZlbnRpdHk=');

@$core.Deprecated('Use entityActionRequestDescriptor instead')
const EntityActionRequest$json = {
  '1': 'EntityActionRequest',
  '2': [
    {'1': 'entity_name', '3': 1, '4': 1, '5': 9, '8': {}, '10': 'entityName'},
    {
      '1': 'action',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.application_services.v1.EntityAction',
      '10': 'action'
    },
    {
      '1': 'timestamp',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'timestamp'
    },
    {'1': 'entity_id', '3': 4, '4': 1, '5': 9, '10': 'entityId'},
    {'1': 'payload', '3': 5, '4': 1, '5': 12, '10': 'payload'},
    {'1': 'request_id', '3': 6, '4': 1, '5': 9, '10': 'requestId'},
  ],
};

/// Descriptor for `EntityActionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List entityActionRequestDescriptor = $convert.base64Decode(
    'ChNFbnRpdHlBY3Rpb25SZXF1ZXN0EioKC2VudGl0eV9uYW1lGAEgASgJQgm6SAZyBBABGBRSCm'
    'VudGl0eU5hbWUSPQoGYWN0aW9uGAIgASgOMiUuYXBwbGljYXRpb25fc2VydmljZXMudjEuRW50'
    'aXR5QWN0aW9uUgZhY3Rpb24SOAoJdGltZXN0YW1wGAMgASgLMhouZ29vZ2xlLnByb3RvYnVmLl'
    'RpbWVzdGFtcFIJdGltZXN0YW1wEhsKCWVudGl0eV9pZBgEIAEoCVIIZW50aXR5SWQSGAoHcGF5'
    'bG9hZBgFIAEoDFIHcGF5bG9hZBIdCgpyZXF1ZXN0X2lkGAYgASgJUglyZXF1ZXN0SWQ=');

@$core.Deprecated('Use entityActionResponseDescriptor instead')
const EntityActionResponse$json = {
  '1': 'EntityActionResponse',
  '2': [
    {'1': 'request_id', '3': 1, '4': 1, '5': 9, '10': 'requestId'},
  ],
};

/// Descriptor for `EntityActionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List entityActionResponseDescriptor = $convert.base64Decode(
    'ChRFbnRpdHlBY3Rpb25SZXNwb25zZRIdCgpyZXF1ZXN0X2lkGAEgASgJUglyZXF1ZXN0SWQ=');

@$core.Deprecated('Use streamEntityActionRequestDescriptor instead')
const StreamEntityActionRequest$json = {
  '1': 'StreamEntityActionRequest',
  '2': [
    {
      '1': 'action',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.application_services.v1.EntityActionRequest',
      '10': 'action'
    },
  ],
};

/// Descriptor for `StreamEntityActionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List streamEntityActionRequestDescriptor =
    $convert.base64Decode(
        'ChlTdHJlYW1FbnRpdHlBY3Rpb25SZXF1ZXN0EkQKBmFjdGlvbhgBIAEoCzIsLmFwcGxpY2F0aW'
        '9uX3NlcnZpY2VzLnYxLkVudGl0eUFjdGlvblJlcXVlc3RSBmFjdGlvbg==');

@$core.Deprecated('Use streamEntityActionResponseDescriptor instead')
const StreamEntityActionResponse$json = {
  '1': 'StreamEntityActionResponse',
  '2': [
    {'1': 'request_id', '3': 1, '4': 1, '5': 9, '10': 'requestId'},
  ],
};

/// Descriptor for `StreamEntityActionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List streamEntityActionResponseDescriptor =
    $convert.base64Decode(
        'ChpTdHJlYW1FbnRpdHlBY3Rpb25SZXNwb25zZRIdCgpyZXF1ZXN0X2lkGAEgASgJUglyZXF1ZX'
        'N0SWQ=');
