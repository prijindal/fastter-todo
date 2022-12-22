import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';

part 'settings.model.g.dart';

@JsonSerializable()
class FrontPage {
  FrontPage({
    required this.route,
    this.title,
  });

  factory FrontPage.fromJson(Map<String, dynamic> json) =>
      _$FrontPageFromJson(json);

  final String route;
  @JsonKey(ignore: true)
  final String? title;

  Map<String, dynamic> toJson() => _$FrontPageToJson(this);
}

@JsonSerializable()
class UserNotifiationsSettings {
  UserNotifiationsSettings({
    required this.enable,
  });

  factory UserNotifiationsSettings.fromJson(Map<String, dynamic> json) =>
      _$UserNotifiationsSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$UserNotifiationsSettingsToJson(this);

  final bool enable;
}

@JsonSerializable()
class UserSettings {
  UserSettings({
    required this.frontPage,
    required this.notifications,
  });

  factory UserSettings.fromJson(Map<String, dynamic> json) =>
      _$UserSettingsFromJson(json);

  final FrontPage frontPage;
  final UserNotifiationsSettings notifications;

  Map<String, dynamic> toJson() => _$UserSettingsToJson(this);
}
