import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../../common/user_field/user_field.dart';

part 'discount_info_model.freezed.dart';
part 'discount_info_model.g.dart';

@freezed
class DiscountInfoModel extends StoreJsonSerializable<DiscountInfoModel>
    with _$DiscountInfoModel {
  factory DiscountInfoModel(
      {@JsonKey(name: 'CouponCode', includeIfNull: false) String? couponCode,
      @JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _DiscountInfoModel;

  factory DiscountInfoModel.fromJson(Map<String, dynamic> json) =>
      _$DiscountInfoModelFromJson(json);
}
