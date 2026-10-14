import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'value')
enum AccountNavigationEnum {
  @JsonValue(0)
  info(0),
  @JsonValue(10)
  addresses(10),
  @JsonValue(20)
  orders(20),
  @JsonValue(30)
  outOfStockSubscriptions(30),
  @JsonValue(40)
  merchandiseReturns(40),
  @JsonValue(50)
  downloadableProducts(50),
  @JsonValue(60)
  loyaltyPoints(60),
  @JsonValue(70)
  changePassword(70),
  @JsonValue(75)
  deleteAccount(75),
  @JsonValue(100)
  vendorInfo(100),
  @JsonValue(110)
  auctions(110),
  @JsonValue(120)
  notes(120),
  @JsonValue(130)
  documents(130),
  @JsonValue(140)
  reviews(140),
  @JsonValue(150)
  courses(150),
  @JsonValue(160)
  subAccounts(160),
  @JsonValue(900)
  others(900);

  final int value;
  const AccountNavigationEnum(this.value);
}
