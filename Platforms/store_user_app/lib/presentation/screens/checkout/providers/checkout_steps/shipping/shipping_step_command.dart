import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/logger/logger_service.dart';
import 'package:store_user_app/domain/entities/models/checkout/checkout_shipping_address_model/checkout_shipping_address_model.dart';
import 'package:store_user_app/domain/entities/models/checkout/update_section_json_model/update_section_json_model.dart'
    show UpdateSectionJsonModel;
import 'package:store_user_app/domain/repositories/checkout/checkout_repository.dart';
import 'package:store_user_app/presentation/screens/checkout/providers/checkout_state.dart';
import 'package:store_user_app/presentation/screens/checkout/view_models/check_out_route_data.dart';
import 'package:store_user_app/presentation/screens/checkout/view_models/checkout_step.dart';
import 'package:store_user_app/presentation/screens/checkout/view_models/checkout_step_response.dart';

import '../../../widgets/shipping_step.dart';
import '../../checkout_controller.dart';

part 'shipping_step_command.g.dart';

@riverpod
class ShippingStepCommand extends _$ShippingStepCommand
    implements CheckoutCommand<CheckoutShippingAddressModel> {
  late final CheckoutRepository _apiClient;
  @override
  FutureOr<CheckoutShippingAddressModel> build() async {
    _apiClient = await getIt.getAsync<CheckoutRepository>();
    return CheckoutShippingAddressModel();
  }

  @override
  Future<CheckoutStepResponse?> execute(
      CheckoutState context, Map<String, dynamic>? model) async {
    try {
      if (model != null) {
        var addressInstance = CheckoutShippingAddressModel.fromJson(
            jsonDecode(jsonEncode(model)));

        var saveShippingResponse = await _apiClient.postCheckoutSaveShipping(
          addressInstance,
        );
        return CheckoutStepResponse(
          UpdateSection: saveShippingResponse?.data?.update_section,
          goToSection: saveShippingResponse?.data?.goToSection,
          modelState: saveShippingResponse?.data?.model_state ?? [],
          error: saveShippingResponse?.data?.error,
          message: saveShippingResponse?.data?.message,
        );
      }

      return CheckoutStepResponse(
        UpdateSection: UpdateSectionJsonModel(
          model: model,
          name: CheckoutStep.shippingAddress.name,
        ),
        goToSection: CheckoutStep.shippingAddress.name,
        message: 'AddressModel cannot be converted from model',
      );
    } catch (e) {
      LoggerService.error('Error in shipping command execution', e);
      return CheckoutStepResponse(
        UpdateSection: UpdateSectionJsonModel(
          model: model,
          name: CheckoutStep.shippingAddress.name,
        ),
        goToSection: 'shipping',
        message: e.toString(),
      );
    }
  }

  @override
  CheckoutShippingAddressModel getModelWithStepResponse(
      CheckoutStepResponse? stepResponse) {
    if (stepResponse != null &&
        stepResponse.UpdateSection != null &&
        stepResponse.UpdateSection!.model != null) {
      return CheckoutShippingAddressModel.fromJson(
          jsonDecode(jsonEncode(stepResponse.UpdateSection!.model!)));
    }
    return CheckoutShippingAddressModel();
  }

  @override
  Widget stepContent(
      CheckoutShippingAddressModel model, CheckOutRouteData routeData) {
    return ShippingStep(
      shippingAddressModel: model,
      routeData: routeData,
    );
  }
}
