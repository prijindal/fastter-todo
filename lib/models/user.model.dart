import 'package:json_annotation/json_annotation.dart';

part 'user.model.g.dart';

@JsonSerializable()
class User extends Object {
  User({
    this.id,
    this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  @JsonKey(name: '_id', nullable: false)
  final String id;
  final String email;

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
  LoginField current;
  factory CurrentData.fromJson(Map<String, dynamic> json) =>
      _$CurrentDataFromJson(json);

  Map<String, dynamic> toJson() => _$CurrentDataToJson(this);
}
