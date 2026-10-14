import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../../common/user_field/user_field.dart';

part 'gift_voucher_box_model.freezed.dart';
part 'gift_voucher_box_model.g.dart';

@freezed
class GiftVoucherBoxModel extends StoreJsonSerializable<GiftVoucherBoxModel>
    with _$GiftVoucherBoxModel {
  factory GiftVoucherBoxModel(
      {@JsonKey(name: 'Display', includeIfNull: false)
      @Default(false)
      bool? display,
      @JsonKey(name: 'Message', includeIfNull: false) String? message,
      @JsonKey(name: 'IsApplied', includeIfNull: false)
      @Default(false)
      bool? isApplied,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _GiftVoucherBoxModel;

  factory GiftVoucherBoxModel.fromJson(Map<String, dynamic> json) =>
      _$GiftVoucherBoxModelFromJson(json);
}
