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

class HostParams {
  String? ne;

  HostParams({this.ne});

  factory HostParams.fromJson(Map<String, dynamic> json) =>
      HostParams(ne: json["ne"] as String?);

  Map<String, dynamic> toJson() => {
        "ne": ne,
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
  final Map<String, String> order;

  EntitySearchRequest({
    required this.entityName,
    required this.params,
    required this.order,
  });

  factory EntitySearchRequest.fromJson(Map<String, dynamic> json) {
    final orderMap = (json['order'] as Map<String, dynamic>)
        .map((k, v) => MapEntry(k, v as String));
    return EntitySearchRequest(
      entityName: json['entity_name'] as String,
      params:
          EntitySearchParams.fromJson(json['params'] as Map<String, dynamic>),
      order: orderMap,
    );
  }

  Map<String, dynamic> toJson() => {
        'entity_name': entityName,
        'params': params.toJson(),
        'order': order,
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
  HostParams? hostId;

  EntityHistoryParams({
    this.createdAt,
    this.hostId,
  });

  factory EntityHistoryParams.fromJson(Map<String, dynamic> json) =>
      EntityHistoryParams(
        createdAt: json['created_at'] != null
            ? DateParams.fromJson(json['created_at'] as Map<String, dynamic>)
            : null,
        hostId: json['host_id'] != null
            ? HostParams.fromJson(json['host_id'] as Map<String, dynamic>)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'created_at': createdAt?.toJson(),
        'host_id': hostId?.toJson(),
      };
}

class EntityHistoryRequest {
  String entityName;
  EntityHistoryParams params;
  final Map<String, String> order;

  EntityHistoryRequest({
    required this.entityName,
    required this.params,
    required this.order,
  });

  factory EntityHistoryRequest.fromJson(Map<String, dynamic> json) {
    final orderMap = (json['order'] as Map<String, dynamic>)
        .map((k, v) => MapEntry(k, v as String));
    return EntityHistoryRequest(
      entityName: json['entity_name'] as String,
      params:
          EntityHistoryParams.fromJson(json['params'] as Map<String, dynamic>),
      order: orderMap,
    );
  }

  Map<String, dynamic> toJson() => {
        'entity_name': entityName,
        'params': params.toJson(),
        'order': order,
      };
}

class EntityHistory {
  final String userId;
  final String projectId;
  final String entityName;
  final String id;
  final String entityId;
  final String action;
  final Map<String, dynamic> payload;
  final DateTime timestamp;
  final DateTime createdAt;

  EntityHistory({
    required this.userId,
    required this.projectId,
    required this.entityName,
    required this.id,
    required this.entityId,
    required this.action,
    required this.payload,
    required this.timestamp,
    required this.createdAt,
  });

  factory EntityHistory.fromJson(Map<String, dynamic> json) {
    return EntityHistory(
      userId: json['user_id'] as String,
      projectId: json['project_id'] as String,
      entityName: json['entity_name'] as String,
      id: json['id'] as String,
      entityId: json['entity_id'] as String,
      action: json['action'] as String,
      payload: json['payload'] == null
          ? {}
          : json['payload'] as Map<String, dynamic>,
      timestamp: DateTime.parse(json['timestamp'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'project_id': projectId,
        'entity_name': entityName,
        'id': id,
        'entity_id': entityId,
        'action': action,
        'payload': payload,
        'timestamp': timestamp.toUtc().toIso8601String(),
        'created_at': createdAt.toUtc().toIso8601String(),
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
  DateTime timestamp;
  String requestId;
  String entityId;
  String hostId;

  EntityActionBase({
    required this.entityName,
    required this.requestId,
    required this.timestamp,
    required this.entityId,
    required this.hostId,
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
  Map<String, dynamic> payload;

  EntityActionCreate({
    required super.entityName,
    required this.payload,
    required super.entityId,
    required super.timestamp,
    required super.requestId,
    required super.hostId,
  });

  factory EntityActionCreate.fromJson(Map<String, dynamic> json) =>
      EntityActionCreate(
        entityName: json['entity_name'] as String,
        payload: (json['payload'] as Map<String, dynamic>?) ?? {},
        entityId: json['entity_id'] as String,
        requestId: json['request_id'] as String,
        hostId: json['host_id'] as String,
        timestamp: json['timestamp'] != null
            ? DateTime.parse(json['timestamp'] as String)
            : DateTime.now(),
      );

  @override
  Map<String, dynamic> toJson() => {
        'entity_name': entityName,
        'payload': payload,
        'entity_id': entityId,
        'request_id': requestId,
        'host_id': hostId,
        'action': action,
        'timestamp': timestamp.toUtc().toIso8601String(),
      };
}

class EntityActionUpdate extends EntityActionBase {
  final String action = 'UPDATE';
  Map<String, dynamic> payload;

  EntityActionUpdate({
    required super.entityName,
    required this.payload,
    required super.entityId,
    required super.timestamp,
    required super.requestId,
    required super.hostId,
  });

  factory EntityActionUpdate.fromJson(Map<String, dynamic> json) =>
      EntityActionUpdate(
        entityName: json['entity_name'] as String,
        payload: (json['payload'] as Map<String, dynamic>?) ?? {},
        entityId: json['entity_id'] as String,
        requestId: json['request_id'] as String,
        hostId: json['host_id'] as String,
        timestamp: json['timestamp'] != null
            ? DateTime.parse(json['timestamp'] as String)
            : DateTime.now(),
      );

  @override
  Map<String, dynamic> toJson() => {
        'entity_name': entityName,
        'payload': payload,
        'entity_id': entityId,
        'request_id': requestId,
        'host_id': hostId,
        'action': action,
        'timestamp': timestamp.toUtc().toIso8601String(),
      };
}

class EntityActionDelete extends EntityActionBase {
  final String action = 'DELETE';

  EntityActionDelete({
    required super.entityName,
    required super.entityId,
    required super.timestamp,
    required super.requestId,
    required super.hostId,
  });

  factory EntityActionDelete.fromJson(Map<String, dynamic> json) =>
      EntityActionDelete(
        entityName: json['entity_name'] as String,
        entityId: json['entity_id'] as String,
        requestId: json['request_id'] as String,
        hostId: json['host_id'] as String,
        timestamp: json['timestamp'] != null
            ? DateTime.parse(json['timestamp'] as String)
            : DateTime.now(),
      );

  @override
  Map<String, dynamic> toJson() => {
        'entity_name': entityName,
        'entity_id': entityId,
        'request_id': requestId,
        'host_id': hostId,
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
