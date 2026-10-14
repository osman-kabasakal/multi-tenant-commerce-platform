import 'dart:convert';

import '../../models/store_json_serializable.dart';
import 'json_converter.dart';

class StoreJsonSerializableConverter<T extends StoreJsonSerializable>
    implements JsonConverter<T, Map<String, dynamic>> {
  final T Function(Map<String, dynamic>) fromJsonFactory;

  StoreJsonSerializableConverter(this.fromJsonFactory);

  @override
  Map<String, dynamic> toJson(T value) =>
      (jsonDecode(jsonEncode(value.toJson())) as Map<String, dynamic>);

  @override
  T fromJson(Map<String, dynamic> json) => fromJsonFactory(json);
}
