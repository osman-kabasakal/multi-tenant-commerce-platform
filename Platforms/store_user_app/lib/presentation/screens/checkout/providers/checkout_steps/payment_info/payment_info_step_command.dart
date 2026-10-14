import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/domain/entities/models/checkout/update_section_json_model/update_section_json_model.dart';
import 'package:store_user_app/domain/repositories/checkout/checkout_repository.dart';
import 'package:store_user_app/presentation/screens/checkout/providers/checkout_controller.dart';
import 'package:store_user_app/presentation/screens/checkout/providers/checkout_state.dart';
import 'package:store_user_app/presentation/screens/checkout/view_models/check_out_route_data.dart';
import 'package:store_user_app/presentation/screens/checkout/view_models/checkout_step.dart';
import 'package:store_user_app/presentation/screens/checkout/view_models/checkout_step_response.dart';
import 'package:store_user_app/presentation/screens/checkout/view_models/payment_info_step_model.dart';
import 'package:store_user_app/presentation/screens/checkout/widgets/payment_info_step.dart';

part 'payment_info_step_command.g.dart';

@riverpod
class PaymentInfoStepCommand extends _$PaymentInfoStepCommand
    implements CheckoutCommand<PaymentInfoStepModel> {
  late final CheckoutRepository _apiClient;
  @override
  FutureOr<PaymentInfoStepModel> build() async {
    _apiClient = await getIt.getAsync<CheckoutRepository>();
    return PaymentInfoStepModel();
  }

  @override
  Future<CheckoutStepResponse?> execute(
      CheckoutState context, Map<String, dynamic>? model) async {
    try {
      if (model != null) {
        var instance = (jsonDecode(jsonEncode(model)) as Map<String, dynamic>)
            .map((key, value) => MapEntry(key, value.toString()));
        var response = await _apiClient.postCheckoutSavePaymentInfo(instance);

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
          name: CheckoutStep.paymentInfo.name,
        ),
        goToSection: CheckoutStep.paymentInfo.name,
        message: 'paymentInfoModel cannot converted from model',
      );
    } catch (e) {
      return CheckoutStepResponse(
        UpdateSection: UpdateSectionJsonModel(
          model: model,
          name: CheckoutStep.paymentInfo.name,
        ),
        goToSection: CheckoutStep.paymentInfo.name,
        message: 'paymentInfoModel cannot converted from model',
      );
    }
  }

  @override
  PaymentInfoStepModel getModelWithStepResponse(
      CheckoutStepResponse? stepResponse) {
    if (stepResponse != null &&
        stepResponse.UpdateSection?.name == CheckoutStep.paymentInfo.name) {
      return PaymentInfoStepModel.fromJson(
          jsonDecode(jsonEncode(stepResponse.UpdateSection?.model)));
    }
    return PaymentInfoStepModel();
  }

  @override
  Widget stepContent(PaymentInfoStepModel model, CheckOutRouteData routeData) {
    return PaymentInfoStep(routeData: routeData, paymentInfoStepModel: model);
  }
}
