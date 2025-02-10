class DateParams {
  DateTime? gte;
  DateTime? lte;

  DateParams({this.gte, this.lte});

  factory DateParams.fromJson(Map<String, dynamic> json) => DateParams(
        gte: json['gte'] != null ? DateTime.parse(json['gte'] as String) : null,
        lte: json['lte'] != null ? DateTime.parse(json['lte'] as String) : null,
      );

  Map<String, dynamic> toJson() => {
        'gte': gte?.toUtc().toIso8601String(),
        'lte': lte?.toUtc().toIso8601String(),
      };
}

class EntitySearchParams {
  DateParams? updatedAt;
  DateParams? createdAt;
  List<String>? ids;

  EntitySearchParams({this.updatedAt, this.createdAt, this.ids});

  factory EntitySearchParams.fromJson(Map<String, dynamic> json) =>
      EntitySearchParams(
        updatedAt: json['updated_at'] != null
            ? DateParams.fromJson(json['updated_at'] as Map<String, dynamic>)
            : null,
        createdAt: json['created_at'] != null
            ? DateParams.fromJson(json['created_at'] as Map<String, dynamic>)
            : null,
        ids: json['ids'] != null
            ? List<String>.from(json['ids'] as List<dynamic>)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'updated_at': updatedAt?.toJson(),
        'created_at': createdAt?.toJson(),
        'ids': ids,
      };
}

class EntitySearchRequest {
  String entityName;
  EntitySearchParams params;

  EntitySearchRequest({required this.entityName, required this.params});

  factory EntitySearchRequest.fromJson(Map<String, dynamic> json) =>
      EntitySearchRequest(
        entityName: json['entity_name'] as String,
        params:
            EntitySearchParams.fromJson(json['params'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'entity_name': entityName,
        'params': params.toJson(),
      };
}

class EntityData {
  final String? id;

  EntityData({this.id});

  factory EntityData.fromJson(Map<String, dynamic> json) => EntityData(
        id: json['id'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
      };
}

class EntitySearchResponse {
  String entityName;
  List<EntityData> data;

  EntitySearchResponse({required this.entityName, required this.data});

  factory EntitySearchResponse.fromJson(Map<String, dynamic> json) =>
      EntitySearchResponse(
        entityName: json['entity_name'] as String,
        data: (json['data'] as List)
            .map((e) => EntityData.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'entity_name': entityName,
        'data': data.map((e) => e.toJson()).toList(),
      };
}

class EntityHistoryParams {
  DateParams? createdAt;

  EntityHistoryParams({this.createdAt});

  factory EntityHistoryParams.fromJson(Map<String, dynamic> json) =>
      EntityHistoryParams(
        createdAt: json['created_at'] != null
            ? DateParams.fromJson(json['created_at'] as Map<String, dynamic>)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'created_at': createdAt?.toJson(),
      };
}

class EntityHistoryRequest {
  String entityName;
  EntityHistoryParams params;

  EntityHistoryRequest({required this.entityName, required this.params});

  factory EntityHistoryRequest.fromJson(Map<String, dynamic> json) =>
      EntityHistoryRequest(
        entityName: json['entity_name'] as String,
        params: EntityHistoryParams.fromJson(
            json['params'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'entity_name': entityName,
        'params': params.toJson(),
      };
}

class EntityHistory {
  final String? id;

  EntityHistory({this.id});

  factory EntityHistory.fromJson(Map<String, dynamic> json) => EntityHistory(
        id: json['id'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
      };
}

class EntityHistoryResponse {
  String entityName;
  List<EntityHistory> data;

  EntityHistoryResponse({required this.entityName, required this.data});

  factory EntityHistoryResponse.fromJson(Map<String, dynamic> json) =>
      EntityHistoryResponse(
        entityName: json['entity_name'] as String,
        data: (json['data'] as List)
            .map((e) => EntityHistory.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'entity_name': entityName,
        'data': data.map((e) => e.toJson()).toList(),
      };
}

abstract class EntityActionBase {
  String entityName;
  Map<String, dynamic> payload;
  DateTime timestamp;

  EntityActionBase({
    required this.entityName,
    required this.payload,
    required this.timestamp,
  });

  factory EntityActionBase.fromJson(Map<String, dynamic> json) {
    switch (json['action']) {
      case 'CREATE':
        return EntityActionCreate.fromJson(json);
      case 'UPDATE':
        return EntityActionUpdate.fromJson(json);
      case 'DELETE':
        return EntityActionDelete.fromJson(json);
      default:
        throw Exception('Unknown action type: ${json['action']}');
    }
  }

  Map<String, dynamic> toJson();
}

class EntityActionCreate extends EntityActionBase {
  final String action = 'CREATE';
  String id;

  EntityActionCreate({
    required super.entityName,
    required super.payload,
    required this.id,
    required super.timestamp,
  });

  factory EntityActionCreate.fromJson(Map<String, dynamic> json) =>
      EntityActionCreate(
        entityName: json['entity_name'] as String,
        payload: (json['payload'] as Map<String, dynamic>?) ?? {},
        id: json['id'] as String,
        timestamp: json['timestamp'] != null
            ? DateTime.parse(json['timestamp'] as String)
            : DateTime.now(),
      );

  @override
  Map<String, dynamic> toJson() => {
        'entity_name': entityName,
        'payload': payload,
        'id': id,
        'action': action,
        'timestamp': timestamp.toUtc().toIso8601String(),
      };
}

class EntityActionUpdate extends EntityActionBase {
  final String action = 'UPDATE';
  List<String> ids;

  EntityActionUpdate({
    required super.entityName,
    required super.payload,
    required this.ids,
    required super.timestamp,
  });

  factory EntityActionUpdate.fromJson(Map<String, dynamic> json) =>
      EntityActionUpdate(
        entityName: json['entity_name'] as String,
        payload: (json['payload'] as Map<String, dynamic>?) ?? {},
        ids: (json['ids'] as List<dynamic>).map((e) => e.toString()).toList(),
        timestamp: json['timestamp'] != null
            ? DateTime.parse(json['timestamp'] as String)
            : DateTime.now(),
      );

  @override
  Map<String, dynamic> toJson() => {
        'entity_name': entityName,
        'payload': payload,
        'ids': ids,
        'action': action,
        'timestamp': timestamp.toUtc().toIso8601String(),
      };
}

class EntityActionDelete extends EntityActionBase {
  final String action = 'DELETE';
  List<String> ids;

  EntityActionDelete({
    required super.entityName,
    required super.payload,
    required this.ids,
    required super.timestamp,
  });

  factory EntityActionDelete.fromJson(Map<String, dynamic> json) =>
      EntityActionDelete(
        entityName: json['entity_name'] as String,
        payload: (json['payload'] as Map<String, dynamic>?) ?? {},
        ids: (json['ids'] as List<dynamic>).map((e) => e.toString()).toList(),
        timestamp: json['timestamp'] != null
            ? DateTime.parse(json['timestamp'] as String)
            : DateTime.now(),
      );

  @override
  Map<String, dynamic> toJson() => {
        'entity_name': entityName,
        'payload': payload,
        'ids': ids,
        'action': action,
        'timestamp': timestamp.toUtc().toIso8601String(),
      };
}

class EntityActionResponse {
  String entityName;
  int affectedRows;

  EntityActionResponse({required this.entityName, required this.affectedRows});

  factory EntityActionResponse.fromJson(Map<String, dynamic> json) =>
      EntityActionResponse(
        entityName: json['entity_name'] as String,
        affectedRows: json['affectedrows'] as int? ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'entity_name': entityName,
        'affectedrows': affectedRows,
      };
}
