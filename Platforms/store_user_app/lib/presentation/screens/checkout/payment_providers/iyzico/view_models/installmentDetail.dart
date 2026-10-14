import 'package:json_annotation/json_annotation.dart';
import './installmentPrice.dart';
part 'installmentDetail.g.dart';

@JsonSerializable()
class InstallmentDetail {
  InstallmentDetail(
      {this.binNumber,
      this.commercial,
      this.price,
      this.cardType,
      this.cardAssociation,
      this.cardFamilyName,
      this.force3Ds,
      this.bankCode,
      this.bankName,
      this.forceCvc,
      this.installmentPrices});

  @JsonKey(name: 'BinNumber')
  String? binNumber;

  @JsonKey(name: 'Commercial')
  int? commercial;

  @JsonKey(name: 'Price')
  String? price;

  @JsonKey(name: 'CardType')
  String? cardType;

  @JsonKey(name: 'CardAssociation')
  String? cardAssociation;

  @JsonKey(name: 'CardFamilyName')
  String? cardFamilyName;

  @JsonKey(name: 'Force3Ds')
  int? force3Ds;

  @JsonKey(name: 'BankCode')
  int? bankCode;

  @JsonKey(name: 'BankName')
  String? bankName;

  @JsonKey(name: 'ForceCvc')
  int? forceCvc;

  @JsonKey(name: 'InstallmentPrices')
  List<InstallmentPrice>? installmentPrices;

  factory InstallmentDetail.fromJson(Map<String, dynamic> json) =>
      _$InstallmentDetailFromJson(json);

  Map<String, dynamic> toJson() => _$InstallmentDetailToJson(this);
}
