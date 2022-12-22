import 'package:json_annotation/json_annotation.dart';

import 'base.model.dart';
part 'label.model.g.dart';

@JsonSerializable()
class Label extends BaseModel {
  Label({
    String? id,
    required this.title,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(
          id: id,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  factory Label.fromJson(Map<String, dynamic> json) => _$LabelFromJson(json);

  final String title;

  @override
  Map<String, dynamic> toJson() => _$LabelToJson(this);
}
