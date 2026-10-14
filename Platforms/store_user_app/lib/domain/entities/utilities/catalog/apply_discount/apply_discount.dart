import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

part 'apply_discount.freezed.dart';
part 'apply_discount.g.dart';

@freezed
class ApplyDiscount extends StoreJsonSerializable<ApplyDiscount>
    with _$ApplyDiscount {
  factory ApplyDiscount(
      {@JsonKey(name: 'DiscountId', includeIfNull: false) String? discountId,
      @JsonKey(name: 'CouponCode', includeIfNull: false) String? couponCode,
      @JsonKey(name: 'IsCumulative', includeIfNull: false)
      @Default(false)
      bool? isCumulative}) = _ApplyDiscount;

  factory ApplyDiscount.fromJson(Map<String, dynamic> json) =>
      _$ApplyDiscountFromJson(json);
}
