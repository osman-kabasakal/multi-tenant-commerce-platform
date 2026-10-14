import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

part 'gift_voucher_coupon_model.freezed.dart';
part 'gift_voucher_coupon_model.g.dart';

@freezed
class GiftVoucherCouponModel
    extends StoreJsonSerializable<GiftVoucherCouponModel>
    with _$GiftVoucherCouponModel {
  factory GiftVoucherCouponModel(
      {@JsonKey(name: 'GiftVoucherCouponCode', includeIfNull: false)
      String? giftVoucherCouponCode}) = _GiftVoucherCouponModel;

  factory GiftVoucherCouponModel.fromJson(Map<String, dynamic> json) =>
      _$GiftVoucherCouponModelFromJson(json);
}
