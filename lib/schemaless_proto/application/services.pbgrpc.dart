//
//  Generated code. Do not modify.
//  source: application/services.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import '../google/protobuf/empty.pb.dart' as $0;
import '../types/entity.pb.dart' as $4;
import '../types/health.pb.dart' as $1;
import '../types/login.pb.dart' as $2;
import 'services.pb.dart' as $3;

export 'services.pb.dart';

@$pb.GrpcServiceName('application_services.HealthService')
class HealthServiceClient extends $grpc.Client {
  static final _$health = $grpc.ClientMethod<$0.Empty, $1.HealthResponse>(
      '/application_services.HealthService/Health',
      ($0.Empty value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.HealthResponse.fromBuffer(value));

  HealthServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$1.HealthResponse> health($0.Empty request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$health, request, options: options);
  }
}

@$pb.GrpcServiceName('application_services.HealthService')
abstract class HealthServiceBase extends $grpc.Service {
  $core.String get $name => 'application_services.HealthService';

  HealthServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.Empty, $1.HealthResponse>(
        'Health',
        health_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($1.HealthResponse value) => value.writeToBuffer()));
  }

  $async.Future<$1.HealthResponse> health_Pre($grpc.ServiceCall $call, $async.Future<$0.Empty> $request) async {
    return health($call, await $request);
  }

  $async.Future<$1.HealthResponse> health($grpc.ServiceCall call, $0.Empty request);
}
@$pb.GrpcServiceName('application_services.LoginService')
class LoginServiceClient extends $grpc.Client {
  static final _$loginUser = $grpc.ClientMethod<$2.LoginRequest, $2.LoginResponse>(
      '/application_services.LoginService/LoginUser',
      ($2.LoginRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $2.LoginResponse.fromBuffer(value));
  static final _$registerUser = $grpc.ClientMethod<$2.LoginRequest, $3.RegisterResponse>(
      '/application_services.LoginService/RegisterUser',
      ($2.LoginRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $3.RegisterResponse.fromBuffer(value));

  LoginServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$2.LoginResponse> loginUser($2.LoginRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$loginUser, request, options: options);
  }

  $grpc.ResponseFuture<$3.RegisterResponse> registerUser($2.LoginRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$registerUser, request, options: options);
  }
}

@$pb.GrpcServiceName('application_services.LoginService')
abstract class LoginServiceBase extends $grpc.Service {
  $core.String get $name => 'application_services.LoginService';

  LoginServiceBase() {
    $addMethod($grpc.ServiceMethod<$2.LoginRequest, $2.LoginResponse>(
        'LoginUser',
        loginUser_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $2.LoginRequest.fromBuffer(value),
        ($2.LoginResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$2.LoginRequest, $3.RegisterResponse>(
        'RegisterUser',
        registerUser_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $2.LoginRequest.fromBuffer(value),
        ($3.RegisterResponse value) => value.writeToBuffer()));
  }

  $async.Future<$2.LoginResponse> loginUser_Pre($grpc.ServiceCall $call, $async.Future<$2.LoginRequest> $request) async {
    return loginUser($call, await $request);
  }

  $async.Future<$3.RegisterResponse> registerUser_Pre($grpc.ServiceCall $call, $async.Future<$2.LoginRequest> $request) async {
    return registerUser($call, await $request);
  }

  $async.Future<$2.LoginResponse> loginUser($grpc.ServiceCall call, $2.LoginRequest request);
  $async.Future<$3.RegisterResponse> registerUser($grpc.ServiceCall call, $2.LoginRequest request);
}
@$pb.GrpcServiceName('application_services.AuthService')
class AuthServiceClient extends $grpc.Client {
  static final _$verifyUser = $grpc.ClientMethod<$0.Empty, $3.VerifyUserResponse>(
      '/application_services.AuthService/VerifyUser',
      ($0.Empty value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $3.VerifyUserResponse.fromBuffer(value));
  static final _$generateKey = $grpc.ClientMethod<$0.Empty, $2.GenerateKeyResponse>(
      '/application_services.AuthService/GenerateKey',
      ($0.Empty value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $2.GenerateKeyResponse.fromBuffer(value));
  static final _$revokeKey = $grpc.ClientMethod<$0.Empty, $0.Empty>(
      '/application_services.AuthService/RevokeKey',
      ($0.Empty value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));

  AuthServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$3.VerifyUserResponse> verifyUser($0.Empty request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$verifyUser, request, options: options);
  }

  $grpc.ResponseFuture<$2.GenerateKeyResponse> generateKey($0.Empty request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$generateKey, request, options: options);
  }

  $grpc.ResponseFuture<$0.Empty> revokeKey($0.Empty request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$revokeKey, request, options: options);
  }
}

@$pb.GrpcServiceName('application_services.AuthService')
abstract class AuthServiceBase extends $grpc.Service {
  $core.String get $name => 'application_services.AuthService';

  AuthServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.Empty, $3.VerifyUserResponse>(
        'VerifyUser',
        verifyUser_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($3.VerifyUserResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $2.GenerateKeyResponse>(
        'GenerateKey',
        generateKey_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($2.GenerateKeyResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.Empty>(
        'RevokeKey',
        revokeKey_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
  }

  $async.Future<$3.VerifyUserResponse> verifyUser_Pre($grpc.ServiceCall $call, $async.Future<$0.Empty> $request) async {
    return verifyUser($call, await $request);
  }

  $async.Future<$2.GenerateKeyResponse> generateKey_Pre($grpc.ServiceCall $call, $async.Future<$0.Empty> $request) async {
    return generateKey($call, await $request);
  }

  $async.Future<$0.Empty> revokeKey_Pre($grpc.ServiceCall $call, $async.Future<$0.Empty> $request) async {
    return revokeKey($call, await $request);
  }

  $async.Future<$3.VerifyUserResponse> verifyUser($grpc.ServiceCall call, $0.Empty request);
  $async.Future<$2.GenerateKeyResponse> generateKey($grpc.ServiceCall call, $0.Empty request);
  $async.Future<$0.Empty> revokeKey($grpc.ServiceCall call, $0.Empty request);
}
@$pb.GrpcServiceName('application_services.EntityService')
class EntityServiceClient extends $grpc.Client {
  static final _$listEntityTypes = $grpc.ClientMethod<$0.Empty, $4.ListEntityTypesResponse>(
      '/application_services.EntityService/ListEntityTypes',
      ($0.Empty value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $4.ListEntityTypesResponse.fromBuffer(value));
  static final _$streamEntityHistory = $grpc.ClientMethod<$4.SearchEntityHistoryRequest, $4.EntityHistory>(
      '/application_services.EntityService/StreamEntityHistory',
      ($4.SearchEntityHistoryRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $4.EntityHistory.fromBuffer(value));
  static final _$streamEntityAction = $grpc.ClientMethod<$4.EntityActionRequest, $4.EntityActionResponse>(
      '/application_services.EntityService/StreamEntityAction',
      ($4.EntityActionRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $4.EntityActionResponse.fromBuffer(value));
  static final _$entityAction = $grpc.ClientMethod<$4.EntityActionRequest, $0.Empty>(
      '/application_services.EntityService/EntityAction',
      ($4.EntityActionRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));

  EntityServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$4.ListEntityTypesResponse> listEntityTypes($0.Empty request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$listEntityTypes, request, options: options);
  }

  $grpc.ResponseStream<$4.EntityHistory> streamEntityHistory($4.SearchEntityHistoryRequest request, {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$streamEntityHistory, $async.Stream.fromIterable([request]), options: options);
  }

  $grpc.ResponseStream<$4.EntityActionResponse> streamEntityAction($async.Stream<$4.EntityActionRequest> request, {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$streamEntityAction, request, options: options);
  }

  $grpc.ResponseFuture<$0.Empty> entityAction($4.EntityActionRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$entityAction, request, options: options);
  }
}

@$pb.GrpcServiceName('application_services.EntityService')
abstract class EntityServiceBase extends $grpc.Service {
  $core.String get $name => 'application_services.EntityService';

  EntityServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.Empty, $4.ListEntityTypesResponse>(
        'ListEntityTypes',
        listEntityTypes_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($4.ListEntityTypesResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$4.SearchEntityHistoryRequest, $4.EntityHistory>(
        'StreamEntityHistory',
        streamEntityHistory_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $4.SearchEntityHistoryRequest.fromBuffer(value),
        ($4.EntityHistory value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$4.EntityActionRequest, $4.EntityActionResponse>(
        'StreamEntityAction',
        streamEntityAction,
        true,
        true,
        ($core.List<$core.int> value) => $4.EntityActionRequest.fromBuffer(value),
        ($4.EntityActionResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$4.EntityActionRequest, $0.Empty>(
        'EntityAction',
        entityAction_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $4.EntityActionRequest.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
  }

  $async.Future<$4.ListEntityTypesResponse> listEntityTypes_Pre($grpc.ServiceCall $call, $async.Future<$0.Empty> $request) async {
    return listEntityTypes($call, await $request);
  }

  $async.Stream<$4.EntityHistory> streamEntityHistory_Pre($grpc.ServiceCall $call, $async.Future<$4.SearchEntityHistoryRequest> $request) async* {
    yield* streamEntityHistory($call, await $request);
  }

  $async.Future<$0.Empty> entityAction_Pre($grpc.ServiceCall $call, $async.Future<$4.EntityActionRequest> $request) async {
    return entityAction($call, await $request);
  }

  $async.Future<$4.ListEntityTypesResponse> listEntityTypes($grpc.ServiceCall call, $0.Empty request);
  $async.Stream<$4.EntityHistory> streamEntityHistory($grpc.ServiceCall call, $4.SearchEntityHistoryRequest request);
  $async.Stream<$4.EntityActionResponse> streamEntityAction($grpc.ServiceCall call, $async.Stream<$4.EntityActionRequest> request);
  $async.Future<$0.Empty> entityAction($grpc.ServiceCall call, $4.EntityActionRequest request);
}
