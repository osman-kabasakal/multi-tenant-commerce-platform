import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'value')
enum AttributeControlType {
  
  @JsonValue(1)
  dropdownList(1),
  @JsonValue(2)
  radioList(2),
  @JsonValue(3)
  checkboxes(3),
  @JsonValue(4)
  textBox(4),
  @JsonValue(5)
  hidden(5),
  @JsonValue(10)
  multilineTextbox(10),
  @JsonValue(20)
  datepicker(20),
  @JsonValue(30)
  fileUpload(30),
  @JsonValue(40)
  colorSquares(40),
  @JsonValue(45)
  imageSquares(45),
  @JsonValue(50)
  readonlyCheckboxes(50);

  final int value;
  const AttributeControlType(this.value);
}