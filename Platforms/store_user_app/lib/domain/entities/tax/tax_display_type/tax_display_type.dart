import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'value')
enum TaxDisplayType {
  
  @JsonValue(0)
  includingTax(0),
  @JsonValue(10)
  excludingTax(10);

  final int value;
  const TaxDisplayType(this.value);
}