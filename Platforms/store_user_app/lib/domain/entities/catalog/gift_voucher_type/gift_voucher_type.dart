import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'value')
enum GiftVoucherType {
  
  @JsonValue(0)
  virtual(0),
  @JsonValue(1)
  physical(1);

  final int value;
  const GiftVoucherType(this.value);
}