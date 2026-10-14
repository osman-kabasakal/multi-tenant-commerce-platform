import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'value')
enum ProductType {
  
  @JsonValue(0)
  simpleProduct(0),
  @JsonValue(10)
  groupedProduct(10),
  @JsonValue(20)
  reservation(20),
  @JsonValue(30)
  bundledProduct(30),
  @JsonValue(40)
  auction(40);

  final int value;
  const ProductType(this.value);
}