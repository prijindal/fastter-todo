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

@$core.Deprecated('Use entityHistoryOrderFieldDescriptor instead')
const EntityHistoryOrderField$json = {
  '1': 'EntityHistoryOrderField',
  '2': [
    {'1': 'ENTITY_HISTORY_ORDER_FIELD_UNSPECIFIED', '2': 0},
    {'1': 'ENTITY_HISTORY_ORDER_FIELD_CREATED_AT', '2': 1},
    {'1': 'ENTITY_HISTORY_ORDER_FIELD_UPDATED_AT', '2': 2},
  ],
};

/// Descriptor for `EntityHistoryOrderField`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List entityHistoryOrderFieldDescriptor = $convert.base64Decode(
    'ChdFbnRpdHlIaXN0b3J5T3JkZXJGaWVsZBIqCiZFTlRJVFlfSElTVE9SWV9PUkRFUl9GSUVMRF'
    '9VTlNQRUNJRklFRBAAEikKJUVOVElUWV9ISVNUT1JZX09SREVSX0ZJRUxEX0NSRUFURURfQVQQ'
    'ARIpCiVFTlRJVFlfSElTVE9SWV9PUkRFUl9GSUVMRF9VUERBVEVEX0FUEAI=');

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
    {
      '1': 'field',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.application_services.v1.EntityHistoryOrderField',
      '10': 'field'
    },
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
    'ChlFbnRpdHlIaXN0b3J5UmVxdWVzdE9yZGVyEkYKBWZpZWxkGAEgASgOMjAuYXBwbGljYXRpb2'
    '5fc2VydmljZXMudjEuRW50aXR5SGlzdG9yeU9yZGVyRmllbGRSBWZpZWxkEkYKBXZhbHVlGAIg'
    'ASgOMjAuYXBwbGljYXRpb25fc2VydmljZXMudjEuRW50aXR5SGlzdG9yeU9yZGVyVmFsdWVSBX'
    'ZhbHVl');

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

@$core.Deprecated('Use entityHistoryRequestHostIDParamDescriptor instead')
const EntityHistoryRequestHostIDParam$json = {
  '1': 'EntityHistoryRequestHostIDParam',
  '2': [
    {'1': 'eq', '3': 1, '4': 1, '5': 9, '10': 'eq'},
    {'1': 'neq', '3': 2, '4': 1, '5': 9, '10': 'neq'},
  ],
};

/// Descriptor for `EntityHistoryRequestHostIDParam`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List entityHistoryRequestHostIDParamDescriptor =
    $convert.base64Decode(
        'Ch9FbnRpdHlIaXN0b3J5UmVxdWVzdEhvc3RJRFBhcmFtEg4KAmVxGAEgASgJUgJlcRIQCgNuZX'
        'EYAiABKAlSA25lcQ==');

@$core.Deprecated('Use entityHistoryRequestEntityNameParamDescriptor instead')
const EntityHistoryRequestEntityNameParam$json = {
  '1': 'EntityHistoryRequestEntityNameParam',
  '2': [
    {'1': 'in', '3': 1, '4': 3, '5': 9, '10': 'in'},
  ],
};

/// Descriptor for `EntityHistoryRequestEntityNameParam`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List entityHistoryRequestEntityNameParamDescriptor =
    $convert.base64Decode(
        'CiNFbnRpdHlIaXN0b3J5UmVxdWVzdEVudGl0eU5hbWVQYXJhbRIOCgJpbhgBIAMoCVICaW4=');

@$core.Deprecated('Use entityHistoryRequestParamsDescriptor instead')
const EntityHistoryRequestParams$json = {
  '1': 'EntityHistoryRequestParams',
  '2': [
    {
      '1': 'created_at',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.application_services.v1.EntityHistoryRequestDateParam',
      '10': 'createdAt'
    },
    {
      '1': 'host_id',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.application_services.v1.EntityHistoryRequestHostIDParam',
      '10': 'hostId'
    },
    {
      '1': 'entity_name',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.application_services.v1.EntityHistoryRequestEntityNameParam',
      '10': 'entityName'
    },
  ],
};

/// Descriptor for `EntityHistoryRequestParams`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List entityHistoryRequestParamsDescriptor = $convert.base64Decode(
    'ChpFbnRpdHlIaXN0b3J5UmVxdWVzdFBhcmFtcxJVCgpjcmVhdGVkX2F0GAEgASgLMjYuYXBwbG'
    'ljYXRpb25fc2VydmljZXMudjEuRW50aXR5SGlzdG9yeVJlcXVlc3REYXRlUGFyYW1SCWNyZWF0'
    'ZWRBdBJRCgdob3N0X2lkGAIgASgLMjguYXBwbGljYXRpb25fc2VydmljZXMudjEuRW50aXR5SG'
    'lzdG9yeVJlcXVlc3RIb3N0SURQYXJhbVIGaG9zdElkEl0KC2VudGl0eV9uYW1lGAMgASgLMjwu'
    'YXBwbGljYXRpb25fc2VydmljZXMudjEuRW50aXR5SGlzdG9yeVJlcXVlc3RFbnRpdHlOYW1lUG'
    'FyYW1SCmVudGl0eU5hbWU=');

@$core.Deprecated('Use streamEntityHistoryRequestDescriptor instead')
const StreamEntityHistoryRequest$json = {
  '1': 'StreamEntityHistoryRequest',
  '2': [
    {
      '1': 'params',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.application_services.v1.EntityHistoryRequestParams',
      '10': 'params'
    },
    {
      '1': 'order',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.application_services.v1.EntityHistoryRequestOrder',
      '10': 'order'
    },
  ],
};

/// Descriptor for `StreamEntityHistoryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List streamEntityHistoryRequestDescriptor = $convert.base64Decode(
    'ChpTdHJlYW1FbnRpdHlIaXN0b3J5UmVxdWVzdBJLCgZwYXJhbXMYASABKAsyMy5hcHBsaWNhdG'
    'lvbl9zZXJ2aWNlcy52MS5FbnRpdHlIaXN0b3J5UmVxdWVzdFBhcmFtc1IGcGFyYW1zEkgKBW9y'
    'ZGVyGAIgAygLMjIuYXBwbGljYXRpb25fc2VydmljZXMudjEuRW50aXR5SGlzdG9yeVJlcXVlc3'
    'RPcmRlclIFb3JkZXI=');

@$core.Deprecated('Use entityHistoryDescriptor instead')
const EntityHistory$json = {
  '1': 'EntityHistory',
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
    {'1': 'host_id', '3': 5, '4': 1, '5': 9, '10': 'hostId'},
    {'1': 'entity_id', '3': 6, '4': 1, '5': 9, '10': 'entityId'},
    {
      '1': 'action',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.application_services.v1.EntityAction',
      '10': 'action'
    },
    {'1': 'payload', '3': 8, '4': 1, '5': 12, '10': 'payload'},
  ],
};

/// Descriptor for `EntityHistory`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List entityHistoryDescriptor = $convert.base64Decode(
    'Cg1FbnRpdHlIaXN0b3J5Eg4KAmlkGAEgASgJUgJpZBIfCgtlbnRpdHlfbmFtZRgCIAEoCVIKZW'
    '50aXR5TmFtZRI5CgpjcmVhdGVkX2F0GAMgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFt'
    'cFIJY3JlYXRlZEF0EjkKCnVwZGF0ZWRfYXQYBCABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZX'
    'N0YW1wUgl1cGRhdGVkQXQSFwoHaG9zdF9pZBgFIAEoCVIGaG9zdElkEhsKCWVudGl0eV9pZBgG'
    'IAEoCVIIZW50aXR5SWQSPQoGYWN0aW9uGAcgASgOMiUuYXBwbGljYXRpb25fc2VydmljZXMudj'
    'EuRW50aXR5QWN0aW9uUgZhY3Rpb24SGAoHcGF5bG9hZBgIIAEoDFIHcGF5bG9hZA==');

@$core.Deprecated('Use streamEntityHistoryResponseDescriptor instead')
const StreamEntityHistoryResponse$json = {
  '1': 'StreamEntityHistoryResponse',
  '2': [
    {
      '1': 'history',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.application_services.v1.EntityHistory',
      '10': 'history'
    },
  ],
};

/// Descriptor for `StreamEntityHistoryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List streamEntityHistoryResponseDescriptor =
    $convert.base64Decode(
        'ChtTdHJlYW1FbnRpdHlIaXN0b3J5UmVzcG9uc2USQAoHaGlzdG9yeRgBIAEoCzImLmFwcGxpY2'
        'F0aW9uX3NlcnZpY2VzLnYxLkVudGl0eUhpc3RvcnlSB2hpc3Rvcnk=');

@$core.Deprecated('Use entityActionRequestDescriptor instead')
const EntityActionRequest$json = {
  '1': 'EntityActionRequest',
  '2': [
    {'1': 'host_id', '3': 1, '4': 1, '5': 9, '10': 'hostId'},
    {'1': 'action_id', '3': 2, '4': 1, '5': 9, '10': 'actionId'},
    {'1': 'entity_name', '3': 3, '4': 1, '5': 9, '8': {}, '10': 'entityName'},
    {
      '1': 'action',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.application_services.v1.EntityAction',
      '10': 'action'
    },
    {
      '1': 'created_at',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {'1': 'entity_id', '3': 6, '4': 1, '5': 9, '10': 'entityId'},
    {'1': 'payload', '3': 7, '4': 1, '5': 12, '10': 'payload'},
    {'1': 'request_id', '3': 8, '4': 1, '5': 9, '10': 'requestId'},
  ],
};

/// Descriptor for `EntityActionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List entityActionRequestDescriptor = $convert.base64Decode(
    'ChNFbnRpdHlBY3Rpb25SZXF1ZXN0EhcKB2hvc3RfaWQYASABKAlSBmhvc3RJZBIbCglhY3Rpb2'
    '5faWQYAiABKAlSCGFjdGlvbklkEioKC2VudGl0eV9uYW1lGAMgASgJQgm6SAZyBBABGBRSCmVu'
    'dGl0eU5hbWUSPQoGYWN0aW9uGAQgASgOMiUuYXBwbGljYXRpb25fc2VydmljZXMudjEuRW50aX'
    'R5QWN0aW9uUgZhY3Rpb24SOQoKY3JlYXRlZF9hdBgFIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5U'
    'aW1lc3RhbXBSCWNyZWF0ZWRBdBIbCgllbnRpdHlfaWQYBiABKAlSCGVudGl0eUlkEhgKB3BheW'
    'xvYWQYByABKAxSB3BheWxvYWQSHQoKcmVxdWVzdF9pZBgIIAEoCVIJcmVxdWVzdElk');

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
