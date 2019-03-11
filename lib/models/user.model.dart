import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';

import 'base.model.dart';
part 'user.model.g.dart';

@JsonSerializable()
class User extends BaseModel {
  User({
    this.id,
    this.email,
    this.name,
    this.picture,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  @JsonKey(name: '_id', nullable: false)
  final String id;
  final String email;
  final String picture;
  final String name;

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class LoginField extends Object {
  LoginField({
    this.user,
    this.bearer,
  });

  factory LoginField.fromJson(Map<String, dynamic> json) =>
      _$LoginFieldFromJson(json);

  User user;
  String bearer;

  Map<String, dynamic> toJson() => _$LoginFieldToJson(this);
}

@JsonSerializable()
class LoginData extends Object {
  LoginData({
    this.login,
  });
  LoginField login;
  factory LoginData.fromJson(Map<String, dynamic> json) =>
      _$LoginDataFromJson(json);

  Map<String, dynamic> toJson() => _$LoginDataToJson(this);
}

@JsonSerializable()
class CurrentData extends Object {
  CurrentData({
    this.current,
  });
  User current;
  factory CurrentData.fromJson(Map<String, dynamic> json) =>
      _$CurrentDataFromJson(json);

  Map<String, dynamic> toJson() => _$CurrentDataToJson(this);
}

@JsonSerializable()
class UserState {
  final User user;
  final String bearer;
  final bool isLoading;
  final String errorMessage;

  UserState({
    @required this.user,
    @required this.bearer,
    this.isLoading = false,
    this.errorMessage,
  });
  factory UserState.fromJson(Map<String, dynamic> json) =>
      _$UserStateFromJson(json);

  Map<String, dynamic> toJson() => _$UserStateToJson(this);
}

String userFragment = '''
  fragment user on User {
    _id
    email
    name
    picture
  }
''';
