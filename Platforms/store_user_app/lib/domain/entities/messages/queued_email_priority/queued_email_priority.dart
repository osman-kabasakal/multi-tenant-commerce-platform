import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'value')
enum QueuedEmailPriority {
  
  @JsonValue(0)
  low(0),
  @JsonValue(5)
  high(5);

  final int value;
  const QueuedEmailPriority(this.value);
}