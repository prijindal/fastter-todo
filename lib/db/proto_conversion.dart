import 'package:protobuf/well_known_types/google/protobuf/struct.pb.dart';

class ProtoConversion {
  /// Converts a Dart Map to a Protobuf Struct
  static Struct mapToStruct(Map<String, dynamic> map) {
    final struct = Struct()..mergeFromProto3Json(map);
    return struct;
  }

  static dynamic _restoreIntegers(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value.map((k, v) => MapEntry(k, _restoreIntegers(v)));
    } else if (value is List) {
      return value.map(_restoreIntegers).toList();
    } else if (value is double) {
      // Check if the double is actually a whole number integer
      if (value == value.toInt()) {
        return value.toInt();
      }
    }
    return value;
  }

  /// Converts a Protobuf Struct back to a Dart Map
  static Map<String, dynamic> structToMap(Struct struct) {
    final map = struct.toProto3Json();
    return _restoreIntegers(map) as Map<String, dynamic>;
  }
}
