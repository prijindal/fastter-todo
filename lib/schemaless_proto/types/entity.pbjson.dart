//
//  Generated code. Do not modify.
//  source: types/entity.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use entityHistoryOrderFieldDescriptor instead')
const EntityHistoryOrderField$json = {
  '1': 'EntityHistoryOrderField',
  '2': [
    {'1': 'CreatedAt', '2': 0},
    {'1': 'UpdatedAt', '2': 1},
  ],
};

/// Descriptor for `EntityHistoryOrderField`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List entityHistoryOrderFieldDescriptor = $convert.base64Decode(
    'ChdFbnRpdHlIaXN0b3J5T3JkZXJGaWVsZBINCglDcmVhdGVkQXQQABINCglVcGRhdGVkQXQQAQ'
    '==');

@$core.Deprecated('Use entityHistoryOrderValueDescriptor instead')
const EntityHistoryOrderValue$json = {
  '1': 'EntityHistoryOrderValue',
  '2': [
    {'1': 'ASC', '2': 0},
    {'1': 'DESC', '2': 1},
  ],
};

/// Descriptor for `EntityHistoryOrderValue`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List entityHistoryOrderValueDescriptor = $convert.base64Decode(
    'ChdFbnRpdHlIaXN0b3J5T3JkZXJWYWx1ZRIHCgNBU0MQABIICgRERVNDEAE=');

@$core.Deprecated('Use entityActionDescriptor instead')
const EntityAction$json = {
  '1': 'EntityAction',
  '2': [
    {'1': 'CREATE', '2': 0},
    {'1': 'UPDATE', '2': 1},
    {'1': 'DELETE', '2': 2},
  ],
};

/// Descriptor for `EntityAction`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List entityActionDescriptor = $convert.base64Decode(
    'CgxFbnRpdHlBY3Rpb24SCgoGQ1JFQVRFEAASCgoGVVBEQVRFEAESCgoGREVMRVRFEAI=');

@$core.Deprecated('Use entityActionResponseStatusDescriptor instead')
const EntityActionResponseStatus$json = {
  '1': 'EntityActionResponseStatus',
  '2': [
    {'1': 'Success', '2': 0},
    {'1': 'Error', '2': 1},
  ],
};

/// Descriptor for `EntityActionResponseStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List entityActionResponseStatusDescriptor = $convert.base64Decode(
    'ChpFbnRpdHlBY3Rpb25SZXNwb25zZVN0YXR1cxILCgdTdWNjZXNzEAASCQoFRXJyb3IQAQ==');

@$core.Deprecated('Use listEntityTypesResponseDescriptor instead')
const ListEntityTypesResponse$json = {
  '1': 'ListEntityTypesResponse',
  '2': [
    {'1': 'EntityType', '3': 1, '4': 3, '5': 9, '10': 'EntityType'},
  ],
};

/// Descriptor for `ListEntityTypesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listEntityTypesResponseDescriptor = $convert.base64Decode(
    'ChdMaXN0RW50aXR5VHlwZXNSZXNwb25zZRIeCgpFbnRpdHlUeXBlGAEgAygJUgpFbnRpdHlUeX'
    'Bl');

@$core.Deprecated('Use entityHistoryRequestOrderDescriptor instead')
const EntityHistoryRequestOrder$json = {
  '1': 'EntityHistoryRequestOrder',
  '2': [
    {'1': 'Field', '3': 1, '4': 1, '5': 14, '6': '.types.EntityHistoryOrderField', '10': 'Field'},
    {'1': 'Value', '3': 2, '4': 1, '5': 14, '6': '.types.EntityHistoryOrderValue', '10': 'Value'},
  ],
};

/// Descriptor for `EntityHistoryRequestOrder`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List entityHistoryRequestOrderDescriptor = $convert.base64Decode(
    'ChlFbnRpdHlIaXN0b3J5UmVxdWVzdE9yZGVyEjQKBUZpZWxkGAEgASgOMh4udHlwZXMuRW50aX'
    'R5SGlzdG9yeU9yZGVyRmllbGRSBUZpZWxkEjQKBVZhbHVlGAIgASgOMh4udHlwZXMuRW50aXR5'
    'SGlzdG9yeU9yZGVyVmFsdWVSBVZhbHVl');

@$core.Deprecated('Use entityHistoryRequestDateParamDescriptor instead')
const EntityHistoryRequestDateParam$json = {
  '1': 'EntityHistoryRequestDateParam',
  '2': [
    {'1': 'gte', '3': 1, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'gte'},
    {'1': 'lte', '3': 2, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'lte'},
  ],
};

/// Descriptor for `EntityHistoryRequestDateParam`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List entityHistoryRequestDateParamDescriptor = $convert.base64Decode(
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
final $typed_data.Uint8List entityHistoryRequestHostIDParamDescriptor = $convert.base64Decode(
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
final $typed_data.Uint8List entityHistoryRequestEntityNameParamDescriptor = $convert.base64Decode(
    'CiNFbnRpdHlIaXN0b3J5UmVxdWVzdEVudGl0eU5hbWVQYXJhbRIOCgJpbhgBIAMoCVICaW4=');

@$core.Deprecated('Use entityHistoryRequestParamsDescriptor instead')
const EntityHistoryRequestParams$json = {
  '1': 'EntityHistoryRequestParams',
  '2': [
    {'1': 'CreatedAt', '3': 1, '4': 1, '5': 11, '6': '.types.EntityHistoryRequestDateParam', '10': 'CreatedAt'},
    {'1': 'HostID', '3': 2, '4': 1, '5': 11, '6': '.types.EntityHistoryRequestHostIDParam', '10': 'HostID'},
    {'1': 'EntityName', '3': 3, '4': 1, '5': 11, '6': '.types.EntityHistoryRequestEntityNameParam', '10': 'EntityName'},
  ],
};

/// Descriptor for `EntityHistoryRequestParams`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List entityHistoryRequestParamsDescriptor = $convert.base64Decode(
    'ChpFbnRpdHlIaXN0b3J5UmVxdWVzdFBhcmFtcxJCCglDcmVhdGVkQXQYASABKAsyJC50eXBlcy'
    '5FbnRpdHlIaXN0b3J5UmVxdWVzdERhdGVQYXJhbVIJQ3JlYXRlZEF0Ej4KBkhvc3RJRBgCIAEo'
    'CzImLnR5cGVzLkVudGl0eUhpc3RvcnlSZXF1ZXN0SG9zdElEUGFyYW1SBkhvc3RJRBJKCgpFbn'
    'RpdHlOYW1lGAMgASgLMioudHlwZXMuRW50aXR5SGlzdG9yeVJlcXVlc3RFbnRpdHlOYW1lUGFy'
    'YW1SCkVudGl0eU5hbWU=');

@$core.Deprecated('Use searchEntityHistoryRequestDescriptor instead')
const SearchEntityHistoryRequest$json = {
  '1': 'SearchEntityHistoryRequest',
  '2': [
    {'1': 'Params', '3': 1, '4': 1, '5': 11, '6': '.types.EntityHistoryRequestParams', '10': 'Params'},
    {'1': 'Order', '3': 2, '4': 3, '5': 11, '6': '.types.EntityHistoryRequestOrder', '10': 'Order'},
  ],
};

/// Descriptor for `SearchEntityHistoryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchEntityHistoryRequestDescriptor = $convert.base64Decode(
    'ChpTZWFyY2hFbnRpdHlIaXN0b3J5UmVxdWVzdBI5CgZQYXJhbXMYASABKAsyIS50eXBlcy5Fbn'
    'RpdHlIaXN0b3J5UmVxdWVzdFBhcmFtc1IGUGFyYW1zEjYKBU9yZGVyGAIgAygLMiAudHlwZXMu'
    'RW50aXR5SGlzdG9yeVJlcXVlc3RPcmRlclIFT3JkZXI=');

@$core.Deprecated('Use entityHistoryDescriptor instead')
const EntityHistory$json = {
  '1': 'EntityHistory',
  '2': [
    {'1': 'ID', '3': 1, '4': 1, '5': 9, '10': 'ID'},
    {'1': 'EntityName', '3': 2, '4': 1, '5': 9, '10': 'EntityName'},
    {'1': 'CreatedAt', '3': 3, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'CreatedAt'},
    {'1': 'UpdatedAt', '3': 4, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'UpdatedAt'},
    {'1': 'HostID', '3': 5, '4': 1, '5': 9, '10': 'HostID'},
    {'1': 'EntityID', '3': 6, '4': 1, '5': 9, '10': 'EntityID'},
    {'1': 'Action', '3': 7, '4': 1, '5': 14, '6': '.types.EntityAction', '10': 'Action'},
    {'1': 'Payload', '3': 8, '4': 1, '5': 12, '10': 'Payload'},
  ],
};

/// Descriptor for `EntityHistory`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List entityHistoryDescriptor = $convert.base64Decode(
    'Cg1FbnRpdHlIaXN0b3J5Eg4KAklEGAEgASgJUgJJRBIeCgpFbnRpdHlOYW1lGAIgASgJUgpFbn'
    'RpdHlOYW1lEjgKCUNyZWF0ZWRBdBgDIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBS'
    'CUNyZWF0ZWRBdBI4CglVcGRhdGVkQXQYBCABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW'
    '1wUglVcGRhdGVkQXQSFgoGSG9zdElEGAUgASgJUgZIb3N0SUQSGgoIRW50aXR5SUQYBiABKAlS'
    'CEVudGl0eUlEEisKBkFjdGlvbhgHIAEoDjITLnR5cGVzLkVudGl0eUFjdGlvblIGQWN0aW9uEh'
    'gKB1BheWxvYWQYCCABKAxSB1BheWxvYWQ=');

@$core.Deprecated('Use entityActionRequestDescriptor instead')
const EntityActionRequest$json = {
  '1': 'EntityActionRequest',
  '2': [
    {'1': 'HostID', '3': 1, '4': 1, '5': 9, '10': 'HostID'},
    {'1': 'ActionId', '3': 2, '4': 1, '5': 9, '10': 'ActionId'},
    {'1': 'EntityName', '3': 3, '4': 1, '5': 9, '10': 'EntityName'},
    {'1': 'Action', '3': 4, '4': 1, '5': 14, '6': '.types.EntityAction', '10': 'Action'},
    {'1': 'CreatedAt', '3': 5, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'CreatedAt'},
    {'1': 'EntityId', '3': 6, '4': 1, '5': 9, '10': 'EntityId'},
    {'1': 'Payload', '3': 7, '4': 1, '5': 12, '10': 'Payload'},
    {'1': 'RequestID', '3': 8, '4': 1, '5': 9, '10': 'RequestID'},
  ],
};

/// Descriptor for `EntityActionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List entityActionRequestDescriptor = $convert.base64Decode(
    'ChNFbnRpdHlBY3Rpb25SZXF1ZXN0EhYKBkhvc3RJRBgBIAEoCVIGSG9zdElEEhoKCEFjdGlvbk'
    'lkGAIgASgJUghBY3Rpb25JZBIeCgpFbnRpdHlOYW1lGAMgASgJUgpFbnRpdHlOYW1lEisKBkFj'
    'dGlvbhgEIAEoDjITLnR5cGVzLkVudGl0eUFjdGlvblIGQWN0aW9uEjgKCUNyZWF0ZWRBdBgFIA'
    'EoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCUNyZWF0ZWRBdBIaCghFbnRpdHlJZBgG'
    'IAEoCVIIRW50aXR5SWQSGAoHUGF5bG9hZBgHIAEoDFIHUGF5bG9hZBIcCglSZXF1ZXN0SUQYCC'
    'ABKAlSCVJlcXVlc3RJRA==');

@$core.Deprecated('Use entityActionResponseDescriptor instead')
const EntityActionResponse$json = {
  '1': 'EntityActionResponse',
  '2': [
    {'1': 'RequestID', '3': 1, '4': 1, '5': 9, '10': 'RequestID'},
    {'1': 'Status', '3': 2, '4': 1, '5': 14, '6': '.types.EntityActionResponseStatus', '10': 'Status'},
  ],
};

/// Descriptor for `EntityActionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List entityActionResponseDescriptor = $convert.base64Decode(
    'ChRFbnRpdHlBY3Rpb25SZXNwb25zZRIcCglSZXF1ZXN0SUQYASABKAlSCVJlcXVlc3RJRBI5Cg'
    'ZTdGF0dXMYAiABKA4yIS50eXBlcy5FbnRpdHlBY3Rpb25SZXNwb25zZVN0YXR1c1IGU3RhdHVz');

