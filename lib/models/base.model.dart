import 'package:json_annotation/json_annotation.dart';

abstract class BaseModel extends Object {
  @JsonKey(name: '_id', nullable: false)
  String id;

  Map<String, dynamic> toJson();
}

class ListState<T extends BaseModel> {
  ListState({
    this.fetching = false,
    this.items = const [],
  });

  final bool fetching;
  final List<T> items;

  Map<String, dynamic> toJson() => ({
        'fetching': false,
        'items': items.map((t) => t.toJson()).toList(),
      });
}
