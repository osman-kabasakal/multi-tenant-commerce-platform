
import 'json_converter.dart';

class ListConverter<T> implements JsonConverter<List<T>, List<dynamic>> {
  final JsonConverter<T, dynamic> itemConverter;

  ListConverter(this.itemConverter);

  @override
  List<dynamic> toJson(List<T> value) {
    return value.map((item) => itemConverter.toJson(item)).toList();
  }

  @override
  List<T> fromJson(List<dynamic> json) {
    return json.map((item) => itemConverter.fromJson((item as Map))).toList();
  }
}
