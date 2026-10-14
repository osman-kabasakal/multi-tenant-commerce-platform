import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../discount_box_model/discount_info_model/discount_info_model.dart';

import '../../../../common/user_field/user_field.dart';

part 'discount_box_model.freezed.dart';
part 'discount_box_model.g.dart';

@freezed
class DiscountBoxModel extends StoreJsonSerializable<DiscountBoxModel>
    with _$DiscountBoxModel {
  factory DiscountBoxModel(
      {@JsonKey(name: 'AppliedDiscountsWithCodes', includeIfNull: false)
      @Default([])
      List<DiscountInfoModel>? appliedDiscountsWithCodes,
      @JsonKey(name: 'Display', includeIfNull: false)
      @Default(false)
      bool? display,
      @JsonKey(name: 'Message', includeIfNull: false) String? message,
      @JsonKey(name: 'IsApplied', includeIfNull: false)
      @Default(false)
      bool? isApplied,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _DiscountBoxModel;

  factory DiscountBoxModel.fromJson(Map<String, dynamic> json) =>
      _$DiscountBoxModelFromJson(json);
}
