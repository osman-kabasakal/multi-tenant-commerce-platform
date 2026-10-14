import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'value')
enum DbProvider {
  
  @JsonValue(0)
  mongoDB(0),
  @JsonValue(1)
  cosmosDB(1),
  @JsonValue(2)
  documentDB(2),
  @JsonValue(3)
  liteDB(3);

  final int value;
  const DbProvider(this.value);
}