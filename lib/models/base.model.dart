import 'package:json_annotation/json_annotation.dart';

abstract class BaseModel extends Object {
  @JsonKey(name: '_id', nullable: false)
  String id;

  Map<String, dynamic> toJson();
}

class ListState<T extends BaseModel> {
  ListState({
    this.fetching = false,
    this.adding = false,
    this.deleting = false,
    this.updating = false,
    this.items = const [],
  });

  final bool fetching;
  final bool adding;
  final bool deleting;
  final bool updating;
  final List<T> items;

  Map<String, dynamic> toJson() => ({
        'fetching': false,
        'adding': false,
        'deleting': false,
        'updating': false,
        'items': items.map((t) => t.toJson()).toList(),
      });
}

DateTime dateFromJson(String date) => DateTime.parse(date).toLocal();
