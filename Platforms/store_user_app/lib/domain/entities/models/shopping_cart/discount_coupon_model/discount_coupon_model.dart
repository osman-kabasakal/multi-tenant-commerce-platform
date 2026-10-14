import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

part 'discount_coupon_model.freezed.dart';
part 'discount_coupon_model.g.dart';

@freezed
class DiscountCouponModel extends StoreJsonSerializable<DiscountCouponModel>
    with _$DiscountCouponModel {
  factory DiscountCouponModel(
      {@JsonKey(name: 'DiscountCouponCode', includeIfNull: false)
      String? discountCouponCode}) = _DiscountCouponModel;

  factory DiscountCouponModel.fromJson(Map<String, dynamic> json) =>
      _$DiscountCouponModelFromJson(json);
}
