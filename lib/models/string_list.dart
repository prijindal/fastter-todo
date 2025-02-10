import 'dart:convert';

import 'package:drift/drift.dart';

class StringListConverter extends TypeConverter<List<String>, String>
    implements JsonTypeConverter<List<String>, String> {
  const StringListConverter();

  @override
  List<String> fromSql(String fromDb) {
    return (jsonDecode(fromDb) as List<dynamic>)
        .map<String>((a) => a as String)
        .toList();
  }

  @override
  String toSql(List<String> value) {
    return jsonEncode(value);
  }

  @override
  List<String> fromJson(String json) => fromSql(json);

  @override
  String toJson(List<String> value) {
    return toSql(value);
  }
}

class JsonConverter extends TypeConverter<Map<String, dynamic>, String>
    implements JsonTypeConverter<Map<String, dynamic>, String> {
  const JsonConverter();

  @override
  Map<String, dynamic> fromSql(String fromDb) {
    return (jsonDecode(fromDb) as Map<String, dynamic>);
  }

  @override
  String toSql(Map<String, dynamic> value) {
    return jsonEncode(value);
  }

  @override
  Map<String, dynamic> fromJson(String json) => fromSql(json);

  @override
  String toJson(Map<String, dynamic> value) {
    return toSql(value);
  }
}
