import 'package:json_annotation/json_annotation.dart';

import 'base.model.dart';
part 'project.model.g.dart';

@JsonSerializable()
class Project extends BaseModel {
  Project({
    String? id,
    required this.title,
    required this.color,
    this.index,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(
          id: id,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);

  final String title;
  final String color;
  final int? index;

  @override
  Map<String, dynamic> toJson() => _$ProjectToJson(this);
}
