import 'package:json_annotation/json_annotation.dart';

part 'base.model.g.dart';

@JsonSerializable()
class BaseModel extends Object {
  BaseModel({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : id = id ?? "",
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory BaseModel.fromJson(Map<String, dynamic> json) =>
      _$BaseModelFromJson(json);

  @JsonKey(name: '_id')
  String id;

  final DateTime createdAt;

  final DateTime updatedAt;

  Map<String, dynamic> toJson() => _$BaseModelToJson(this);
}

typedef CompareFunction<T extends BaseModel> = int Function(T, T);

List<T> _parseItems<T extends BaseModel>(
        List<dynamic> json, T Function(dynamic json) fromJson) =>
    json.map<T>(fromJson).toList();

class ListState<T extends BaseModel> {
  ListState({
    List<T>? items,
    this.sortBy = 'createdAt',
    this.fetching = false,
  }) : items = items ?? <T>[];

  ListState.fromJson(
      Map<String, dynamic> json, T Function(dynamic json) fromJson)
      : fetching = false,
        items = json != null && json['items'] != null
            ? _parseItems(json['items'], fromJson)
            : <T>[],
        sortBy = json['sortBy'] ?? 'createdAt';

  final bool fetching;
  final List<T> items;
  final String sortBy;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'items': items.map((t) => t.toJson()).toList(),
        'sortBy': sortBy,
      };

  ListState<T> copyWith({
    List<T>? items,
    String? sortBy,
    bool? fetching,
  }) =>
      ListState<T>(
        items: items == null ? this.items : items,
        sortBy: sortBy == null ? this.sortBy : sortBy,
        fetching: fetching == null ? this.fetching : fetching,
      );
}
