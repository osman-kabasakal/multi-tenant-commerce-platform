import 'package:injectable/injectable.dart';
import 'package:store_user_app/core/data/events/entity_created_event.dart';
import 'package:store_user_app/core/data/events/entity_event_handler.dart';
import 'package:store_user_app/core/data/events/entity_event_listener.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/background_task_queue/background_task_queue.dart';
import 'package:store_user_app/presentation/screens/checkout/view_models/checkout_step_response.dart';

@singleton
class CheckoutStepResponseEventHandler
    extends EntityEventHandler<CheckoutStepResponse> {
  CheckoutStepResponseEventHandler(super.eventBus);

  @override
  Future<void> onEntityCreated(
      EntityCreatedEvent<CheckoutStepResponse> event) async {
    if (!getIt.isRegistered<
        EntityEventListener<EntityCreatedEvent<CheckoutStepResponse>>>()) {
      return;
    }
    var listeners = getIt.getAll<
        EntityEventListener<EntityCreatedEvent<CheckoutStepResponse>>>();
    for (var listener in listeners) {
      getIt<BackgroundTaskQueue>().enqueueTask((cancellationToken) async {
        await listener.onEntityEvent(event, cancellationToken);
      });
    }
  }

  @disposeMethod
  @override
  void dispose() {
    super.dispose();
  }
}
