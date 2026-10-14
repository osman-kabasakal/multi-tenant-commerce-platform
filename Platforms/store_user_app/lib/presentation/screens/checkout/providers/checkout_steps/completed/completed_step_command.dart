import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:store_user_app/domain/entities/models/checkout/checkout_completed_model/checkout_completed_model.dart';
import 'package:store_user_app/presentation/screens/checkout/providers/checkout_controller.dart';
import 'package:store_user_app/presentation/screens/checkout/providers/checkout_state.dart';
import 'package:store_user_app/presentation/screens/checkout/view_models/check_out_route_data.dart';
import 'package:store_user_app/presentation/screens/checkout/view_models/checkout_step_response.dart';
import 'package:store_user_app/presentation/screens/checkout/widgets/completed_step.dart';

part 'completed_step_command.g.dart';

@riverpod
class CompletedStepCommand extends _$CompletedStepCommand
    implements CheckoutCommand<CheckoutCompletedModel> {
  @override
  FutureOr<CheckoutStepResponse?> build() async {
    return CheckoutStepResponse();
  }

  @override
  Future<CheckoutStepResponse?> execute(
      CheckoutState context, Map<String, dynamic>? model) {
    throw UnimplementedError();
  }

  @override
  CheckoutCompletedModel getModelWithStepResponse(
      CheckoutStepResponse? stepResponse) {
    return CheckoutCompletedModel(
      orderId: stepResponse?.UpdateSection?.model?['orderId'],
    );
  }

  @override
  CompletedStep stepContent(
      CheckoutCompletedModel model, CheckOutRouteData routeData) {
    return CompletedStep(
      model: model,
    );
  }
}
