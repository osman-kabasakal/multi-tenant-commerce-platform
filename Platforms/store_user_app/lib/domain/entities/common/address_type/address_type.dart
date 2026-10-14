import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'value')
enum AddressType {
  
  @JsonValue(0)
  any(0),
  @JsonValue(1)
  billing(1),
  @JsonValue(2)
  shipping(2);

  final int value;
  const AddressType(this.value);
}