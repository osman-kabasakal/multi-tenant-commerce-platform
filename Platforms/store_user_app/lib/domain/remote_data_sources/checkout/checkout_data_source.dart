import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import 'package:store_user_app/core/models/network/api_response.dart';
import '../../entities/models/checkout/checkout_model/checkout_model.dart';
import '../../entities/anonymous_type_83_eff621/anonymous_type_83_eff621.dart';
import '../../entities/anonymous_type__f238_a175/anonymous_type__f238_a175.dart';
import '../../entities/anonymous_type__da179_d76/anonymous_type__da179_d76.dart';
import '../../entities/anonymous_type_55_b93_bb6/anonymous_type_55_b93_bb6.dart';
import '../../entities/models/checkout/checkout_completed_model/checkout_completed_model.dart';
import '../../entities/anonymous_type_2_fbe9_f46/anonymous_type_2_fbe9_f46.dart';
import '../../entities/models/checkout/checkout_billing_address_model/checkout_billing_address_model.dart';
import '../../entities/models/checkout/checkout_shipping_address_model/checkout_shipping_address_model.dart';
import '../../entities/models/checkout/checkout_shipping_method_model/checkout_shipping_method_model.dart';
import '../../entities/models/checkout/checkout_payment_method_model/checkout_payment_method_model.dart';

part 'checkout_data_source.g.dart';

@RestApi()
@lazySingleton
abstract class CheckoutDataSource {
  @factoryMethod
  factory CheckoutDataSource(Dio dio) {
    return _CheckoutDataSource(dio);
  }

  @GET('/Checkout/Index')
  Future<dynamic> getCheckoutIndex();

  @GET('/Checkout/Start')
  @Extra({'responseType': ApiResponse<CheckoutModel>()})
  Future<ApiResponse<CheckoutModel>> getCheckoutStart();

  @POST('/Checkout/SaveBilling')
  @Extra({'responseType': ApiResponse<AnonymousType_83EFF621>()})
  Future<ApiResponse<AnonymousType_83EFF621>> postCheckoutSaveBilling(
      @Body() CheckoutBillingAddressModel model);

  @POST('/Checkout/SaveShipping')
  @Extra({'responseType': ApiResponse<AnonymousType_F238A175>()})
  Future<ApiResponse<AnonymousType_F238A175>> postCheckoutSaveShipping(
      @Body() CheckoutShippingAddressModel model);

  @POST('/Checkout/SaveShippingMethod')
  @Extra({'responseType': ApiResponse<AnonymousType_DA179D76>()})
  Future<ApiResponse<AnonymousType_DA179D76>> postCheckoutSaveShippingMethod(
      @Body() CheckoutShippingMethodModel model);

  @GET('/Checkout/GetShippingFormPartialView')
  @Extra({'responseType': ApiResponse<String>()})
  Future<ApiResponse<String>> getCheckoutGetShippingFormPartialView(
      @Query('shippingOption') String shippingOption);

  @POST('/Checkout/SavePaymentMethod')
  @Extra({'responseType': ApiResponse<AnonymousType_55B93BB6>()})
  Future<ApiResponse<AnonymousType_55B93BB6>> postCheckoutSavePaymentMethod(
      @Body() CheckoutPaymentMethodModel model);

  @POST('/Checkout/SavePaymentInfo')
  @Extra({'responseType': ApiResponse<AnonymousType_55B93BB6>()})
  Future<ApiResponse<AnonymousType_55B93BB6>> postCheckoutSavePaymentInfo(
      @Body() Map<String, String> model);

  @GET('/Checkout/Completed')
  @Extra({'responseType': ApiResponse<CheckoutCompletedModel>()})
  Future<ApiResponse<CheckoutCompletedModel>> getCheckoutCompleted(
      @Query('orderId') String orderId);

  @POST('/Checkout/ConfirmOrder')
  @Extra({'responseType': ApiResponse<AnonymousType_2FBE9F46>()})
  Future<ApiResponse<AnonymousType_2FBE9F46>> postCheckoutConfirmOrder();

  @GET('/Checkout/CompleteRedirectionPayment')
  Future<dynamic> getCheckoutCompleteRedirectionPayment(
      @Query('paymentTransactionId') String paymentTransactionId);
}
