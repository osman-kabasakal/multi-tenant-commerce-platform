import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'value')
enum MerchandiseReturnStatus {
  
  @JsonValue(0)
  pending(0),
  @JsonValue(10)
  accepted(10),
  @JsonValue(20)
  rejected(20),
  @JsonValue(30)
  cancelled(30),
  @JsonValue(40)
  completed(40);

  final int value;
  const MerchandiseReturnStatus(this.value);
}