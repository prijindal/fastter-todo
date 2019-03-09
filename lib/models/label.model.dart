import 'package:json_annotation/json_annotation.dart';

import 'base.model.dart';
part 'label.model.g.dart';

@JsonSerializable()
class Label extends BaseModel {
  Label({
    this.id,
    this.title,
    this.createdAt,
    this.updatedAt,
  });

  factory Label.fromJson(Map<String, dynamic> json) => _$LabelFromJson(json);

  @JsonKey(name: '_id', nullable: false)
  final String id;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;

  Map<String, dynamic> toJson() => _$LabelToJson(this);
}
