import 'package:json_annotation/json_annotation.dart';

import 'base.model.dart';
import 'label.model.dart';
import 'project.model.dart';
part 'todo.model.g.dart';

@JsonSerializable()
class Todo extends BaseModel {
  Todo({
    String? id,
    required this.title,
    this.completed = false,
    int? priority,
    DateTime? dueDate,
    this.encrypted = false,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.parent,
    this.project,
    this.labels = const <Label>[],
  })  : priority = priority ?? 1,
        dueDate = dueDate ?? DateTime.now(),
        super(
          id: id,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);

  String title;
  int priority;
  bool completed = false;
  bool encrypted = false;

  DateTime dueDate;

  Todo? parent;
  Project? project;
  List<Label> labels;

  @override
  Map<String, dynamic> toJson() => _$TodoToJson(this);

  Todo copyWith({
    bool? encrypted,
    String? title,
  }) =>
      Todo(
        id: id,
        title: title != null ? title : this.title,
        completed: completed,
        priority: priority,
        dueDate: dueDate,
        encrypted: encrypted != null ? encrypted : this.encrypted,
        createdAt: createdAt,
        updatedAt: updatedAt,
        parent: parent,
        project: project,
        labels: labels,
      );
}
