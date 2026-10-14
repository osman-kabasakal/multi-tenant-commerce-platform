import 'dart:convert';

import 'package:flutter/src/widgets/framework.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/logger/logger_service.dart';
import 'package:store_user_app/domain/entities/models/checkout/checkout_billing_address_model/checkout_billing_address_model.dart';
import 'package:store_user_app/domain/entities/models/checkout/update_section_json_model/update_section_json_model.dart';
import 'package:store_user_app/domain/repositories/checkout/checkout_repository.dart';
import 'package:store_user_app/presentation/screens/checkout/providers/checkout_controller.dart';
import 'package:store_user_app/presentation/screens/checkout/providers/checkout_state.dart';
import 'package:store_user_app/presentation/screens/checkout/view_models/check_out_route_data.dart';
import 'package:store_user_app/presentation/screens/checkout/view_models/checkout_step.dart';
import 'package:store_user_app/presentation/screens/checkout/view_models/checkout_step_response.dart';
import 'package:store_user_app/presentation/screens/checkout/widgets/billing_step.dart';

part 'billing_step_command.g.dart';

@riverpod
class BillingStepCommand extends _$BillingStepCommand
    implements CheckoutCommand<CheckoutBillingAddressModel> {
  late CheckoutRepository _apiClient;
  @override
  FutureOr<CheckoutStepResponse?> build() async {
    _apiClient = await getIt.getAsync<CheckoutRepository>();
    return CheckoutStepResponse();
  }

  @override
  Future<CheckoutStepResponse?> execute(
    CheckoutState context,
    Map<String, dynamic>? model,
  ) async {
    try {
      if (model != null) {
        var addressInstance = CheckoutBillingAddressModel.fromJson(
          jsonDecode(jsonEncode(model)),
        );

        var saveBillingResponse = await _apiClient.postCheckoutSaveBilling(
          addressInstance,
        );
        return CheckoutStepResponse(
          UpdateSection: saveBillingResponse?.data?.update_section,
          goToSection: saveBillingResponse?.data?.goToSection,
          modelState: saveBillingResponse?.data?.model_state ?? [],
          error: saveBillingResponse?.data?.error,
          message: saveBillingResponse?.data?.message,
        );
      }

      return CheckoutStepResponse(
        UpdateSection: UpdateSectionJsonModel(
          model: model,
          name: CheckoutStep.billingAddress.name,
        ),
        goToSection: CheckoutStep.billingAddress.name,
        message: 'Adres bilgileri zorunludur',
      );
    } catch (e) {
      LoggerService.error('Error in shipping command execution', e);
      return CheckoutStepResponse(
        UpdateSection: UpdateSectionJsonModel(
          model: model,
          name: CheckoutStep.billingAddress.name,
        ),
        goToSection: CheckoutStep.billingAddress.name,
        message: e.toString(),
      );
    }
  }

  @override
  CheckoutBillingAddressModel getModelWithStepResponse(
    CheckoutStepResponse? stepResponse,
  ) {
    if (stepResponse != null &&
        stepResponse.UpdateSection != null &&
        stepResponse.UpdateSection!.model != null) {
      return CheckoutBillingAddressModel.fromJson(
        jsonDecode(jsonEncode(stepResponse.UpdateSection!.model!)),
      );
    }
    return CheckoutBillingAddressModel();
  }

  @override
  Widget stepContent(
    CheckoutBillingAddressModel model,
    CheckOutRouteData routeData,
  ) {
    return BillingStep(billingAddressModel: model, routeData: routeData);
  }
}
