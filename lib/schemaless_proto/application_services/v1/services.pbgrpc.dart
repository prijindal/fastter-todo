// This is a generated file - do not edit.
//
// Generated from application_services/v1/services.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import '../../types/v1/health.pb.dart' as $0;
import '../../types/v1/openid.pb.dart' as $3;
import 'entity.pb.dart' as $2;
import 'services.pb.dart' as $1;

export 'services.pb.dart';

@$pb.GrpcServiceName('application_services.v1.HealthService')
class HealthServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  HealthServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.HealthResponse> health(
    $0.HealthRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$health, request, options: options);
  }

  // method descriptors

  static final _$health =
      $grpc.ClientMethod<$0.HealthRequest, $0.HealthResponse>(
          '/application_services.v1.HealthService/Health',
          ($0.HealthRequest value) => value.writeToBuffer(),
          $0.HealthResponse.fromBuffer);
}

@$pb.GrpcServiceName('application_services.v1.HealthService')
abstract class HealthServiceBase extends $grpc.Service {
  $core.String get $name => 'application_services.v1.HealthService';

  HealthServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.HealthRequest, $0.HealthResponse>(
        'Health',
        health_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.HealthRequest.fromBuffer(value),
        ($0.HealthResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.HealthResponse> health_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.HealthRequest> $request) async {
    return health($call, await $request);
  }

  $async.Future<$0.HealthResponse> health(
      $grpc.ServiceCall call, $0.HealthRequest request);
}

@$pb.GrpcServiceName('application_services.v1.AuthService')
class AuthServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  AuthServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$1.VerifyUserResponse> verifyUser(
    $1.VerifyUserRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$verifyUser, request, options: options);
  }

  // method descriptors

  static final _$verifyUser =
      $grpc.ClientMethod<$1.VerifyUserRequest, $1.VerifyUserResponse>(
          '/application_services.v1.AuthService/VerifyUser',
          ($1.VerifyUserRequest value) => value.writeToBuffer(),
          $1.VerifyUserResponse.fromBuffer);
}

@$pb.GrpcServiceName('application_services.v1.AuthService')
abstract class AuthServiceBase extends $grpc.Service {
  $core.String get $name => 'application_services.v1.AuthService';

  AuthServiceBase() {
    $addMethod($grpc.ServiceMethod<$1.VerifyUserRequest, $1.VerifyUserResponse>(
        'VerifyUser',
        verifyUser_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.VerifyUserRequest.fromBuffer(value),
        ($1.VerifyUserResponse value) => value.writeToBuffer()));
  }

  $async.Future<$1.VerifyUserResponse> verifyUser_Pre($grpc.ServiceCall $call,
      $async.Future<$1.VerifyUserRequest> $request) async {
    return verifyUser($call, await $request);
  }

  $async.Future<$1.VerifyUserResponse> verifyUser(
      $grpc.ServiceCall call, $1.VerifyUserRequest request);
}

@$pb.GrpcServiceName('application_services.v1.EntityService')
class EntityServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  EntityServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$2.ListEntityTypesResponse> listEntityTypes(
    $2.ListEntityTypesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listEntityTypes, request, options: options);
  }

  $grpc.ResponseStream<$2.StreamEntityHistoryResponse> streamEntityHistory(
    $2.StreamEntityHistoryRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(
        _$streamEntityHistory, $async.Stream.fromIterable([request]),
        options: options);
  }

  $grpc.ResponseStream<$2.StreamEntityActionResponse> streamEntityAction(
    $async.Stream<$2.StreamEntityActionRequest> request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(_$streamEntityAction, request,
        options: options);
  }

  $grpc.ResponseFuture<$2.EntityActionResponse> entityAction(
    $2.EntityActionRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$entityAction, request, options: options);
  }

  // method descriptors

  static final _$listEntityTypes =
      $grpc.ClientMethod<$2.ListEntityTypesRequest, $2.ListEntityTypesResponse>(
          '/application_services.v1.EntityService/ListEntityTypes',
          ($2.ListEntityTypesRequest value) => value.writeToBuffer(),
          $2.ListEntityTypesResponse.fromBuffer);
  static final _$streamEntityHistory = $grpc.ClientMethod<
          $2.StreamEntityHistoryRequest, $2.StreamEntityHistoryResponse>(
      '/application_services.v1.EntityService/StreamEntityHistory',
      ($2.StreamEntityHistoryRequest value) => value.writeToBuffer(),
      $2.StreamEntityHistoryResponse.fromBuffer);
  static final _$streamEntityAction = $grpc.ClientMethod<
          $2.StreamEntityActionRequest, $2.StreamEntityActionResponse>(
      '/application_services.v1.EntityService/StreamEntityAction',
      ($2.StreamEntityActionRequest value) => value.writeToBuffer(),
      $2.StreamEntityActionResponse.fromBuffer);
  static final _$entityAction =
      $grpc.ClientMethod<$2.EntityActionRequest, $2.EntityActionResponse>(
          '/application_services.v1.EntityService/EntityAction',
          ($2.EntityActionRequest value) => value.writeToBuffer(),
          $2.EntityActionResponse.fromBuffer);
}

@$pb.GrpcServiceName('application_services.v1.EntityService')
abstract class EntityServiceBase extends $grpc.Service {
  $core.String get $name => 'application_services.v1.EntityService';

  EntityServiceBase() {
    $addMethod($grpc.ServiceMethod<$2.ListEntityTypesRequest,
            $2.ListEntityTypesResponse>(
        'ListEntityTypes',
        listEntityTypes_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $2.ListEntityTypesRequest.fromBuffer(value),
        ($2.ListEntityTypesResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$2.StreamEntityHistoryRequest,
            $2.StreamEntityHistoryResponse>(
        'StreamEntityHistory',
        streamEntityHistory_Pre,
        false,
        true,
        ($core.List<$core.int> value) =>
            $2.StreamEntityHistoryRequest.fromBuffer(value),
        ($2.StreamEntityHistoryResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$2.StreamEntityActionRequest,
            $2.StreamEntityActionResponse>(
        'StreamEntityAction',
        streamEntityAction,
        true,
        true,
        ($core.List<$core.int> value) =>
            $2.StreamEntityActionRequest.fromBuffer(value),
        ($2.StreamEntityActionResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$2.EntityActionRequest, $2.EntityActionResponse>(
            'EntityAction',
            entityAction_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $2.EntityActionRequest.fromBuffer(value),
            ($2.EntityActionResponse value) => value.writeToBuffer()));
  }

  $async.Future<$2.ListEntityTypesResponse> listEntityTypes_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$2.ListEntityTypesRequest> $request) async {
    return listEntityTypes($call, await $request);
  }

  $async.Future<$2.ListEntityTypesResponse> listEntityTypes(
      $grpc.ServiceCall call, $2.ListEntityTypesRequest request);

  $async.Stream<$2.StreamEntityHistoryResponse> streamEntityHistory_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$2.StreamEntityHistoryRequest> $request) async* {
    yield* streamEntityHistory($call, await $request);
  }

  $async.Stream<$2.StreamEntityHistoryResponse> streamEntityHistory(
      $grpc.ServiceCall call, $2.StreamEntityHistoryRequest request);

  $async.Stream<$2.StreamEntityActionResponse> streamEntityAction(
      $grpc.ServiceCall call,
      $async.Stream<$2.StreamEntityActionRequest> request);

  $async.Future<$2.EntityActionResponse> entityAction_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$2.EntityActionRequest> $request) async {
    return entityAction($call, await $request);
  }

  $async.Future<$2.EntityActionResponse> entityAction(
      $grpc.ServiceCall call, $2.EntityActionRequest request);
}

@$pb.GrpcServiceName('application_services.v1.ConfigService')
class ConfigServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  ConfigServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$3.GetOpenIdConfigurationResponse>
      getOpenIdConfiguration(
    $3.GetOpenIdConfigurationRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getOpenIdConfiguration, request,
        options: options);
  }

  // method descriptors

  static final _$getOpenIdConfiguration = $grpc.ClientMethod<
          $3.GetOpenIdConfigurationRequest, $3.GetOpenIdConfigurationResponse>(
      '/application_services.v1.ConfigService/GetOpenIdConfiguration',
      ($3.GetOpenIdConfigurationRequest value) => value.writeToBuffer(),
      $3.GetOpenIdConfigurationResponse.fromBuffer);
}

@$pb.GrpcServiceName('application_services.v1.ConfigService')
abstract class ConfigServiceBase extends $grpc.Service {
  $core.String get $name => 'application_services.v1.ConfigService';

  ConfigServiceBase() {
    $addMethod($grpc.ServiceMethod<$3.GetOpenIdConfigurationRequest,
            $3.GetOpenIdConfigurationResponse>(
        'GetOpenIdConfiguration',
        getOpenIdConfiguration_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $3.GetOpenIdConfigurationRequest.fromBuffer(value),
        ($3.GetOpenIdConfigurationResponse value) => value.writeToBuffer()));
  }

  $async.Future<$3.GetOpenIdConfigurationResponse> getOpenIdConfiguration_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$3.GetOpenIdConfigurationRequest> $request) async {
    return getOpenIdConfiguration($call, await $request);
  }

  $async.Future<$3.GetOpenIdConfigurationResponse> getOpenIdConfiguration(
      $grpc.ServiceCall call, $3.GetOpenIdConfigurationRequest request);
}
