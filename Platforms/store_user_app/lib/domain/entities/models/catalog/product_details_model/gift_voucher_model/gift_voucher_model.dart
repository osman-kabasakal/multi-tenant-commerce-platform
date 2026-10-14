import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../../catalog/gift_voucher_type/gift_voucher_type.dart';

import '../../../../common/user_field/user_field.dart';

part 'gift_voucher_model.freezed.dart';
part 'gift_voucher_model.g.dart';

@freezed
class GiftVoucherModel extends StoreJsonSerializable<GiftVoucherModel>
    with _$GiftVoucherModel {
  factory GiftVoucherModel(
      {@JsonKey(name: 'IsGiftVoucher', includeIfNull: false)
      @Default(false)
      bool? isGiftVoucher,
      @JsonKey(name: 'RecipientName', includeIfNull: false)
      String? recipientName,
      @JsonKey(name: 'RecipientEmail', includeIfNull: false)
      String? recipientEmail,
      @JsonKey(name: 'SenderName', includeIfNull: false) String? senderName,
      @JsonKey(name: 'SenderEmail', includeIfNull: false) String? senderEmail,
      @JsonKey(name: 'Message', includeIfNull: false) String? message,
      @JsonKey(name: 'GiftVoucherType', includeIfNull: false)
      @Default(GiftVoucherType.virtual)
      GiftVoucherType? giftVoucherType,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _GiftVoucherModel;

  factory GiftVoucherModel.fromJson(Map<String, dynamic> json) =>
      _$GiftVoucherModelFromJson(json);
}
