//
//  Generated code. Do not modify.
//  source: types/login.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class UserStatus extends $pb.ProtobufEnum {
  static const UserStatus UserActivated = UserStatus._(0, _omitEnumNames ? '' : 'UserActivated');
  static const UserStatus UserDeactivated = UserStatus._(1, _omitEnumNames ? '' : 'UserDeactivated');
  static const UserStatus UserUnverified = UserStatus._(2, _omitEnumNames ? '' : 'UserUnverified');

  static const $core.List<UserStatus> values = <UserStatus> [
    UserActivated,
    UserDeactivated,
    UserUnverified,
  ];

  static final $core.Map<$core.int, UserStatus> _byValue = $pb.ProtobufEnum.initByValue(values);
  static UserStatus? valueOf($core.int value) => _byValue[value];

  const UserStatus._(super.v, super.n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
