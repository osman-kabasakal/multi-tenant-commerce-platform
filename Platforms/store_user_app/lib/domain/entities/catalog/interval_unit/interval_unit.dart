import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'value')
enum IntervalUnit {
  
  @JsonValue(0)
  minute(0),
  @JsonValue(5)
  hour(5),
  @JsonValue(10)
  day(10);

  final int value;
  const IntervalUnit(this.value);
}