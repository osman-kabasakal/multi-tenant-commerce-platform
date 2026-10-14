import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/domain/entities/models/checkout/checkout_payment_method_model/checkout_payment_method_model.dart';
import 'package:store_user_app/domain/entities/models/checkout/update_section_json_model/update_section_json_model.dart';
import 'package:store_user_app/domain/repositories/checkout/checkout_repository.dart';
import 'package:store_user_app/presentation/screens/checkout/providers/checkout_controller.dart';
import 'package:store_user_app/presentation/screens/checkout/providers/checkout_state.dart';
import 'package:store_user_app/presentation/screens/checkout/view_models/check_out_route_data.dart';
import 'package:store_user_app/presentation/screens/checkout/view_models/checkout_step.dart';
import 'package:store_user_app/presentation/screens/checkout/view_models/checkout_step_response.dart';
import 'package:store_user_app/presentation/screens/checkout/widgets/payment_method_step.dart';

part 'payment_method_step_command.g.dart';

@riverpod
class PaymentMethodStepCommand extends _$PaymentMethodStepCommand
    implements CheckoutCommand<CheckoutPaymentMethodModel> {
  late final CheckoutRepository _apiClient;

  @override
  FutureOr<CheckoutStepResponse?> build() async {
    _apiClient = await getIt.getAsync<CheckoutRepository>();
    return CheckoutStepResponse();
  }

  @override
  Future<CheckoutStepResponse?> execute(
      CheckoutState context, Map<String, dynamic>? model) async {
    try {
      if (model != null) {
        var instance =
            CheckoutPaymentMethodModel.fromJson(jsonDecode(jsonEncode(model)));
        var response = await _apiClient.postCheckoutSavePaymentMethod(instance);
        return CheckoutStepResponse(
          UpdateSection: response?.data?.update_section,
          goToSection: response?.data?.goToSection,
          modelState: response?.data?.model_state ?? [],
          error: response?.data?.error,
          message: response?.data?.message,
        );
      }
      return CheckoutStepResponse(
        UpdateSection: UpdateSectionJsonModel(
          model: model,
          name: CheckoutStep.paymentMethod.name,
        ),
        goToSection: CheckoutStep.paymentMethod.name,
        message: 'paymentMethodModel cannot converted from model',
      );
    } catch (e) {
      return CheckoutStepResponse(
        UpdateSection: UpdateSectionJsonModel(
          model: model,
          name: CheckoutStep.paymentMethod.name,
        ),
        goToSection: CheckoutStep.paymentMethod.name,
        message: 'paymentMethodModel cannot converted from model',
      );
    }
  }

  @override
  CheckoutPaymentMethodModel getModelWithStepResponse(
      CheckoutStepResponse? stepResponse) {
    if (stepResponse != null &&
        stepResponse.UpdateSection?.name == CheckoutStep.paymentMethod.name) {
      return CheckoutPaymentMethodModel.fromJson(
          jsonDecode(jsonEncode(stepResponse.UpdateSection?.model)));
    }
    return CheckoutPaymentMethodModel();
  }

  @override
  Widget stepContent(
      CheckoutPaymentMethodModel model, CheckOutRouteData routeData) {
    return PaymentMethodStep(routeData: routeData, paymentMethodModel: model);
  }
}
