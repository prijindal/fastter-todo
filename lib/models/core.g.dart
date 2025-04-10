// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'core.dart';

// ignore_for_file: type=lint
class $TodoTable extends Todo with TableInfo<$TodoTable, TodoData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TodoTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => _uuid.v4());
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _priorityMeta =
      const VerificationMeta('priority');
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
      'priority', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      clientDefault: () => 1);
  static const VerificationMeta _pipelineMeta =
      const VerificationMeta('pipeline');
  @override
  late final GeneratedColumn<String> pipeline = GeneratedColumn<String>(
      'pipeline', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => defaultPipeline);
  static const VerificationMeta _completedMeta =
      const VerificationMeta('completed');
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
      'completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("completed" IN (0, 1))'),
      clientDefault: () => false);
  static const VerificationMeta _dueDateMeta =
      const VerificationMeta('dueDate');
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
      'due_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _creationTimeMeta =
      const VerificationMeta('creationTime');
  @override
  late final GeneratedColumn<DateTime> creationTime = GeneratedColumn<DateTime>(
      'creation_time', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  static const VerificationMeta _projectMeta =
      const VerificationMeta('project');
  @override
  late final GeneratedColumn<String> project = GeneratedColumn<String>(
      'project', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _parentMeta = const VerificationMeta('parent');
  @override
  late final GeneratedColumn<String> parent = GeneratedColumn<String>(
      'parent', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> tags =
      GeneratedColumn<String>('tags', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              clientDefault: () => jsonEncode([]))
          .withConverter<List<String>>($TodoTable.$convertertags);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        priority,
        pipeline,
        completed,
        dueDate,
        creationTime,
        project,
        parent,
        tags
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'todo';
  @override
  VerificationContext validateIntegrity(Insertable<TodoData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('priority')) {
      context.handle(_priorityMeta,
          priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta));
    }
    if (data.containsKey('pipeline')) {
      context.handle(_pipelineMeta,
          pipeline.isAcceptableOrUnknown(data['pipeline']!, _pipelineMeta));
    }
    if (data.containsKey('completed')) {
      context.handle(_completedMeta,
          completed.isAcceptableOrUnknown(data['completed']!, _completedMeta));
    }
    if (data.containsKey('due_date')) {
      context.handle(_dueDateMeta,
          dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta));
    }
    if (data.containsKey('creation_time')) {
      context.handle(
          _creationTimeMeta,
          creationTime.isAcceptableOrUnknown(
              data['creation_time']!, _creationTimeMeta));
    }
    if (data.containsKey('project')) {
      context.handle(_projectMeta,
          project.isAcceptableOrUnknown(data['project']!, _projectMeta));
    }
    if (data.containsKey('parent')) {
      context.handle(_parentMeta,
          parent.isAcceptableOrUnknown(data['parent']!, _parentMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TodoData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TodoData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      priority: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}priority'])!,
      pipeline: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pipeline'])!,
      completed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}completed'])!,
      dueDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}due_date']),
      creationTime: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}creation_time'])!,
      project: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}project']),
      parent: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}parent']),
      tags: $TodoTable.$convertertags.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tags'])!),
    );
  }

  @override
  $TodoTable createAlias(String alias) {
    return $TodoTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<List<String>, String, String> $convertertags =
      const StringListConverter();
}

class TodoData extends DataClass implements Insertable<TodoData> {
  final String id;
  final String title;
  final int priority;
  final String pipeline;
  final bool completed;
  final DateTime? dueDate;
  final DateTime creationTime;
  final String? project;
  final String? parent;
  final List<String> tags;
  const TodoData(
      {required this.id,
      required this.title,
      required this.priority,
      required this.pipeline,
      required this.completed,
      this.dueDate,
      required this.creationTime,
      this.project,
      this.parent,
      required this.tags});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['priority'] = Variable<int>(priority);
    map['pipeline'] = Variable<String>(pipeline);
    map['completed'] = Variable<bool>(completed);
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<DateTime>(dueDate);
    }
    map['creation_time'] = Variable<DateTime>(creationTime);
    if (!nullToAbsent || project != null) {
      map['project'] = Variable<String>(project);
    }
    if (!nullToAbsent || parent != null) {
      map['parent'] = Variable<String>(parent);
    }
    {
      map['tags'] = Variable<String>($TodoTable.$convertertags.toSql(tags));
    }
    return map;
  }

  TodoCompanion toCompanion(bool nullToAbsent) {
    return TodoCompanion(
      id: Value(id),
      title: Value(title),
      priority: Value(priority),
      pipeline: Value(pipeline),
      completed: Value(completed),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      creationTime: Value(creationTime),
      project: project == null && nullToAbsent
          ? const Value.absent()
          : Value(project),
      parent:
          parent == null && nullToAbsent ? const Value.absent() : Value(parent),
      tags: Value(tags),
    );
  }

  factory TodoData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TodoData(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      priority: serializer.fromJson<int>(json['priority']),
      pipeline: serializer.fromJson<String>(json['pipeline']),
      completed: serializer.fromJson<bool>(json['completed']),
      dueDate: serializer.fromJson<DateTime?>(json['dueDate']),
      creationTime: serializer.fromJson<DateTime>(json['creationTime']),
      project: serializer.fromJson<String?>(json['project']),
      parent: serializer.fromJson<String?>(json['parent']),
      tags: $TodoTable.$convertertags
          .fromJson(serializer.fromJson<String>(json['tags'])),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'priority': serializer.toJson<int>(priority),
      'pipeline': serializer.toJson<String>(pipeline),
      'completed': serializer.toJson<bool>(completed),
      'dueDate': serializer.toJson<DateTime?>(dueDate),
      'creationTime': serializer.toJson<DateTime>(creationTime),
      'project': serializer.toJson<String?>(project),
      'parent': serializer.toJson<String?>(parent),
      'tags': serializer.toJson<String>($TodoTable.$convertertags.toJson(tags)),
    };
  }

  TodoData copyWith(
          {String? id,
          String? title,
          int? priority,
          String? pipeline,
          bool? completed,
          Value<DateTime?> dueDate = const Value.absent(),
          DateTime? creationTime,
          Value<String?> project = const Value.absent(),
          Value<String?> parent = const Value.absent(),
          List<String>? tags}) =>
      TodoData(
        id: id ?? this.id,
        title: title ?? this.title,
        priority: priority ?? this.priority,
        pipeline: pipeline ?? this.pipeline,
        completed: completed ?? this.completed,
        dueDate: dueDate.present ? dueDate.value : this.dueDate,
        creationTime: creationTime ?? this.creationTime,
        project: project.present ? project.value : this.project,
        parent: parent.present ? parent.value : this.parent,
        tags: tags ?? this.tags,
      );
  TodoData copyWithCompanion(TodoCompanion data) {
    return TodoData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      priority: data.priority.present ? data.priority.value : this.priority,
      pipeline: data.pipeline.present ? data.pipeline.value : this.pipeline,
      completed: data.completed.present ? data.completed.value : this.completed,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      creationTime: data.creationTime.present
          ? data.creationTime.value
          : this.creationTime,
      project: data.project.present ? data.project.value : this.project,
      parent: data.parent.present ? data.parent.value : this.parent,
      tags: data.tags.present ? data.tags.value : this.tags,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TodoData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('priority: $priority, ')
          ..write('pipeline: $pipeline, ')
          ..write('completed: $completed, ')
          ..write('dueDate: $dueDate, ')
          ..write('creationTime: $creationTime, ')
          ..write('project: $project, ')
          ..write('parent: $parent, ')
          ..write('tags: $tags')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, priority, pipeline, completed,
      dueDate, creationTime, project, parent, tags);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TodoData &&
          other.id == this.id &&
          other.title == this.title &&
          other.priority == this.priority &&
          other.pipeline == this.pipeline &&
          other.completed == this.completed &&
          other.dueDate == this.dueDate &&
          other.creationTime == this.creationTime &&
          other.project == this.project &&
          other.parent == this.parent &&
          other.tags == this.tags);
}

class TodoCompanion extends UpdateCompanion<TodoData> {
  final Value<String> id;
  final Value<String> title;
  final Value<int> priority;
  final Value<String> pipeline;
  final Value<bool> completed;
  final Value<DateTime?> dueDate;
  final Value<DateTime> creationTime;
  final Value<String?> project;
  final Value<String?> parent;
  final Value<List<String>> tags;
  final Value<int> rowid;
  const TodoCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.priority = const Value.absent(),
    this.pipeline = const Value.absent(),
    this.completed = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.creationTime = const Value.absent(),
    this.project = const Value.absent(),
    this.parent = const Value.absent(),
    this.tags = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TodoCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    this.priority = const Value.absent(),
    this.pipeline = const Value.absent(),
    this.completed = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.creationTime = const Value.absent(),
    this.project = const Value.absent(),
    this.parent = const Value.absent(),
    this.tags = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : title = Value(title);
  static Insertable<TodoData> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<int>? priority,
    Expression<String>? pipeline,
    Expression<bool>? completed,
    Expression<DateTime>? dueDate,
    Expression<DateTime>? creationTime,
    Expression<String>? project,
    Expression<String>? parent,
    Expression<String>? tags,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (priority != null) 'priority': priority,
      if (pipeline != null) 'pipeline': pipeline,
      if (completed != null) 'completed': completed,
      if (dueDate != null) 'due_date': dueDate,
      if (creationTime != null) 'creation_time': creationTime,
      if (project != null) 'project': project,
      if (parent != null) 'parent': parent,
      if (tags != null) 'tags': tags,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TodoCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<int>? priority,
      Value<String>? pipeline,
      Value<bool>? completed,
      Value<DateTime?>? dueDate,
      Value<DateTime>? creationTime,
      Value<String?>? project,
      Value<String?>? parent,
      Value<List<String>>? tags,
      Value<int>? rowid}) {
    return TodoCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      priority: priority ?? this.priority,
      pipeline: pipeline ?? this.pipeline,
      completed: completed ?? this.completed,
      dueDate: dueDate ?? this.dueDate,
      creationTime: creationTime ?? this.creationTime,
      project: project ?? this.project,
      parent: parent ?? this.parent,
      tags: tags ?? this.tags,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (pipeline.present) {
      map['pipeline'] = Variable<String>(pipeline.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (creationTime.present) {
      map['creation_time'] = Variable<DateTime>(creationTime.value);
    }
    if (project.present) {
      map['project'] = Variable<String>(project.value);
    }
    if (parent.present) {
      map['parent'] = Variable<String>(parent.value);
    }
    if (tags.present) {
      map['tags'] =
          Variable<String>($TodoTable.$convertertags.toSql(tags.value));
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TodoCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('priority: $priority, ')
          ..write('pipeline: $pipeline, ')
          ..write('completed: $completed, ')
          ..write('dueDate: $dueDate, ')
          ..write('creationTime: $creationTime, ')
          ..write('project: $project, ')
          ..write('parent: $parent, ')
          ..write('tags: $tags, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProjectTable extends Project with TableInfo<$ProjectTable, ProjectData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProjectTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => _uuid.v4());
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
      'color', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> pipelines =
      GeneratedColumn<String>('pipelines', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              clientDefault: () => jsonEncode([defaultPipeline]))
          .withConverter<List<String>>($ProjectTable.$converterpipelines);
  @override
  List<GeneratedColumn> get $columns => [id, title, color, pipelines];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'project';
  @override
  VerificationContext validateIntegrity(Insertable<ProjectData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProjectData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProjectData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      color: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}color'])!,
      pipelines: $ProjectTable.$converterpipelines.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pipelines'])!),
    );
  }

  @override
  $ProjectTable createAlias(String alias) {
    return $ProjectTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<List<String>, String, String> $converterpipelines =
      const StringListConverter();
}

class ProjectData extends DataClass implements Insertable<ProjectData> {
  final String id;
  final String title;
  final String color;
  final List<String> pipelines;
  const ProjectData(
      {required this.id,
      required this.title,
      required this.color,
      required this.pipelines});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['color'] = Variable<String>(color);
    {
      map['pipelines'] =
          Variable<String>($ProjectTable.$converterpipelines.toSql(pipelines));
    }
    return map;
  }

  ProjectCompanion toCompanion(bool nullToAbsent) {
    return ProjectCompanion(
      id: Value(id),
      title: Value(title),
      color: Value(color),
      pipelines: Value(pipelines),
    );
  }

  factory ProjectData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProjectData(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      color: serializer.fromJson<String>(json['color']),
      pipelines: $ProjectTable.$converterpipelines
          .fromJson(serializer.fromJson<String>(json['pipelines'])),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'color': serializer.toJson<String>(color),
      'pipelines': serializer
          .toJson<String>($ProjectTable.$converterpipelines.toJson(pipelines)),
    };
  }

  ProjectData copyWith(
          {String? id,
          String? title,
          String? color,
          List<String>? pipelines}) =>
      ProjectData(
        id: id ?? this.id,
        title: title ?? this.title,
        color: color ?? this.color,
        pipelines: pipelines ?? this.pipelines,
      );
  ProjectData copyWithCompanion(ProjectCompanion data) {
    return ProjectData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      color: data.color.present ? data.color.value : this.color,
      pipelines: data.pipelines.present ? data.pipelines.value : this.pipelines,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProjectData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('color: $color, ')
          ..write('pipelines: $pipelines')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, color, pipelines);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProjectData &&
          other.id == this.id &&
          other.title == this.title &&
          other.color == this.color &&
          other.pipelines == this.pipelines);
}

class ProjectCompanion extends UpdateCompanion<ProjectData> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> color;
  final Value<List<String>> pipelines;
  final Value<int> rowid;
  const ProjectCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.color = const Value.absent(),
    this.pipelines = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProjectCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String color,
    this.pipelines = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : title = Value(title),
        color = Value(color);
  static Insertable<ProjectData> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? color,
    Expression<String>? pipelines,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (color != null) 'color': color,
      if (pipelines != null) 'pipelines': pipelines,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProjectCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? color,
      Value<List<String>>? pipelines,
      Value<int>? rowid}) {
    return ProjectCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      color: color ?? this.color,
      pipelines: pipelines ?? this.pipelines,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (pipelines.present) {
      map['pipelines'] = Variable<String>(
          $ProjectTable.$converterpipelines.toSql(pipelines.value));
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProjectCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('color: $color, ')
          ..write('pipelines: $pipelines, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CommentTable extends Comment with TableInfo<$CommentTable, CommentData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CommentTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => _uuid.v4());
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<Uint8List> content = GeneratedColumn<Uint8List>(
      'content', aliasedName, false,
      type: DriftSqlType.blob, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<TodoCommentType, String> type =
      GeneratedColumn<String>('type', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<TodoCommentType>($CommentTable.$convertertype);
  static const VerificationMeta _todoMeta = const VerificationMeta('todo');
  @override
  late final GeneratedColumn<String> todo = GeneratedColumn<String>(
      'todo', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _creationTimeMeta =
      const VerificationMeta('creationTime');
  @override
  late final GeneratedColumn<DateTime> creationTime = GeneratedColumn<DateTime>(
      'creation_time', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  @override
  List<GeneratedColumn> get $columns => [id, content, type, todo, creationTime];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'comment';
  @override
  VerificationContext validateIntegrity(Insertable<CommentData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('todo')) {
      context.handle(
          _todoMeta, todo.isAcceptableOrUnknown(data['todo']!, _todoMeta));
    } else if (isInserting) {
      context.missing(_todoMeta);
    }
    if (data.containsKey('creation_time')) {
      context.handle(
          _creationTimeMeta,
          creationTime.isAcceptableOrUnknown(
              data['creation_time']!, _creationTimeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CommentData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CommentData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.blob, data['${effectivePrefix}content'])!,
      type: $CommentTable.$convertertype.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!),
      todo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}todo'])!,
      creationTime: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}creation_time'])!,
    );
  }

  @override
  $CommentTable createAlias(String alias) {
    return $CommentTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TodoCommentType, String, String> $convertertype =
      const EnumNameConverter<TodoCommentType>(TodoCommentType.values);
}

class CommentData extends DataClass implements Insertable<CommentData> {
  final String id;
  final Uint8List content;
  final TodoCommentType type;
  final String todo;
  final DateTime creationTime;
  const CommentData(
      {required this.id,
      required this.content,
      required this.type,
      required this.todo,
      required this.creationTime});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['content'] = Variable<Uint8List>(content);
    {
      map['type'] = Variable<String>($CommentTable.$convertertype.toSql(type));
    }
    map['todo'] = Variable<String>(todo);
    map['creation_time'] = Variable<DateTime>(creationTime);
    return map;
  }

  CommentCompanion toCompanion(bool nullToAbsent) {
    return CommentCompanion(
      id: Value(id),
      content: Value(content),
      type: Value(type),
      todo: Value(todo),
      creationTime: Value(creationTime),
    );
  }

  factory CommentData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CommentData(
      id: serializer.fromJson<String>(json['id']),
      content: serializer.fromJson<Uint8List>(json['content']),
      type: $CommentTable.$convertertype
          .fromJson(serializer.fromJson<String>(json['type'])),
      todo: serializer.fromJson<String>(json['todo']),
      creationTime: serializer.fromJson<DateTime>(json['creationTime']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'content': serializer.toJson<Uint8List>(content),
      'type':
          serializer.toJson<String>($CommentTable.$convertertype.toJson(type)),
      'todo': serializer.toJson<String>(todo),
      'creationTime': serializer.toJson<DateTime>(creationTime),
    };
  }

  CommentData copyWith(
          {String? id,
          Uint8List? content,
          TodoCommentType? type,
          String? todo,
          DateTime? creationTime}) =>
      CommentData(
        id: id ?? this.id,
        content: content ?? this.content,
        type: type ?? this.type,
        todo: todo ?? this.todo,
        creationTime: creationTime ?? this.creationTime,
      );
  CommentData copyWithCompanion(CommentCompanion data) {
    return CommentData(
      id: data.id.present ? data.id.value : this.id,
      content: data.content.present ? data.content.value : this.content,
      type: data.type.present ? data.type.value : this.type,
      todo: data.todo.present ? data.todo.value : this.todo,
      creationTime: data.creationTime.present
          ? data.creationTime.value
          : this.creationTime,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CommentData(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('type: $type, ')
          ..write('todo: $todo, ')
          ..write('creationTime: $creationTime')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, $driftBlobEquality.hash(content), type, todo, creationTime);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CommentData &&
          other.id == this.id &&
          $driftBlobEquality.equals(other.content, this.content) &&
          other.type == this.type &&
          other.todo == this.todo &&
          other.creationTime == this.creationTime);
}

class CommentCompanion extends UpdateCompanion<CommentData> {
  final Value<String> id;
  final Value<Uint8List> content;
  final Value<TodoCommentType> type;
  final Value<String> todo;
  final Value<DateTime> creationTime;
  final Value<int> rowid;
  const CommentCompanion({
    this.id = const Value.absent(),
    this.content = const Value.absent(),
    this.type = const Value.absent(),
    this.todo = const Value.absent(),
    this.creationTime = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CommentCompanion.insert({
    this.id = const Value.absent(),
    required Uint8List content,
    required TodoCommentType type,
    required String todo,
    this.creationTime = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : content = Value(content),
        type = Value(type),
        todo = Value(todo);
  static Insertable<CommentData> custom({
    Expression<String>? id,
    Expression<Uint8List>? content,
    Expression<String>? type,
    Expression<String>? todo,
    Expression<DateTime>? creationTime,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (content != null) 'content': content,
      if (type != null) 'type': type,
      if (todo != null) 'todo': todo,
      if (creationTime != null) 'creation_time': creationTime,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CommentCompanion copyWith(
      {Value<String>? id,
      Value<Uint8List>? content,
      Value<TodoCommentType>? type,
      Value<String>? todo,
      Value<DateTime>? creationTime,
      Value<int>? rowid}) {
    return CommentCompanion(
      id: id ?? this.id,
      content: content ?? this.content,
      type: type ?? this.type,
      todo: todo ?? this.todo,
      creationTime: creationTime ?? this.creationTime,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (content.present) {
      map['content'] = Variable<Uint8List>(content.value);
    }
    if (type.present) {
      map['type'] =
          Variable<String>($CommentTable.$convertertype.toSql(type.value));
    }
    if (todo.present) {
      map['todo'] = Variable<String>(todo.value);
    }
    if (creationTime.present) {
      map['creation_time'] = Variable<DateTime>(creationTime.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CommentCompanion(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('type: $type, ')
          ..write('todo: $todo, ')
          ..write('creationTime: $creationTime, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReminderTable extends Reminder
    with TableInfo<$ReminderTable, ReminderData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReminderTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => _uuid.v4());
  static const VerificationMeta _timeMeta = const VerificationMeta('time');
  @override
  late final GeneratedColumn<DateTime> time = GeneratedColumn<DateTime>(
      'time', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _completedMeta =
      const VerificationMeta('completed');
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
      'completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("completed" IN (0, 1))'),
      clientDefault: () => false);
  static const VerificationMeta _todoMeta = const VerificationMeta('todo');
  @override
  late final GeneratedColumn<String> todo = GeneratedColumn<String>(
      'todo', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, time, completed, todo];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminder';
  @override
  VerificationContext validateIntegrity(Insertable<ReminderData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('time')) {
      context.handle(
          _timeMeta, time.isAcceptableOrUnknown(data['time']!, _timeMeta));
    } else if (isInserting) {
      context.missing(_timeMeta);
    }
    if (data.containsKey('completed')) {
      context.handle(_completedMeta,
          completed.isAcceptableOrUnknown(data['completed']!, _completedMeta));
    }
    if (data.containsKey('todo')) {
      context.handle(
          _todoMeta, todo.isAcceptableOrUnknown(data['todo']!, _todoMeta));
    } else if (isInserting) {
      context.missing(_todoMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReminderData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReminderData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      time: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}time'])!,
      completed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}completed'])!,
      todo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}todo'])!,
    );
  }

  @override
  $ReminderTable createAlias(String alias) {
    return $ReminderTable(attachedDatabase, alias);
  }
}

class ReminderData extends DataClass implements Insertable<ReminderData> {
  final String id;
  final DateTime time;
  final bool completed;
  final String todo;
  const ReminderData(
      {required this.id,
      required this.time,
      required this.completed,
      required this.todo});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['time'] = Variable<DateTime>(time);
    map['completed'] = Variable<bool>(completed);
    map['todo'] = Variable<String>(todo);
    return map;
  }

  ReminderCompanion toCompanion(bool nullToAbsent) {
    return ReminderCompanion(
      id: Value(id),
      time: Value(time),
      completed: Value(completed),
      todo: Value(todo),
    );
  }

  factory ReminderData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReminderData(
      id: serializer.fromJson<String>(json['id']),
      time: serializer.fromJson<DateTime>(json['time']),
      completed: serializer.fromJson<bool>(json['completed']),
      todo: serializer.fromJson<String>(json['todo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'time': serializer.toJson<DateTime>(time),
      'completed': serializer.toJson<bool>(completed),
      'todo': serializer.toJson<String>(todo),
    };
  }

  ReminderData copyWith(
          {String? id, DateTime? time, bool? completed, String? todo}) =>
      ReminderData(
        id: id ?? this.id,
        time: time ?? this.time,
        completed: completed ?? this.completed,
        todo: todo ?? this.todo,
      );
  ReminderData copyWithCompanion(ReminderCompanion data) {
    return ReminderData(
      id: data.id.present ? data.id.value : this.id,
      time: data.time.present ? data.time.value : this.time,
      completed: data.completed.present ? data.completed.value : this.completed,
      todo: data.todo.present ? data.todo.value : this.todo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReminderData(')
          ..write('id: $id, ')
          ..write('time: $time, ')
          ..write('completed: $completed, ')
          ..write('todo: $todo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, time, completed, todo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReminderData &&
          other.id == this.id &&
          other.time == this.time &&
          other.completed == this.completed &&
          other.todo == this.todo);
}

class ReminderCompanion extends UpdateCompanion<ReminderData> {
  final Value<String> id;
  final Value<DateTime> time;
  final Value<bool> completed;
  final Value<String> todo;
  final Value<int> rowid;
  const ReminderCompanion({
    this.id = const Value.absent(),
    this.time = const Value.absent(),
    this.completed = const Value.absent(),
    this.todo = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReminderCompanion.insert({
    this.id = const Value.absent(),
    required DateTime time,
    this.completed = const Value.absent(),
    required String todo,
    this.rowid = const Value.absent(),
  })  : time = Value(time),
        todo = Value(todo);
  static Insertable<ReminderData> custom({
    Expression<String>? id,
    Expression<DateTime>? time,
    Expression<bool>? completed,
    Expression<String>? todo,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (time != null) 'time': time,
      if (completed != null) 'completed': completed,
      if (todo != null) 'todo': todo,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReminderCompanion copyWith(
      {Value<String>? id,
      Value<DateTime>? time,
      Value<bool>? completed,
      Value<String>? todo,
      Value<int>? rowid}) {
    return ReminderCompanion(
      id: id ?? this.id,
      time: time ?? this.time,
      completed: completed ?? this.completed,
      todo: todo ?? this.todo,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (time.present) {
      map['time'] = Variable<DateTime>(time.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    if (todo.present) {
      map['todo'] = Variable<String>(todo.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReminderCompanion(')
          ..write('id: $id, ')
          ..write('time: $time, ')
          ..write('completed: $completed, ')
          ..write('todo: $todo, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EntityActionsQueueTable extends EntityActionsQueue
    with TableInfo<$EntityActionsQueueTable, EntityActionsQueueData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EntityActionsQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _requestIdMeta =
      const VerificationMeta('requestId');
  @override
  late final GeneratedColumn<String> requestId = GeneratedColumn<String>(
      'request_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => _uuid.v4());
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
      'action', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>, String>
      payload = GeneratedColumn<String>('payload', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<Map<String, dynamic>>(
              $EntityActionsQueueTable.$converterpayload);
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [requestId, id, name, action, payload, timestamp];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'entity_actions_queue';
  @override
  VerificationContext validateIntegrity(
      Insertable<EntityActionsQueueData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('request_id')) {
      context.handle(_requestIdMeta,
          requestId.isAcceptableOrUnknown(data['request_id']!, _requestIdMeta));
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('action')) {
      context.handle(_actionMeta,
          action.isAcceptableOrUnknown(data['action']!, _actionMeta));
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {requestId};
  @override
  EntityActionsQueueData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EntityActionsQueueData(
      requestId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}request_id'])!,
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      action: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}action'])!,
      payload: $EntityActionsQueueTable.$converterpayload.fromSql(
          attachedDatabase.typeMapping
              .read(DriftSqlType.string, data['${effectivePrefix}payload'])!),
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}timestamp'])!,
    );
  }

  @override
  $EntityActionsQueueTable createAlias(String alias) {
    return $EntityActionsQueueTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Map<String, dynamic>, String, String>
      $converterpayload = const JsonConverter();
}

class EntityActionsQueueData extends DataClass
    implements Insertable<EntityActionsQueueData> {
  final String requestId;
  final String id;
  final String name;
  final String action;
  final Map<String, dynamic> payload;
  final DateTime timestamp;
  const EntityActionsQueueData(
      {required this.requestId,
      required this.id,
      required this.name,
      required this.action,
      required this.payload,
      required this.timestamp});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['request_id'] = Variable<String>(requestId);
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['action'] = Variable<String>(action);
    {
      map['payload'] = Variable<String>(
          $EntityActionsQueueTable.$converterpayload.toSql(payload));
    }
    map['timestamp'] = Variable<DateTime>(timestamp);
    return map;
  }

  EntityActionsQueueCompanion toCompanion(bool nullToAbsent) {
    return EntityActionsQueueCompanion(
      requestId: Value(requestId),
      id: Value(id),
      name: Value(name),
      action: Value(action),
      payload: Value(payload),
      timestamp: Value(timestamp),
    );
  }

  factory EntityActionsQueueData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EntityActionsQueueData(
      requestId: serializer.fromJson<String>(json['requestId']),
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      action: serializer.fromJson<String>(json['action']),
      payload: $EntityActionsQueueTable.$converterpayload
          .fromJson(serializer.fromJson<String>(json['payload'])),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'requestId': serializer.toJson<String>(requestId),
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'action': serializer.toJson<String>(action),
      'payload': serializer.toJson<String>(
          $EntityActionsQueueTable.$converterpayload.toJson(payload)),
      'timestamp': serializer.toJson<DateTime>(timestamp),
    };
  }

  EntityActionsQueueData copyWith(
          {String? requestId,
          String? id,
          String? name,
          String? action,
          Map<String, dynamic>? payload,
          DateTime? timestamp}) =>
      EntityActionsQueueData(
        requestId: requestId ?? this.requestId,
        id: id ?? this.id,
        name: name ?? this.name,
        action: action ?? this.action,
        payload: payload ?? this.payload,
        timestamp: timestamp ?? this.timestamp,
      );
  EntityActionsQueueData copyWithCompanion(EntityActionsQueueCompanion data) {
    return EntityActionsQueueData(
      requestId: data.requestId.present ? data.requestId.value : this.requestId,
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      action: data.action.present ? data.action.value : this.action,
      payload: data.payload.present ? data.payload.value : this.payload,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EntityActionsQueueData(')
          ..write('requestId: $requestId, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('action: $action, ')
          ..write('payload: $payload, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(requestId, id, name, action, payload, timestamp);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EntityActionsQueueData &&
          other.requestId == this.requestId &&
          other.id == this.id &&
          other.name == this.name &&
          other.action == this.action &&
          other.payload == this.payload &&
          other.timestamp == this.timestamp);
}

class EntityActionsQueueCompanion
    extends UpdateCompanion<EntityActionsQueueData> {
  final Value<String> requestId;
  final Value<String> id;
  final Value<String> name;
  final Value<String> action;
  final Value<Map<String, dynamic>> payload;
  final Value<DateTime> timestamp;
  final Value<int> rowid;
  const EntityActionsQueueCompanion({
    this.requestId = const Value.absent(),
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.action = const Value.absent(),
    this.payload = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EntityActionsQueueCompanion.insert({
    this.requestId = const Value.absent(),
    required String id,
    required String name,
    required String action,
    required Map<String, dynamic> payload,
    required DateTime timestamp,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        action = Value(action),
        payload = Value(payload),
        timestamp = Value(timestamp);
  static Insertable<EntityActionsQueueData> custom({
    Expression<String>? requestId,
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? action,
    Expression<String>? payload,
    Expression<DateTime>? timestamp,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (requestId != null) 'request_id': requestId,
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (action != null) 'action': action,
      if (payload != null) 'payload': payload,
      if (timestamp != null) 'timestamp': timestamp,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EntityActionsQueueCompanion copyWith(
      {Value<String>? requestId,
      Value<String>? id,
      Value<String>? name,
      Value<String>? action,
      Value<Map<String, dynamic>>? payload,
      Value<DateTime>? timestamp,
      Value<int>? rowid}) {
    return EntityActionsQueueCompanion(
      requestId: requestId ?? this.requestId,
      id: id ?? this.id,
      name: name ?? this.name,
      action: action ?? this.action,
      payload: payload ?? this.payload,
      timestamp: timestamp ?? this.timestamp,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (requestId.present) {
      map['request_id'] = Variable<String>(requestId.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(
          $EntityActionsQueueTable.$converterpayload.toSql(payload.value));
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EntityActionsQueueCompanion(')
          ..write('requestId: $requestId, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('action: $action, ')
          ..write('payload: $payload, ')
          ..write('timestamp: $timestamp, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$SharedDatabase extends GeneratedDatabase {
  _$SharedDatabase(QueryExecutor e) : super(e);
  $SharedDatabaseManager get managers => $SharedDatabaseManager(this);
  late final $TodoTable todo = $TodoTable(this);
  late final $ProjectTable project = $ProjectTable(this);
  late final $CommentTable comment = $CommentTable(this);
  late final $ReminderTable reminder = $ReminderTable(this);
  late final $EntityActionsQueueTable entityActionsQueue =
      $EntityActionsQueueTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [todo, project, comment, reminder, entityActionsQueue];
}

typedef $$TodoTableCreateCompanionBuilder = TodoCompanion Function({
  Value<String> id,
  required String title,
  Value<int> priority,
  Value<String> pipeline,
  Value<bool> completed,
  Value<DateTime?> dueDate,
  Value<DateTime> creationTime,
  Value<String?> project,
  Value<String?> parent,
  Value<List<String>> tags,
  Value<int> rowid,
});
typedef $$TodoTableUpdateCompanionBuilder = TodoCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<int> priority,
  Value<String> pipeline,
  Value<bool> completed,
  Value<DateTime?> dueDate,
  Value<DateTime> creationTime,
  Value<String?> project,
  Value<String?> parent,
  Value<List<String>> tags,
  Value<int> rowid,
});

class $$TodoTableFilterComposer extends Composer<_$SharedDatabase, $TodoTable> {
  $$TodoTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pipeline => $composableBuilder(
      column: $table.pipeline, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get completed => $composableBuilder(
      column: $table.completed, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
      column: $table.dueDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get creationTime => $composableBuilder(
      column: $table.creationTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get project => $composableBuilder(
      column: $table.project, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get parent => $composableBuilder(
      column: $table.parent, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<List<String>, List<String>, String> get tags =>
      $composableBuilder(
          column: $table.tags,
          builder: (column) => ColumnWithTypeConverterFilters(column));
}

class $$TodoTableOrderingComposer
    extends Composer<_$SharedDatabase, $TodoTable> {
  $$TodoTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pipeline => $composableBuilder(
      column: $table.pipeline, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get completed => $composableBuilder(
      column: $table.completed, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
      column: $table.dueDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get creationTime => $composableBuilder(
      column: $table.creationTime,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get project => $composableBuilder(
      column: $table.project, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get parent => $composableBuilder(
      column: $table.parent, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnOrderings(column));
}

class $$TodoTableAnnotationComposer
    extends Composer<_$SharedDatabase, $TodoTable> {
  $$TodoTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<String> get pipeline =>
      $composableBuilder(column: $table.pipeline, builder: (column) => column);

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<DateTime> get creationTime => $composableBuilder(
      column: $table.creationTime, builder: (column) => column);

  GeneratedColumn<String> get project =>
      $composableBuilder(column: $table.project, builder: (column) => column);

  GeneratedColumn<String> get parent =>
      $composableBuilder(column: $table.parent, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);
}

class $$TodoTableTableManager extends RootTableManager<
    _$SharedDatabase,
    $TodoTable,
    TodoData,
    $$TodoTableFilterComposer,
    $$TodoTableOrderingComposer,
    $$TodoTableAnnotationComposer,
    $$TodoTableCreateCompanionBuilder,
    $$TodoTableUpdateCompanionBuilder,
    (TodoData, BaseReferences<_$SharedDatabase, $TodoTable, TodoData>),
    TodoData,
    PrefetchHooks Function()> {
  $$TodoTableTableManager(_$SharedDatabase db, $TodoTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TodoTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TodoTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TodoTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<int> priority = const Value.absent(),
            Value<String> pipeline = const Value.absent(),
            Value<bool> completed = const Value.absent(),
            Value<DateTime?> dueDate = const Value.absent(),
            Value<DateTime> creationTime = const Value.absent(),
            Value<String?> project = const Value.absent(),
            Value<String?> parent = const Value.absent(),
            Value<List<String>> tags = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TodoCompanion(
            id: id,
            title: title,
            priority: priority,
            pipeline: pipeline,
            completed: completed,
            dueDate: dueDate,
            creationTime: creationTime,
            project: project,
            parent: parent,
            tags: tags,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String title,
            Value<int> priority = const Value.absent(),
            Value<String> pipeline = const Value.absent(),
            Value<bool> completed = const Value.absent(),
            Value<DateTime?> dueDate = const Value.absent(),
            Value<DateTime> creationTime = const Value.absent(),
            Value<String?> project = const Value.absent(),
            Value<String?> parent = const Value.absent(),
            Value<List<String>> tags = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TodoCompanion.insert(
            id: id,
            title: title,
            priority: priority,
            pipeline: pipeline,
            completed: completed,
            dueDate: dueDate,
            creationTime: creationTime,
            project: project,
            parent: parent,
            tags: tags,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TodoTableProcessedTableManager = ProcessedTableManager<
    _$SharedDatabase,
    $TodoTable,
    TodoData,
    $$TodoTableFilterComposer,
    $$TodoTableOrderingComposer,
    $$TodoTableAnnotationComposer,
    $$TodoTableCreateCompanionBuilder,
    $$TodoTableUpdateCompanionBuilder,
    (TodoData, BaseReferences<_$SharedDatabase, $TodoTable, TodoData>),
    TodoData,
    PrefetchHooks Function()>;
typedef $$ProjectTableCreateCompanionBuilder = ProjectCompanion Function({
  Value<String> id,
  required String title,
  required String color,
  Value<List<String>> pipelines,
  Value<int> rowid,
});
typedef $$ProjectTableUpdateCompanionBuilder = ProjectCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<String> color,
  Value<List<String>> pipelines,
  Value<int> rowid,
});

class $$ProjectTableFilterComposer
    extends Composer<_$SharedDatabase, $ProjectTable> {
  $$ProjectTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
      get pipelines => $composableBuilder(
          column: $table.pipelines,
          builder: (column) => ColumnWithTypeConverterFilters(column));
}

class $$ProjectTableOrderingComposer
    extends Composer<_$SharedDatabase, $ProjectTable> {
  $$ProjectTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pipelines => $composableBuilder(
      column: $table.pipelines, builder: (column) => ColumnOrderings(column));
}

class $$ProjectTableAnnotationComposer
    extends Composer<_$SharedDatabase, $ProjectTable> {
  $$ProjectTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get pipelines =>
      $composableBuilder(column: $table.pipelines, builder: (column) => column);
}

class $$ProjectTableTableManager extends RootTableManager<
    _$SharedDatabase,
    $ProjectTable,
    ProjectData,
    $$ProjectTableFilterComposer,
    $$ProjectTableOrderingComposer,
    $$ProjectTableAnnotationComposer,
    $$ProjectTableCreateCompanionBuilder,
    $$ProjectTableUpdateCompanionBuilder,
    (ProjectData, BaseReferences<_$SharedDatabase, $ProjectTable, ProjectData>),
    ProjectData,
    PrefetchHooks Function()> {
  $$ProjectTableTableManager(_$SharedDatabase db, $ProjectTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProjectTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProjectTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProjectTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> color = const Value.absent(),
            Value<List<String>> pipelines = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProjectCompanion(
            id: id,
            title: title,
            color: color,
            pipelines: pipelines,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String title,
            required String color,
            Value<List<String>> pipelines = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProjectCompanion.insert(
            id: id,
            title: title,
            color: color,
            pipelines: pipelines,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ProjectTableProcessedTableManager = ProcessedTableManager<
    _$SharedDatabase,
    $ProjectTable,
    ProjectData,
    $$ProjectTableFilterComposer,
    $$ProjectTableOrderingComposer,
    $$ProjectTableAnnotationComposer,
    $$ProjectTableCreateCompanionBuilder,
    $$ProjectTableUpdateCompanionBuilder,
    (ProjectData, BaseReferences<_$SharedDatabase, $ProjectTable, ProjectData>),
    ProjectData,
    PrefetchHooks Function()>;
typedef $$CommentTableCreateCompanionBuilder = CommentCompanion Function({
  Value<String> id,
  required Uint8List content,
  required TodoCommentType type,
  required String todo,
  Value<DateTime> creationTime,
  Value<int> rowid,
});
typedef $$CommentTableUpdateCompanionBuilder = CommentCompanion Function({
  Value<String> id,
  Value<Uint8List> content,
  Value<TodoCommentType> type,
  Value<String> todo,
  Value<DateTime> creationTime,
  Value<int> rowid,
});

class $$CommentTableFilterComposer
    extends Composer<_$SharedDatabase, $CommentTable> {
  $$CommentTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<Uint8List> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<TodoCommentType, TodoCommentType, String>
      get type => $composableBuilder(
          column: $table.type,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get todo => $composableBuilder(
      column: $table.todo, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get creationTime => $composableBuilder(
      column: $table.creationTime, builder: (column) => ColumnFilters(column));
}

class $$CommentTableOrderingComposer
    extends Composer<_$SharedDatabase, $CommentTable> {
  $$CommentTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<Uint8List> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get todo => $composableBuilder(
      column: $table.todo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get creationTime => $composableBuilder(
      column: $table.creationTime,
      builder: (column) => ColumnOrderings(column));
}

class $$CommentTableAnnotationComposer
    extends Composer<_$SharedDatabase, $CommentTable> {
  $$CommentTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<Uint8List> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TodoCommentType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get todo =>
      $composableBuilder(column: $table.todo, builder: (column) => column);

  GeneratedColumn<DateTime> get creationTime => $composableBuilder(
      column: $table.creationTime, builder: (column) => column);
}

class $$CommentTableTableManager extends RootTableManager<
    _$SharedDatabase,
    $CommentTable,
    CommentData,
    $$CommentTableFilterComposer,
    $$CommentTableOrderingComposer,
    $$CommentTableAnnotationComposer,
    $$CommentTableCreateCompanionBuilder,
    $$CommentTableUpdateCompanionBuilder,
    (CommentData, BaseReferences<_$SharedDatabase, $CommentTable, CommentData>),
    CommentData,
    PrefetchHooks Function()> {
  $$CommentTableTableManager(_$SharedDatabase db, $CommentTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CommentTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CommentTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CommentTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<Uint8List> content = const Value.absent(),
            Value<TodoCommentType> type = const Value.absent(),
            Value<String> todo = const Value.absent(),
            Value<DateTime> creationTime = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CommentCompanion(
            id: id,
            content: content,
            type: type,
            todo: todo,
            creationTime: creationTime,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required Uint8List content,
            required TodoCommentType type,
            required String todo,
            Value<DateTime> creationTime = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CommentCompanion.insert(
            id: id,
            content: content,
            type: type,
            todo: todo,
            creationTime: creationTime,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CommentTableProcessedTableManager = ProcessedTableManager<
    _$SharedDatabase,
    $CommentTable,
    CommentData,
    $$CommentTableFilterComposer,
    $$CommentTableOrderingComposer,
    $$CommentTableAnnotationComposer,
    $$CommentTableCreateCompanionBuilder,
    $$CommentTableUpdateCompanionBuilder,
    (CommentData, BaseReferences<_$SharedDatabase, $CommentTable, CommentData>),
    CommentData,
    PrefetchHooks Function()>;
typedef $$ReminderTableCreateCompanionBuilder = ReminderCompanion Function({
  Value<String> id,
  required DateTime time,
  Value<bool> completed,
  required String todo,
  Value<int> rowid,
});
typedef $$ReminderTableUpdateCompanionBuilder = ReminderCompanion Function({
  Value<String> id,
  Value<DateTime> time,
  Value<bool> completed,
  Value<String> todo,
  Value<int> rowid,
});

class $$ReminderTableFilterComposer
    extends Composer<_$SharedDatabase, $ReminderTable> {
  $$ReminderTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get time => $composableBuilder(
      column: $table.time, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get completed => $composableBuilder(
      column: $table.completed, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get todo => $composableBuilder(
      column: $table.todo, builder: (column) => ColumnFilters(column));
}

class $$ReminderTableOrderingComposer
    extends Composer<_$SharedDatabase, $ReminderTable> {
  $$ReminderTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get time => $composableBuilder(
      column: $table.time, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get completed => $composableBuilder(
      column: $table.completed, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get todo => $composableBuilder(
      column: $table.todo, builder: (column) => ColumnOrderings(column));
}

class $$ReminderTableAnnotationComposer
    extends Composer<_$SharedDatabase, $ReminderTable> {
  $$ReminderTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get time =>
      $composableBuilder(column: $table.time, builder: (column) => column);

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);

  GeneratedColumn<String> get todo =>
      $composableBuilder(column: $table.todo, builder: (column) => column);
}

class $$ReminderTableTableManager extends RootTableManager<
    _$SharedDatabase,
    $ReminderTable,
    ReminderData,
    $$ReminderTableFilterComposer,
    $$ReminderTableOrderingComposer,
    $$ReminderTableAnnotationComposer,
    $$ReminderTableCreateCompanionBuilder,
    $$ReminderTableUpdateCompanionBuilder,
    (
      ReminderData,
      BaseReferences<_$SharedDatabase, $ReminderTable, ReminderData>
    ),
    ReminderData,
    PrefetchHooks Function()> {
  $$ReminderTableTableManager(_$SharedDatabase db, $ReminderTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReminderTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReminderTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReminderTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<DateTime> time = const Value.absent(),
            Value<bool> completed = const Value.absent(),
            Value<String> todo = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ReminderCompanion(
            id: id,
            time: time,
            completed: completed,
            todo: todo,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required DateTime time,
            Value<bool> completed = const Value.absent(),
            required String todo,
            Value<int> rowid = const Value.absent(),
          }) =>
              ReminderCompanion.insert(
            id: id,
            time: time,
            completed: completed,
            todo: todo,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ReminderTableProcessedTableManager = ProcessedTableManager<
    _$SharedDatabase,
    $ReminderTable,
    ReminderData,
    $$ReminderTableFilterComposer,
    $$ReminderTableOrderingComposer,
    $$ReminderTableAnnotationComposer,
    $$ReminderTableCreateCompanionBuilder,
    $$ReminderTableUpdateCompanionBuilder,
    (
      ReminderData,
      BaseReferences<_$SharedDatabase, $ReminderTable, ReminderData>
    ),
    ReminderData,
    PrefetchHooks Function()>;
typedef $$EntityActionsQueueTableCreateCompanionBuilder
    = EntityActionsQueueCompanion Function({
  Value<String> requestId,
  required String id,
  required String name,
  required String action,
  required Map<String, dynamic> payload,
  required DateTime timestamp,
  Value<int> rowid,
});
typedef $$EntityActionsQueueTableUpdateCompanionBuilder
    = EntityActionsQueueCompanion Function({
  Value<String> requestId,
  Value<String> id,
  Value<String> name,
  Value<String> action,
  Value<Map<String, dynamic>> payload,
  Value<DateTime> timestamp,
  Value<int> rowid,
});

class $$EntityActionsQueueTableFilterComposer
    extends Composer<_$SharedDatabase, $EntityActionsQueueTable> {
  $$EntityActionsQueueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get requestId => $composableBuilder(
      column: $table.requestId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get action => $composableBuilder(
      column: $table.action, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<Map<String, dynamic>, Map<String, dynamic>,
          String>
      get payload => $composableBuilder(
          column: $table.payload,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnFilters(column));
}

class $$EntityActionsQueueTableOrderingComposer
    extends Composer<_$SharedDatabase, $EntityActionsQueueTable> {
  $$EntityActionsQueueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get requestId => $composableBuilder(
      column: $table.requestId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get action => $composableBuilder(
      column: $table.action, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get payload => $composableBuilder(
      column: $table.payload, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnOrderings(column));
}

class $$EntityActionsQueueTableAnnotationComposer
    extends Composer<_$SharedDatabase, $EntityActionsQueueTable> {
  $$EntityActionsQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get requestId =>
      $composableBuilder(column: $table.requestId, builder: (column) => column);

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, dynamic>, String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);
}

class $$EntityActionsQueueTableTableManager extends RootTableManager<
    _$SharedDatabase,
    $EntityActionsQueueTable,
    EntityActionsQueueData,
    $$EntityActionsQueueTableFilterComposer,
    $$EntityActionsQueueTableOrderingComposer,
    $$EntityActionsQueueTableAnnotationComposer,
    $$EntityActionsQueueTableCreateCompanionBuilder,
    $$EntityActionsQueueTableUpdateCompanionBuilder,
    (
      EntityActionsQueueData,
      BaseReferences<_$SharedDatabase, $EntityActionsQueueTable,
          EntityActionsQueueData>
    ),
    EntityActionsQueueData,
    PrefetchHooks Function()> {
  $$EntityActionsQueueTableTableManager(
      _$SharedDatabase db, $EntityActionsQueueTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EntityActionsQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EntityActionsQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EntityActionsQueueTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> requestId = const Value.absent(),
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> action = const Value.absent(),
            Value<Map<String, dynamic>> payload = const Value.absent(),
            Value<DateTime> timestamp = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EntityActionsQueueCompanion(
            requestId: requestId,
            id: id,
            name: name,
            action: action,
            payload: payload,
            timestamp: timestamp,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> requestId = const Value.absent(),
            required String id,
            required String name,
            required String action,
            required Map<String, dynamic> payload,
            required DateTime timestamp,
            Value<int> rowid = const Value.absent(),
          }) =>
              EntityActionsQueueCompanion.insert(
            requestId: requestId,
            id: id,
            name: name,
            action: action,
            payload: payload,
            timestamp: timestamp,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$EntityActionsQueueTableProcessedTableManager = ProcessedTableManager<
    _$SharedDatabase,
    $EntityActionsQueueTable,
    EntityActionsQueueData,
    $$EntityActionsQueueTableFilterComposer,
    $$EntityActionsQueueTableOrderingComposer,
    $$EntityActionsQueueTableAnnotationComposer,
    $$EntityActionsQueueTableCreateCompanionBuilder,
    $$EntityActionsQueueTableUpdateCompanionBuilder,
    (
      EntityActionsQueueData,
      BaseReferences<_$SharedDatabase, $EntityActionsQueueTable,
          EntityActionsQueueData>
    ),
    EntityActionsQueueData,
    PrefetchHooks Function()>;

class $SharedDatabaseManager {
  final _$SharedDatabase _db;
  $SharedDatabaseManager(this._db);
  $$TodoTableTableManager get todo => $$TodoTableTableManager(_db, _db.todo);
  $$ProjectTableTableManager get project =>
      $$ProjectTableTableManager(_db, _db.project);
  $$CommentTableTableManager get comment =>
      $$CommentTableTableManager(_db, _db.comment);
  $$ReminderTableTableManager get reminder =>
      $$ReminderTableTableManager(_db, _db.reminder);
  $$EntityActionsQueueTableTableManager get entityActionsQueue =>
      $$EntityActionsQueueTableTableManager(_db, _db.entityActionsQueue);
}
