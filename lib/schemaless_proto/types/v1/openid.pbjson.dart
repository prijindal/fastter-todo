// This is a generated file - do not edit.
//
// Generated from types/v1/openid.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use getOpenIdConfigurationResponseDescriptor instead')
const GetOpenIdConfigurationResponse$json = {
  '1': 'GetOpenIdConfigurationResponse',
  '2': [
    {'1': 'issuer', '3': 1, '4': 1, '5': 9, '10': 'issuer'},
    {
      '1': 'authorization_endpoint',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'authorizationEndpoint'
    },
    {'1': 'token_endpoint', '3': 3, '4': 1, '5': 9, '10': 'tokenEndpoint'},
    {
      '1': 'introspection_endpoint',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'introspectionEndpoint'
    },
    {
      '1': 'userinfo_endpoint',
      '3': 5,
      '4': 1,
      '5': 9,
      '10': 'userinfoEndpoint'
    },
    {
      '1': 'end_session_endpoint',
      '3': 6,
      '4': 1,
      '5': 9,
      '10': 'endSessionEndpoint'
    },
    {'1': 'jwks_uri', '3': 7, '4': 1, '5': 9, '10': 'jwksUri'},
  ],
};

/// Descriptor for `GetOpenIdConfigurationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getOpenIdConfigurationResponseDescriptor = $convert.base64Decode(
    'Ch5HZXRPcGVuSWRDb25maWd1cmF0aW9uUmVzcG9uc2USFgoGaXNzdWVyGAEgASgJUgZpc3N1ZX'
    'ISNQoWYXV0aG9yaXphdGlvbl9lbmRwb2ludBgCIAEoCVIVYXV0aG9yaXphdGlvbkVuZHBvaW50'
    'EiUKDnRva2VuX2VuZHBvaW50GAMgASgJUg10b2tlbkVuZHBvaW50EjUKFmludHJvc3BlY3Rpb2'
    '5fZW5kcG9pbnQYBCABKAlSFWludHJvc3BlY3Rpb25FbmRwb2ludBIrChF1c2VyaW5mb19lbmRw'
    'b2ludBgFIAEoCVIQdXNlcmluZm9FbmRwb2ludBIwChRlbmRfc2Vzc2lvbl9lbmRwb2ludBgGIA'
    'EoCVISZW5kU2Vzc2lvbkVuZHBvaW50EhkKCGp3a3NfdXJpGAcgASgJUgdqd2tzVXJp');

@$core.Deprecated('Use getOpenIdConfigurationRequestDescriptor instead')
const GetOpenIdConfigurationRequest$json = {
  '1': 'GetOpenIdConfigurationRequest',
};

/// Descriptor for `GetOpenIdConfigurationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getOpenIdConfigurationRequestDescriptor =
    $convert.base64Decode('Ch1HZXRPcGVuSWRDb25maWd1cmF0aW9uUmVxdWVzdA==');
