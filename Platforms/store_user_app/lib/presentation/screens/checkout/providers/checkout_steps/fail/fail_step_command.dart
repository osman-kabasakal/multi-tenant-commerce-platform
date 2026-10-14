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
import 'package:store_user_app/presentation/screens/checkout/view_models/checkout_step_response.dart';
import 'package:store_user_app/presentation/screens/checkout/widgets/checkout_error_page.dart';
import 'package:store_user_app/presentation/widgets/layout/view/load_component_when_visible.dart';

part 'fail_step_command.g.dart';

@riverpod
class FailStepCommand extends _$FailStepCommand
    implements CheckoutCommand<CheckoutStepResponse> {
  late final AppRouter _router;
  @override
  FutureOr<CheckoutStepResponse?> build() async {
    _router = getIt<AppRouter>();
    return CheckoutStepResponse();
  }

  @override
  Future<CheckoutStepResponse?> execute(
    CheckoutState context,
    Map<String, dynamic>? model,
  ) {
    // TODO: implement execute
    throw UnimplementedError();
  }

  @override
  CheckoutStepResponse getModelWithStepResponse(
    CheckoutStepResponse? stepResponse,
  ) {
    return stepResponse ?? CheckoutStepResponse();
  }

  @override
  Widget stepContent(CheckoutStepResponse model, CheckOutRouteData routeData) {
    return LoadComponentWhenVisible(
      key: ValueKey('fail_step'),
      showLoadingIndicator: false,
      onVisible: () async {
        getIt<BackgroundTaskQueue>().enqueueTask((ct) async {
          getIt<EventBus>().publish(
            EntityCreatedEvent<CheckoutStepResponse>(entity: model),
          );
        });
      },
      builder:
          (isVisible) => CheckoutErrorPage(
            title: 'Ödeme İşlemi Başarısız',
            message:
                model.message ??
                'Ödeme işlemi sırasında bir hata oluştu. Lütfen bilgilerinizi kontrol edip tekrar deneyiniz.',
            primaryButtonText: 'Sepete Dön',
            secondaryButtonText: 'Tekrar Dene',
            errorCode: null,
            onPrimaryButtonPressed: () async {
              _router.popAndPush(CartRoute());
            },
            onSecondaryButtonPressed: () async {
              _router.pop();
            },
          ),
    );
  }
}
