import 'package:nb_utils/nb_utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:store_user_app/core/cache/cache_manager.dart';
import 'package:store_user_app/core/data/events/entity_event.dart';
import 'package:store_user_app/core/data/events/entity_updated_event.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/navigation/app_router.dart';
import 'package:store_user_app/core/navigation/app_router.gr.dart';
import 'package:store_user_app/core/services/auth/app_tokens_refresh_event.dart';
import 'package:store_user_app/core/services/auth/auth_service.dart';
import 'package:store_user_app/core/services/background_task_queue/background_task_queue.dart';
import 'package:store_user_app/core/state_management/riverpod/base_event_listener_provider.dart';
import 'package:store_user_app/core/state_management/riverpod/cache_aware_provider.dart';
import 'package:store_user_app/domain/entities/models/customer/customer_info_model/customer_info_model.dart';
import 'package:store_user_app/domain/entities/models/customer/customer_navigation_model/account_navigation_enum/account_navigation_enum.dart';
import 'package:store_user_app/domain/entities/models/customer/customer_navigation_model/customer_navigation_model.dart';
import 'package:store_user_app/domain/entities/models/customer/delete_account_model/delete_account_model.dart';
import 'package:store_user_app/domain/repositories/account/account_repository.dart';
import 'package:store_user_app/domain/repositories/component/component_repository.dart';

import '../view_models/profile_view_model.dart';

part 'profile_controller.g.dart';

@riverpod
class ProfileController extends _$ProfileController
    with
        BaseEventListenerProvider<ProfileViewModel>,
        CacheInvalidationBase,
        CacheAwareAsyncProvider<ProfileViewModel> {
  late ComponentRepository _componentRepository;
  late AccountRepository _accountRepository;
  late AuthService _authService;
  late AppRouter _appRouter;

  @override
  FutureOr<ProfileViewModel> build() async {
    await registerCorrelation();
    _componentRepository = await getIt.getAsync<ComponentRepository>();
    _accountRepository = await getIt.getAsync<AccountRepository>();
    _authService = await getIt.getAsync<AuthService>();
    _appRouter = getIt.get<AppRouter>();
    initListenar();
    return await _getCustomerNavigation();
  }

  Future<ProfileViewModel> _getCustomerNavigation() async {
    try {
      if ((await _authService.isGuest())) {
        return ProfileViewModel(
          error: 'Misafir kullanıcılar için bu sayfa mevcut değil.',
          customerNavigation: CustomerNavigationModel(),
          customerInfo: CustomerInfoModel(),
        );
      }
      var response = await correlationService
          .runRepositoryMethodWithCorrelation(
        correlationId,
            () async => await _componentRepository.postCustomerNavigation(
          AccountNavigationEnum.info,
        ),
      );
      var accountInfo = await correlationService
          .runRepositoryMethodWithCorrelation(
        correlationId,
            () async => await _accountRepository.getAccountInfo(),
      );

      if (response != null && accountInfo != null && accountInfo.data != null) {
        return ProfileViewModel(
          customerNavigation: response,
          customerInfo: accountInfo.data!,
        );
      }
      if (!(await _authService.isGuest())) {
        getIt<BackgroundTaskQueue>().enqueueTask((cancellationToken) async {
          state = await AsyncValue.guard(_getCustomerNavigation);
        });
      }
      return ProfileViewModel(
        error: 'İsteğinizi şuan gerçekleştiremiyoruz.',
        customerNavigation: CustomerNavigationModel(),
        customerInfo: CustomerInfoModel(),
      );
    } catch (e) {
      return ProfileViewModel(
        error: 'Beklenmeyen bir hata oluştu lütfen daha sonra tekrar deneyin.',
        customerNavigation: CustomerNavigationModel(),
        customerInfo: CustomerInfoModel(),
      );
    }
  }

  Future<void> deleteAccount(String password) async {
    try {
      state = AsyncValue.loading();
      var deleteResponse = await _accountRepository.postAccountDeleteAccount(
        DeleteAccountModel(password: password),
      );
      if (deleteResponse != null && deleteResponse.isRedirectResponse) {
        await _authService.logout();
        await _appRouter.pushAndPopUntil(
          SigninRoute(returnUrl: '/home'),
          predicate: (route) => route.settings.name == HomeRoute.name,
        );
        return;
      }
      state = AsyncValue.data(
        state.requireValue,
      );
      toast("Hesabınızı silerken teknik bir hata yaşadık. Lütfen daha sonra tekrar deneyin.");
    } catch (e) {
      state = AsyncValue.data(state.requireValue);
      toast("Hesabınızı silerken teknik bir hata yaşadık. Lütfen daha sonra tekrar deneyin.");
    }
  }

  @override
  void handleEvent(EntityEvent event) {
    if (event is AuthTokensRefreshEvent) {
      if (event.oldTokens?.email != event.entity.email ||
          event.oldTokens?.guestId != event.entity.guestId) {
        getIt<BackgroundTaskQueue>().enqueueTask((cancellationToken) async {
          await (await getIt.getAsync<CacheManager>()).removeByPrefix(
            _componentRepository.generateCachePrefixForRemoval(
              _componentRepository.postCustomerNavigationCacheKeyPrefix,
              event.oldTokens?.email ?? event.oldTokens?.guestId,
            ),
          );
          state = await AsyncValue.guard(_getCustomerNavigation);
        });
      }
    }

    if (event is EntityUpdatedEvent<CustomerInfoModel>) {
      getIt<BackgroundTaskQueue>().enqueueTask((cancellationToken) async {
        state = AsyncValue.data(
          state.requireValue.copyWith(customerInfo: event.entity),
        );
      });
    }
  }
}
