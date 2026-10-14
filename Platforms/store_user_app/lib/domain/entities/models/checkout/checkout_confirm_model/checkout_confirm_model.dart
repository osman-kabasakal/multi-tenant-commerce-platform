import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import 'order_review_data_model/order_review_data_model.dart';

import '../../../common/user_field/user_field.dart';


part 'checkout_confirm_model.freezed.dart';
part 'checkout_confirm_model.g.dart';

@freezed
class CheckoutConfirmModel extends StoreJsonSerializable<CheckoutConfirmModel> with _$CheckoutConfirmModel {
  factory CheckoutConfirmModel({ 
    @JsonKey(name: 'TermsOfServiceOnOrderConfirmPage', includeIfNull: false)
    @Default(false) bool? termsOfServiceOnOrderConfirmPage,

    @JsonKey(name: 'MinOrderTotalWarning', includeIfNull: false)
     String? minOrderTotalWarning,

    @JsonKey(name: 'Warnings', includeIfNull: false)
    @Default([]) List<String>? warnings,

    @JsonKey(name: 'OrderReviewData', includeIfNull: false)
     OrderReviewDataModel? orderReviewData,

    @JsonKey(name: 'UserFields', includeIfNull: false)
    @Default([]) List<UserField>? userFields
}) = _CheckoutConfirmModel;

  factory CheckoutConfirmModel.fromJson(Map<String, dynamic> json) =>
      _$CheckoutConfirmModelFromJson(json);
}