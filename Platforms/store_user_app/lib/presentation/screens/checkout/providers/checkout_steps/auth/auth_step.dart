import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:store_user_app/core/data/events/entity_created_event.dart';
import 'package:store_user_app/core/data/events/event_bus.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/navigation/app_router.dart';
import 'package:store_user_app/core/navigation/app_router.gr.dart';
import 'package:store_user_app/core/services/background_task_queue/background_task_queue.dart';
import 'package:store_user_app/presentation/screens/checkout/providers/checkout_controller.dart';
import 'package:store_user_app/presentation/screens/checkout/providers/checkout_state.dart';
import 'package:store_user_app/presentation/screens/checkout/view_models/check_out_route_data.dart';
import 'package:store_user_app/presentation/screens/checkout/view_models/checkout_step.dart';
import 'package:store_user_app/presentation/screens/checkout/view_models/checkout_step_response.dart';
import 'package:store_user_app/presentation/screens/checkout/widgets/fail_step.dart';
import 'package:store_user_app/presentation/widgets/layout/view/load_component_when_visible.dart';

part 'auth_step.g.dart';

@riverpod
class AuthStep extends _$AuthStep
    implements CheckoutCommand<CheckoutStepResponse> {
  late final AppRouter appRouter;
  @override
  void build() {
    appRouter = getIt<AppRouter>();
    return;
  }

  @override
  Future<CheckoutStepResponse?> execute(
      CheckoutState context, Map<String, dynamic>? model) {
    if (context.routeData.requireAuthorization &&
        !context.routeData.checkoutAsGuest) {
      // appRouter.replace(SigninRoute(returnUrl: '/shopping-cart'));
      return Future.value(CheckoutStepResponse(
          error: 1,
          message:
              'Misafir olarak bu işlemi gerçekleştiremezsiniz.\nLütfen giriş yapınız.'));
    }

    return Future.value(
      CheckoutStepResponse(
        goToSection: context.checkoutModel!.shippingRequired!
            ? CheckoutStep.shippingAddress.name
            : CheckoutStep.billingAddress.name,
      ),
    );
  }

  @override
  CheckoutStepResponse getModelWithStepResponse(
      CheckoutStepResponse? stepResponse) {
    return stepResponse ?? CheckoutStepResponse();
  }

  @override
  Widget stepContent(CheckoutStepResponse model, CheckOutRouteData routeData) {
    if (model.error == 1) {
      return LoadComponentWhenVisible(
        key: ValueKey('fail_auth_step'),
        showLoadingIndicator: false,
        onVisible: () async {
          getIt<BackgroundTaskQueue>().enqueueTask((ct) async {
            getIt<EventBus>().publish(
                EntityCreatedEvent<CheckoutStepResponse>(entity: model));
          });
        },
        builder: (isVisible) => FailStep.withInfo(
          title: 'Ödeme Başarısız',
          message: model.message ?? 'Ödeme işlemi sırasında bir hata oluştu.',
          buttonText: 'Giriş Yap',
          onPressed: () async {
            appRouter.popAndPush(CartRoute());
          },
        ),
      );
    }
    return SafeArea(
        child: Scaffold(
            body: LoadComponentWhenVisible(
                visibilityFraction: 0,
                key: ValueKey('auth_step'),
                showLoadingIndicator: false,
                onVisible: () async {
                  ref
                      .read(checkoutControllerProvider(routeData).notifier)
                      .execute({});
                },
                builder: (isVisible) =>
                    Center(child: CircularProgressIndicator()))));
  }
}
