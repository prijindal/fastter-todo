// This is a generated file - do not edit.
//
// Generated from types/v1/openid.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class GetOpenIdConfigurationResponse extends $pb.GeneratedMessage {
  factory GetOpenIdConfigurationResponse({
    $core.String? issuer,
    $core.String? authorizationEndpoint,
    $core.String? tokenEndpoint,
    $core.String? introspectionEndpoint,
    $core.String? userinfoEndpoint,
    $core.String? endSessionEndpoint,
    $core.String? jwksUri,
  }) {
    final result = create();
    if (issuer != null) result.issuer = issuer;
    if (authorizationEndpoint != null)
      result.authorizationEndpoint = authorizationEndpoint;
    if (tokenEndpoint != null) result.tokenEndpoint = tokenEndpoint;
    if (introspectionEndpoint != null)
      result.introspectionEndpoint = introspectionEndpoint;
    if (userinfoEndpoint != null) result.userinfoEndpoint = userinfoEndpoint;
    if (endSessionEndpoint != null)
      result.endSessionEndpoint = endSessionEndpoint;
    if (jwksUri != null) result.jwksUri = jwksUri;
    return result;
  }

  GetOpenIdConfigurationResponse._();

  factory GetOpenIdConfigurationResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetOpenIdConfigurationResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetOpenIdConfigurationResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'types.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'issuer')
    ..aOS(2, _omitFieldNames ? '' : 'authorizationEndpoint')
    ..aOS(3, _omitFieldNames ? '' : 'tokenEndpoint')
    ..aOS(4, _omitFieldNames ? '' : 'introspectionEndpoint')
    ..aOS(5, _omitFieldNames ? '' : 'userinfoEndpoint')
    ..aOS(6, _omitFieldNames ? '' : 'endSessionEndpoint')
    ..aOS(7, _omitFieldNames ? '' : 'jwksUri')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetOpenIdConfigurationResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetOpenIdConfigurationResponse copyWith(
          void Function(GetOpenIdConfigurationResponse) updates) =>
      super.copyWith(
              (message) => updates(message as GetOpenIdConfigurationResponse))
          as GetOpenIdConfigurationResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetOpenIdConfigurationResponse create() =>
      GetOpenIdConfigurationResponse._();
  @$core.override
  GetOpenIdConfigurationResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetOpenIdConfigurationResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetOpenIdConfigurationResponse>(create);
  static GetOpenIdConfigurationResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get issuer => $_getSZ(0);
  @$pb.TagNumber(1)
  set issuer($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIssuer() => $_has(0);
  @$pb.TagNumber(1)
  void clearIssuer() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get authorizationEndpoint => $_getSZ(1);
  @$pb.TagNumber(2)
  set authorizationEndpoint($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAuthorizationEndpoint() => $_has(1);
  @$pb.TagNumber(2)
  void clearAuthorizationEndpoint() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get tokenEndpoint => $_getSZ(2);
  @$pb.TagNumber(3)
  set tokenEndpoint($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTokenEndpoint() => $_has(2);
  @$pb.TagNumber(3)
  void clearTokenEndpoint() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get introspectionEndpoint => $_getSZ(3);
  @$pb.TagNumber(4)
  set introspectionEndpoint($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIntrospectionEndpoint() => $_has(3);
  @$pb.TagNumber(4)
  void clearIntrospectionEndpoint() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get userinfoEndpoint => $_getSZ(4);
  @$pb.TagNumber(5)
  set userinfoEndpoint($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasUserinfoEndpoint() => $_has(4);
  @$pb.TagNumber(5)
  void clearUserinfoEndpoint() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get endSessionEndpoint => $_getSZ(5);
  @$pb.TagNumber(6)
  set endSessionEndpoint($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasEndSessionEndpoint() => $_has(5);
  @$pb.TagNumber(6)
  void clearEndSessionEndpoint() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get jwksUri => $_getSZ(6);
  @$pb.TagNumber(7)
  set jwksUri($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasJwksUri() => $_has(6);
  @$pb.TagNumber(7)
  void clearJwksUri() => $_clearField(7);
}

class GetOpenIdConfigurationRequest extends $pb.GeneratedMessage {
  factory GetOpenIdConfigurationRequest() => create();

  GetOpenIdConfigurationRequest._();

  factory GetOpenIdConfigurationRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetOpenIdConfigurationRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetOpenIdConfigurationRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'types.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetOpenIdConfigurationRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetOpenIdConfigurationRequest copyWith(
          void Function(GetOpenIdConfigurationRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetOpenIdConfigurationRequest))
          as GetOpenIdConfigurationRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetOpenIdConfigurationRequest create() =>
      GetOpenIdConfigurationRequest._();
  @$core.override
  GetOpenIdConfigurationRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetOpenIdConfigurationRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetOpenIdConfigurationRequest>(create);
  static GetOpenIdConfigurationRequest? _defaultInstance;
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
