import 'package:injectable/injectable.dart';
import 'package:store_user_app/core/data/repository/base_repository.dart';
import 'package:store_user_app/core/models/network/api_response.dart';

import '../../remote_data_sources/checkout/checkout_data_source.dart';
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

@lazySingleton
class CheckoutRepository extends BaseRepository {
  final CheckoutDataSource _dataSource;

  CheckoutRepository(this._dataSource, super.decorator, super.eventBus);

  Future<dynamic> getCheckoutIndex() async {
    return await decorator.execute<dynamic>(
      operationName: "/Checkout/Index",
      cacheKey: null, //generateCacheKey("/Checkout/Index", []),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getCheckoutIndex();
      },
    );
  }

  Future<ApiResponse<CheckoutModel>?> getCheckoutStart() async {
    return await decorator.execute<ApiResponse<CheckoutModel>>(
      operationName: "/Checkout/Start",
      cacheKey: null, //generateCacheKey("/Checkout/Start", []),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getCheckoutStart();
      },
    );
  }

  Future<ApiResponse<AnonymousType_83EFF621>?> postCheckoutSaveBilling(
      CheckoutBillingAddressModel model) async {
    return await decorator.execute<ApiResponse<AnonymousType_83EFF621>>(
      operationName: "/Checkout/SaveBilling",
      cacheKey: null, //generateCacheKey("/Checkout/SaveBilling", [model]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.postCheckoutSaveBilling(model);
      },
    );
  }

  Future<ApiResponse<AnonymousType_F238A175>?> postCheckoutSaveShipping(
      CheckoutShippingAddressModel model) async {
    return await decorator.execute<ApiResponse<AnonymousType_F238A175>>(
      operationName: "/Checkout/SaveShipping",
      cacheKey: null, //generateCacheKey("/Checkout/SaveShipping", [model]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.postCheckoutSaveShipping(model);
      },
    );
  }

  Future<ApiResponse<AnonymousType_DA179D76>?> postCheckoutSaveShippingMethod(
      CheckoutShippingMethodModel model) async {
    return await decorator.execute<ApiResponse<AnonymousType_DA179D76>>(
      operationName: "/Checkout/SaveShippingMethod",
      cacheKey:
          null, //generateCacheKey("/Checkout/SaveShippingMethod", [model]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.postCheckoutSaveShippingMethod(model);
      },
    );
  }

  Future<ApiResponse<String>?> getCheckoutGetShippingFormPartialView(
      String shippingOption) async {
    return await decorator.execute<ApiResponse<String>>(
      operationName: "/Checkout/GetShippingFormPartialView",
      cacheKey:
          null, //generateCacheKey("/Checkout/GetShippingFormPartialView", [shippingOption]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource
            .getCheckoutGetShippingFormPartialView(shippingOption);
      },
    );
  }

  Future<ApiResponse<AnonymousType_55B93BB6>?> postCheckoutSavePaymentMethod(
      CheckoutPaymentMethodModel model) async {
    return await decorator.execute<ApiResponse<AnonymousType_55B93BB6>>(
      operationName: "/Checkout/SavePaymentMethod",
      cacheKey:
          null, //generateCacheKey("/Checkout/SavePaymentMethod", [model]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.postCheckoutSavePaymentMethod(model);
      },
    );
  }

  Future<ApiResponse<AnonymousType_55B93BB6>?> postCheckoutSavePaymentInfo(
      Map<String, String> model) async {
    return await decorator.execute<ApiResponse<AnonymousType_55B93BB6>>(
      operationName: "/Checkout/SavePaymentInfo",
      cacheKey: null, //generateCacheKey("/Checkout/SavePaymentInfo", [model]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.postCheckoutSavePaymentInfo(model);
      },
    );
  }

  Future<ApiResponse<CheckoutCompletedModel>?> getCheckoutCompleted(
      String orderId) async {
    return await decorator.execute<ApiResponse<CheckoutCompletedModel>>(
      operationName: "/Checkout/Completed",
      cacheKey: null, //generateCacheKey("/Checkout/Completed", [orderId]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.getCheckoutCompleted(orderId);
      },
    );
  }

  Future<ApiResponse<AnonymousType_2FBE9F46>?>
      postCheckoutConfirmOrder() async {
    return await decorator.execute<ApiResponse<AnonymousType_2FBE9F46>>(
      operationName: "/Checkout/ConfirmOrder",
      cacheKey: null, //generateCacheKey("/Checkout/ConfirmOrder", []),
      cacheDuration: null,
      operation: () async {
        return await _dataSource.postCheckoutConfirmOrder();
      },
    );
  }

  Future<dynamic> getCheckoutCompleteRedirectionPayment(
      String paymentTransactionId) async {
    return await decorator.execute<dynamic>(
      operationName: "/Checkout/CompleteRedirectionPayment",
      cacheKey:
          null, //generateCacheKey("/Checkout/CompleteRedirectionPayment", [paymentTransactionId]),
      cacheDuration: null,
      operation: () async {
        return await _dataSource
            .getCheckoutCompleteRedirectionPayment(paymentTransactionId);
      },
    );
  }
}
