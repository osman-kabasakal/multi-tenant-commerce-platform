import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import 'payment_method_model/payment_method_model.dart';

import '../../../common/user_field/user_field.dart';

part 'checkout_payment_method_model.freezed.dart';
part 'checkout_payment_method_model.g.dart';

@freezed
class CheckoutPaymentMethodModel
    extends StoreJsonSerializable<CheckoutPaymentMethodModel>
    with _$CheckoutPaymentMethodModel {
  factory CheckoutPaymentMethodModel(
      {@JsonKey(name: 'PaymentMethods', includeIfNull: false)
      @Default([])
      List<PaymentMethodModel>? paymentMethods,
      @JsonKey(name: 'DisplayLoyaltyPoints', includeIfNull: false)
      @Default(false)
      bool? displayLoyaltyPoints,
      @JsonKey(name: 'LoyaltyPointsBalance', includeIfNull: false)
      int? loyaltyPointsBalance,
      @JsonKey(name: 'LoyaltyPointsAmount', includeIfNull: false)
      String? loyaltyPointsAmount,
      @JsonKey(name: 'LoyaltyPointsEnoughToPayForOrder', includeIfNull: false)
      @Default(false)
      bool? loyaltyPointsEnoughToPayForOrder,
      @JsonKey(name: 'UseLoyaltyPoints', includeIfNull: false)
      @Default(false)
      bool? useLoyaltyPoints,
      @JsonKey(name: 'PaymentMethod', includeIfNull: false)
      String? paymentMethod,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _CheckoutPaymentMethodModel;

  factory CheckoutPaymentMethodModel.fromJson(Map<String, dynamic> json) =>
      _$CheckoutPaymentMethodModelFromJson(json);
}
