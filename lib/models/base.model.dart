import 'package:json_annotation/json_annotation.dart';

abstract class BaseModel extends Object {
  @JsonKey(name: '_id', nullable: false)
  String id;

  Map<String, dynamic> toJson();
}

class ListState<T extends BaseModel> {
  ListState({
    this.fetching = false,
    this.datas = const [],
  });
  final bool fetching;
  final List<T> datas;
}
