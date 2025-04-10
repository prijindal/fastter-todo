//
//  Generated code. Do not modify.
//  source: types/login.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use userStatusDescriptor instead')
const UserStatus$json = {
  '1': 'UserStatus',
  '2': [
    {'1': 'UserActivated', '2': 0},
    {'1': 'UserDeactivated', '2': 1},
    {'1': 'UserUnverified', '2': 2},
  ],
};

/// Descriptor for `UserStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List userStatusDescriptor = $convert.base64Decode(
    'CgpVc2VyU3RhdHVzEhEKDVVzZXJBY3RpdmF0ZWQQABITCg9Vc2VyRGVhY3RpdmF0ZWQQARISCg'
    '5Vc2VyVW52ZXJpZmllZBAC');

@$core.Deprecated('Use loginResponseDescriptor instead')
const LoginResponse$json = {
  '1': 'LoginResponse',
  '2': [
    {'1': 'ID', '3': 1, '4': 1, '5': 9, '10': 'ID'},
    {'1': 'Token', '3': 2, '4': 1, '5': 9, '10': 'Token'},
  ],
};

/// Descriptor for `LoginResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginResponseDescriptor = $convert.base64Decode(
    'Cg1Mb2dpblJlc3BvbnNlEg4KAklEGAEgASgJUgJJRBIUCgVUb2tlbhgCIAEoCVIFVG9rZW4=');

@$core.Deprecated('Use loginRequestDescriptor instead')
const LoginRequest$json = {
  '1': 'LoginRequest',
  '2': [
    {'1': 'Email', '3': 1, '4': 1, '5': 9, '10': 'Email'},
    {'1': 'Password', '3': 2, '4': 1, '5': 9, '10': 'Password'},
  ],
};

/// Descriptor for `LoginRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginRequestDescriptor = $convert.base64Decode(
    'CgxMb2dpblJlcXVlc3QSFAoFRW1haWwYASABKAlSBUVtYWlsEhoKCFBhc3N3b3JkGAIgASgJUg'
    'hQYXNzd29yZA==');

@$core.Deprecated('Use generateKeyResponseDescriptor instead')
const GenerateKeyResponse$json = {
  '1': 'GenerateKeyResponse',
  '2': [
    {'1': 'Token', '3': 1, '4': 1, '5': 9, '10': 'Token'},
  ],
};

/// Descriptor for `GenerateKeyResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List generateKeyResponseDescriptor = $convert.base64Decode(
    'ChNHZW5lcmF0ZUtleVJlc3BvbnNlEhQKBVRva2VuGAEgASgJUgVUb2tlbg==');

