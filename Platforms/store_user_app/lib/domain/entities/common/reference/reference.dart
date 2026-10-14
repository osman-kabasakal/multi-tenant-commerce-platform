import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'value')
enum Reference {
  @JsonValue(0)
  none(0),
  @JsonValue(10)
  order(10),
  @JsonValue(20)
  shipment(20),
  @JsonValue(30)
  merchandiseReturn(30),
  @JsonValue(40)
  product(40),
  @JsonValue(50)
  category(50),
  @JsonValue(60)
  brand(60),
  @JsonValue(70)
  collection(70),
  @JsonValue(80)
  vendor(80),
  @JsonValue(90)
  settings(90),
  @JsonValue(100)
  blog(100),
  @JsonValue(110)
  course(110),
  @JsonValue(120)
  document(120),
  @JsonValue(130)
  campaign(130),
  @JsonValue(150)
  customer(150),
  @JsonValue(901)
  other1(901),
  @JsonValue(902)
  other2(902),
  @JsonValue(903)
  other3(903);

  final int value;
  const Reference(this.value);
}
