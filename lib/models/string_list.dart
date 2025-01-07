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
