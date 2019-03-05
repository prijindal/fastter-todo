import 'package:json_annotation/json_annotation.dart';

import 'base.model.dart';
part 'project.model.g.dart';

@JsonSerializable()
class Project extends BaseModel {
  Project({
    this.id,
    this.title,
    this.color,
    this.createdAt,
    this.updatedAt,
  });

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);

  @JsonKey(name: '_id', nullable: false)
  final String id;
  final String title;
  final String color;
  final DateTime createdAt;
  final DateTime updatedAt;

  Map<String, dynamic> toJson() => _$ProjectToJson(this);
}
