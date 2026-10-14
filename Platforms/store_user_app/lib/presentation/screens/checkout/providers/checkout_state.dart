import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/domain/entities/models/checkout/checkout_billing_address_model/checkout_billing_address_model.dart';
import 'package:store_user_app/domain/entities/models/checkout/checkout_completed_model/checkout_completed_model.dart';
import 'package:store_user_app/domain/entities/models/checkout/checkout_confirm_model/checkout_confirm_model.dart';
import 'package:store_user_app/domain/entities/models/checkout/checkout_model/checkout_model.dart';
import 'package:store_user_app/domain/entities/models/checkout/checkout_payment_method_model/checkout_payment_method_model.dart';
import 'package:store_user_app/domain/entities/models/checkout/checkout_shipping_address_model/checkout_shipping_address_model.dart';
import 'package:store_user_app/domain/entities/models/checkout/checkout_shipping_method_model/checkout_shipping_method_model.dart';
import 'package:store_user_app/domain/entities/models/shopping_cart/shopping_cart_model/shopping_cart_model.dart';

import '../view_models/check_out_route_data.dart';
import '../view_models/checkout_step.dart';
import '../view_models/checkout_step_response.dart';

part 'checkout_state.freezed.dart';

@freezed
class CheckoutState with _$CheckoutState {
  const factory CheckoutState({
    required CheckoutStep currentStep,
    required ShoppingCartModel cart,
    required CheckOutRouteData routeData,
    CheckoutModel? checkoutModel,
    CheckoutStepResponse? currentStepResponse,
    CheckoutBillingAddressModel? selectedAddress,
    CheckoutShippingAddressModel? selectedDeliveryTime,
    CheckoutShippingMethodModel? selectedShippingMethod,
    CheckoutPaymentMethodModel? paymentMethod,
    Map<String, String>? paymentMethodInfo,
    CheckoutCompletedModel? checkoutCompleted,
    CheckoutConfirmModel? checkoutConfirm,
    String? error,
    @Default(false) bool isLoading,
  }) = _CheckoutState;
}
