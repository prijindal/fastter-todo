// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FrontPage _$FrontPageFromJson(Map<String, dynamic> json) => FrontPage(
      route: json['route'] as String,
    );

Map<String, dynamic> _$FrontPageToJson(FrontPage instance) => <String, dynamic>{
      'route': instance.route,
    };

UserNotifiationsSettings _$UserNotifiationsSettingsFromJson(
        Map<String, dynamic> json) =>
    UserNotifiationsSettings(
      enable: json['enable'] as bool,
    );

Map<String, dynamic> _$UserNotifiationsSettingsToJson(
        UserNotifiationsSettings instance) =>
    <String, dynamic>{
      'enable': instance.enable,
    };

UserSettings _$UserSettingsFromJson(Map<String, dynamic> json) => UserSettings(
      frontPage: FrontPage.fromJson(json['frontPage'] as Map<String, dynamic>),
      notifications: UserNotifiationsSettings.fromJson(
          json['notifications'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserSettingsToJson(UserSettings instance) =>
    <String, dynamic>{
      'frontPage': instance.frontPage,
      'notifications': instance.notifications,
    };
