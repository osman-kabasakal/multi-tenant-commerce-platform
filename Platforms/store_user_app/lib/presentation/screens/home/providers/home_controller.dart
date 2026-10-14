import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:store_user_app/core/data/events/entity_event.dart';
import 'package:store_user_app/core/services/auth/app_tokens_refresh_event.dart';
import 'package:store_user_app/core/state_management/riverpod/base_event_listener_provider.dart';
import 'package:store_user_app/domain/usecases/notification/notification_checker_service.dart';
import 'package:store_user_app/presentation/screens/home/view_models/home_view_model.dart';

part 'home_controller.g.dart';

@riverpod
class HomeController extends _$HomeController
    with BaseEventListenerProvider<HomeViewModel> {
  @override
  FutureOr<HomeViewModel> build() async {
    initListenar();
    return HomeViewModel();
  }

  @override
  void handleEvent(EntityEvent event) {
    if (event is AuthTokensRefreshEvent) {
      if (event.oldTokens?.email != event.entity.email ||
          event.oldTokens?.guestId != event.entity.guestId) {
        // ref.invalidateSelf();
      }
    }

    if (event is HasMessageEvent) {
      state = AsyncValue.data(
        state.requireValue.copyWith(hasMessages: event.entity),
      );
    }
  }
}
