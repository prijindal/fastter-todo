import 'package:json_annotation/json_annotation.dart';

import 'base.model.dart';
part 'notification.model.g.dart';

enum NotificationType {
  image,
  text,
}

@JsonSerializable()
class Notification extends BaseModel {
  Notification({
    String? id,
    required this.title,
    required this.body,
    required this.read,
    required this.data,
    required this.route,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(
          id: id,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  factory Notification.fromJson(Map<String, dynamic> json) =>
      _$NotificationFromJson(json);

  final String title;
  final String body;
  bool read;
  final Map<String, dynamic> data;
  final String route;

  @override
  Map<String, dynamic> toJson() => _$NotificationToJson(this);
}
