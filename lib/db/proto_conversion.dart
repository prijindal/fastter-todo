import 'package:protobuf/well_known_types/google/protobuf/struct.pb.dart';

class ProtoConversion {
  /// Converts a Dart Map to a Protobuf Struct
  static Struct mapToStruct(Map<String, dynamic> map) {
    final struct = Struct();

    map.forEach((key, value) {
      struct.fields[key] = _valueFromDart(value);
    });

    return struct;
  }

  static Value _valueFromDart(dynamic value) {
    final pbValue = Value();

    if (value == null) {
      pbValue.nullValue = NullValue.NULL_VALUE;
    } else if (value is bool) {
      pbValue.boolValue = value;
    } else if (value is num) {
      // Protobuf numbers are represented as doubles
      pbValue.numberValue = value.toDouble();
    } else if (value is String) {
      pbValue.stringValue = value;
    } else if (value is Map<String, dynamic>) {
      pbValue.structValue = mapToStruct(value);
    } else if (value is List) {
      final listValue = ListValue();
      for (var item in value) {
        listValue.values.add(_valueFromDart(item));
      }
      pbValue.listValue = listValue;
    } else {
      throw ArgumentError(
          'Unsupported type for Protobuf Struct: ${value.runtimeType}');
    }

    return pbValue;
  }

  /// Converts a Protobuf Struct back to a Dart Map
  static Map<String, dynamic> structToMap(Struct struct) {
    return struct.fields
        .map((key, value) => MapEntry(key, _valueToDart(value)));
  }

  static dynamic _valueToDart(Value value) {
    switch (value.whichKind()) {
      case Value_Kind.nullValue:
        return null;
      case Value_Kind.numberValue:
        return value.numberValue;
      case Value_Kind.stringValue:
        return value.stringValue;
      case Value_Kind.boolValue:
        return value.boolValue;
      case Value_Kind.structValue:
        return structToMap(value.structValue);
      case Value_Kind.listValue:
        return value.listValue.values.map(_valueToDart).toList();
      case Value_Kind.notSet:
        return null;
    }
  }
}
