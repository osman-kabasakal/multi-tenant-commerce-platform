import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:store_user_app/domain/entities/models/checkout/update_section_json_model/update_section_json_model.dart';
import 'package:store_user_app/presentation/screens/checkout/providers/checkout_controller.dart';
import 'package:store_user_app/presentation/screens/checkout/providers/checkout_state.dart';
import 'package:store_user_app/presentation/screens/checkout/view_models/check_out_route_data.dart';
import 'package:store_user_app/presentation/screens/checkout/view_models/checkout_step.dart';
import 'package:store_user_app/presentation/screens/checkout/view_models/checkout_step_response.dart';
import 'package:store_user_app/presentation/screens/checkout/widgets/redirect_step.dart';

part 'redirect_step_command.g.dart';

@riverpod
class RedirectStepCommand extends _$RedirectStepCommand
    implements CheckoutCommand<CheckoutStepResponse> {
  @override
  FutureOr<CheckoutStepResponse?> build() async {
    return CheckoutStepResponse();
  }

  @override
  Future<CheckoutStepResponse?> execute(
      CheckoutState context, Map<String, dynamic>? model) {
    if (model != null && model.containsKey('complete')) {
      return Future.value(CheckoutStepResponse(
          success: 1,
          UpdateSection: UpdateSectionJsonModel(
              name: CheckoutStep.completed.name, model: model)));
    }
    return Future.value(CheckoutStepResponse(error: 1));
  }

  @override
  CheckoutStepResponse getModelWithStepResponse(
      CheckoutStepResponse? stepResponse) {
    return stepResponse!;
  }

  @override
  Widget stepContent(CheckoutStepResponse model, CheckOutRouteData routeData) {
    return RedirectStep(
      redirectedMessage: model,
      routeData: routeData,
    );
  }
}
