import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';

import 'base.model.dart';
import 'settings.model.dart';
part 'user.model.g.dart';

@JsonSerializable()
class User extends BaseModel {
  User({
    String? id,
    this.email,
    this.name,
    this.picture,
    this.settings,
  }) : super(id: id);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  final String? email;
  final String? picture;
  final String? name;
  final UserSettings? settings;

  @override
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class LoginField extends Object {
  LoginField({
    required this.user,
    required this.bearer,
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
    required this.login,
  });
  factory LoginData.fromJson(Map<String, dynamic> json) =>
      _$LoginDataFromJson(json);

  LoginField login;

  Map<String, dynamic> toJson() => _$LoginDataToJson(this);
}

@JsonSerializable()
class SignupData extends Object {
  SignupData({
    required this.signup,
  });
  factory SignupData.fromJson(Map<String, dynamic> json) =>
      _$SignupDataFromJson(json);

  LoginField signup;

  Map<String, dynamic> toJson() => _$SignupDataToJson(this);
}

@JsonSerializable()
class CurrentData extends Object {
  CurrentData({
    this.current,
  });
  factory CurrentData.fromJson(Map<String, dynamic> json) =>
      _$CurrentDataFromJson(json);

  User? current;

  Map<String, dynamic> toJson() => _$CurrentDataToJson(this);
}

@JsonSerializable()
class UserState {
  UserState({
    this.user,
    this.bearer,
    this.isLoading = false,
    this.initLoaded = false,
    this.errorMessage,
  });
  factory UserState.fromJson(Map<String, dynamic> json) =>
      _$UserStateFromJson(json);

  final User? user;
  final String? bearer;
  final bool isLoading;
  final bool initLoaded;
  final String? errorMessage;

  Map<String, dynamic> toJson() => _$UserStateToJson(this);
}

String userFragment = '''
  fragment user on User {
    _id
    email
    name
    picture
    settings {
      frontPage {
        route
      }
      notifications {
        enable
      }
    }
  }
''';
