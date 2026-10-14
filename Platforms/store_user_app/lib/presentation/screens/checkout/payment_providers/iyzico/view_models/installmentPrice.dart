import 'package:json_annotation/json_annotation.dart';
part 'installmentPrice.g.dart';

@JsonSerializable()
class InstallmentPrice {
  InstallmentPrice({
this.price,
this.totalPrice,
this.installmentNumber
});

  @JsonKey(name: 'Price')
  String? price;

  @JsonKey(name: 'TotalPrice')
  String? totalPrice;

  @JsonKey(name: 'InstallmentNumber')
  int? installmentNumber;

  factory InstallmentPrice.fromJson(Map<String, dynamic> json) =>
      _$InstallmentPriceFromJson(json);

  Map<String, dynamic> toJson() =>
      _$InstallmentPriceToJson(this);
}
