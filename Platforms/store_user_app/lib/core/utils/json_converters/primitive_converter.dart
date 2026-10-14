import 'json_converter.dart';

class PrimitiveConverter<T> implements JsonConverter<T, Map<String, dynamic>> {
  @override
  Map<String, dynamic> toJson(T value) {
    return {'value': value};
  }

  @override
  T fromJson(Map<String, dynamic> json) {
    return json['value'] as T;
  }
}
