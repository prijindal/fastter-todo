import 'package:json_annotation/json_annotation.dart';

import 'label.model.dart';
import 'project.model.dart';
import 'todo.model.dart';
import 'todocomment.model.dart';
import 'todoreminder.model.dart';
part 'lazyaction.model.g.dart';

enum ActionType { add, delete, update }

@JsonSerializable()
class LazyAction {
  LazyAction(
    this.uuid,
    this.actionType,
    this.type, {
    this.actionid,
    this.action,
  });

  factory LazyAction.fromJson(Map<String, dynamic> json) =>
      _$LazyActionFromJson(json);

  final Map<String, dynamic>? action;
  final String? actionid;
  final ActionType actionType;
  @JsonKey(fromJson: _typeFromJson, toJson: _typeToJson)
  final Type type;
  final String uuid;

  Map<String, dynamic> toJson() => _$LazyActionToJson(this);
}

Type _typeFromJson(String type) {
  if (type == 'Project') {
    return Project;
  } else if (type == 'Todo') {
    return Todo;
  } else if (type == 'Label') {
    return Label;
  } else if (type == 'TodoReminder') {
    return TodoReminder;
  } else if (type == 'TodoComment') {
    return TodoComment;
  }
  return Null;
}

String _typeToJson(Type type) => type.toString();
