import 'dart:convert';

import 'package:flutter/src/widgets/framework.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/domain/entities/models/checkout/checkout_confirm_model/checkout_confirm_model.dart';
import 'package:store_user_app/domain/entities/models/checkout/update_section_json_model/update_section_json_model.dart';
import 'package:store_user_app/domain/repositories/checkout/checkout_repository.dart';
import 'package:store_user_app/presentation/screens/checkout/providers/checkout_controller.dart';
import 'package:store_user_app/presentation/screens/checkout/providers/checkout_state.dart';
import 'package:store_user_app/presentation/screens/checkout/view_models/check_out_route_data.dart';
import 'package:store_user_app/presentation/screens/checkout/view_models/checkout_step.dart';
import 'package:store_user_app/presentation/screens/checkout/view_models/checkout_step_response.dart';
import 'package:store_user_app/presentation/screens/checkout/widgets/confirm_step.dart';

part 'confirm_step_command.g.dart';

@riverpod
class ConfirmStepCommand extends _$ConfirmStepCommand
    implements CheckoutCommand<CheckoutConfirmModel> {
  late CheckoutRepository _apiClient;
  @override
  FutureOr<CheckoutStepResponse> build() async {
    _apiClient = await getIt.getAsync<CheckoutRepository>();
    return CheckoutStepResponse();
  }

  @override
  Future<CheckoutStepResponse?> execute(
      CheckoutState context, Map<String, dynamic>? model) async {
    try {
      if (model != null) {
        var instance =
        CheckoutConfirmModel.fromJson(jsonDecode(jsonEncode(model)));

        var confirmResponse = await _apiClient.postCheckoutConfirmOrder();

        return CheckoutStepResponse(
          UpdateSection: confirmResponse?.data?.update_section,
          goToSection: confirmResponse?.data?.goToSection,
          modelState: confirmResponse?.data?.model_state ?? [],
          error: confirmResponse?.data?.error,
          message: confirmResponse?.data?.message,
          success: confirmResponse?.data?.success,
          redirect: confirmResponse?.data?.redirect,
        );
      }

      return CheckoutStepResponse(
        UpdateSection: UpdateSectionJsonModel(
          model: model,
          name: CheckoutStep.confirmOrder.name,
        ),
        goToSection: CheckoutStep.confirmOrder.name,
        message: 'ShippingMethodModel cannot converted from model',
      );
    } catch (e) {
      return CheckoutStepResponse(
        UpdateSection: UpdateSectionJsonModel(
          model: model,
          name: CheckoutStep.confirmOrder.name,
        ),
        goToSection: CheckoutStep.confirmOrder.name,
        message: 'ConfirmOrderModel cannot converted from model',
      );
    }
  }

  @override
  CheckoutConfirmModel getModelWithStepResponse(
      CheckoutStepResponse? stepResponse) {
    if (stepResponse != null &&
        stepResponse.UpdateSection != null &&
        stepResponse.UpdateSection!.model != null) {
      return CheckoutConfirmModel.fromJson(
          jsonDecode(jsonEncode(stepResponse.UpdateSection!.model!)));
    }

    return CheckoutConfirmModel();
  }

  @override
  Widget stepContent(CheckoutConfirmModel model, CheckOutRouteData routeData) {
    return ConfirmStep(routeData: routeData, confirmModel: model);
  }
}
