import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/domain/entities/models/checkout/checkout_shipping_method_model/checkout_shipping_method_model.dart';
import 'package:store_user_app/domain/entities/models/checkout/update_section_json_model/update_section_json_model.dart';
import 'package:store_user_app/domain/repositories/checkout/checkout_repository.dart';
import 'package:store_user_app/presentation/screens/checkout/providers/checkout_controller.dart';
import 'package:store_user_app/presentation/screens/checkout/providers/checkout_state.dart';
import 'package:store_user_app/presentation/screens/checkout/view_models/check_out_route_data.dart';
import 'package:store_user_app/presentation/screens/checkout/view_models/checkout_step.dart';
import 'package:store_user_app/presentation/screens/checkout/view_models/checkout_step_response.dart';
import 'package:store_user_app/presentation/screens/checkout/widgets/shipping_method_step.dart';

part 'shipping_method_step_command.g.dart';

@riverpod
class ShippingMethodStepCommand extends _$ShippingMethodStepCommand
    implements CheckoutCommand<CheckoutShippingMethodModel> {
  late final CheckoutRepository _apiClient;
  @override
  FutureOr<CheckoutShippingMethodModel> build() async {
    _apiClient = await getIt.getAsync<CheckoutRepository>();
    return CheckoutShippingMethodModel();
  }

  @override
  Future<CheckoutStepResponse?> execute(
      CheckoutState context, Map<String, dynamic>? model) async {
    try {
      if (model != null) {
        var instance =
            CheckoutShippingMethodModel.fromJson(jsonDecode(jsonEncode(model)));

        var resposne =
            await _apiClient.postCheckoutSaveShippingMethod(instance);
        return CheckoutStepResponse(
          UpdateSection: resposne?.data?.update_section,
          goToSection: resposne?.data?.goToSection,
          modelState: resposne?.data?.model_state ?? [],
          error: resposne?.data?.error,
          message: resposne?.data?.message,
        );
      }

      return CheckoutStepResponse(
        UpdateSection: UpdateSectionJsonModel(
          model: model,
          name: CheckoutStep.shippingMethod.name,
        ),
        goToSection: CheckoutStep.shippingMethod.name,
        message: 'ShippingMethodModel cannot converted from model',
      );
    } catch (e) {
      return CheckoutStepResponse(
        UpdateSection: UpdateSectionJsonModel(
          model: model,
          name: CheckoutStep.shippingMethod.name,
        ),
        goToSection: CheckoutStep.shippingMethod.name,
        message: 'ShippingMethodModel cannot converted from model',
      );
    }
  }

  @override
  CheckoutShippingMethodModel getModelWithStepResponse(
      CheckoutStepResponse? stepResponse) {
    if (stepResponse != null &&
        stepResponse.UpdateSection != null &&
        stepResponse.UpdateSection!.model != null) {
      return CheckoutShippingMethodModel.fromJson(
          jsonDecode(jsonEncode(stepResponse.UpdateSection!.model!)));
    }
    return CheckoutShippingMethodModel();
  }

  @override
  Widget stepContent(
      CheckoutShippingMethodModel model, CheckOutRouteData routeData) {
    return ShippingMethodStep(
      routeData: routeData,
      shippingMethodModel: model,
    );
  }
}
