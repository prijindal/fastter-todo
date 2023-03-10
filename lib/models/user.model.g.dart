// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['_id'] as String?,
      email: json['email'] as String?,
      name: json['name'] as String?,
      picture: json['picture'] as String?,
      settings: json['settings'] == null
          ? null
          : UserSettings.fromJson(json['settings'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      '_id': instance.id,
      'email': instance.email,
      'picture': instance.picture,
      'name': instance.name,
      'settings': instance.settings,
    };

LoginField _$LoginFieldFromJson(Map<String, dynamic> json) => LoginField(
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      bearer: json['bearer'] as String,
    );

Map<String, dynamic> _$LoginFieldToJson(LoginField instance) =>
    <String, dynamic>{
      'user': instance.user,
      'bearer': instance.bearer,
    };

LoginData _$LoginDataFromJson(Map<String, dynamic> json) => LoginData(
      login: LoginField.fromJson(json['login'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LoginDataToJson(LoginData instance) => <String, dynamic>{
      'login': instance.login,
    };

SignupData _$SignupDataFromJson(Map<String, dynamic> json) => SignupData(
      signup: LoginField.fromJson(json['signup'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SignupDataToJson(SignupData instance) =>
    <String, dynamic>{
      'signup': instance.signup,
    };

CurrentData _$CurrentDataFromJson(Map<String, dynamic> json) => CurrentData(
      current: json['current'] == null
          ? null
          : User.fromJson(json['current'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CurrentDataToJson(CurrentData instance) =>
    <String, dynamic>{
      'current': instance.current,
    };

UserState _$UserStateFromJson(Map<String, dynamic> json) => UserState(
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      bearer: json['bearer'] as String?,
      isLoading: json['isLoading'] as bool? ?? false,
      initLoaded: json['initLoaded'] as bool? ?? false,
      errorMessage: json['errorMessage'] as String?,
    );

Map<String, dynamic> _$UserStateToJson(UserState instance) => <String, dynamic>{
      'user': instance.user,
      'bearer': instance.bearer,
      'isLoading': instance.isLoading,
      'initLoaded': instance.initLoaded,
      'errorMessage': instance.errorMessage,
    };
