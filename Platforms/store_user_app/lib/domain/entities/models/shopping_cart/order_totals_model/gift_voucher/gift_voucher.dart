import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../../common/user_field/user_field.dart';

part 'gift_voucher.freezed.dart';
part 'gift_voucher.g.dart';

@freezed
class GiftVoucher extends StoreJsonSerializable<GiftVoucher>
    with _$GiftVoucher {
  factory GiftVoucher(
      {@JsonKey(name: 'CouponCode', includeIfNull: false) String? couponCode,
      @JsonKey(name: 'Amount', includeIfNull: false) String? amount,
      @JsonKey(name: 'Remaining', includeIfNull: false) String? remaining,
      @JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _GiftVoucher;

  factory GiftVoucher.fromJson(Map<String, dynamic> json) =>
      _$GiftVoucherFromJson(json);
}
