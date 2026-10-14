import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:store_user_app/core/cache/cache_manager.dart';
import 'package:store_user_app/core/data/events/entity_event.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/auth/app_tokens_refresh_event.dart';
import 'package:store_user_app/core/state_management/riverpod/base_event_listener_provider.dart';
import 'package:store_user_app/core/state_management/riverpod/cache_aware_provider.dart';
import 'package:store_user_app/domain/entities/models/customer/courses_model/courses_model.dart';
import 'package:store_user_app/domain/repositories/account/account_repository.dart';

part 'customer_courses_controller.g.dart';

@riverpod
class CustomerCoursesController extends _$CustomerCoursesController
    with
        BaseEventListenerProvider<CoursesModel>,
        CacheInvalidationBase,
        CacheAwareAsyncProvider<CoursesModel> {
  late AccountRepository _accountRepository;

  @override
  FutureOr<CoursesModel> build() async {
    await registerCorrelation();
    _accountRepository = await getIt.getAsync<AccountRepository>();
    initListenar();
    return await _fetchCourses();
  }

  Future<CoursesModel> _fetchCourses() async {
    try {
      final response =
          await correlationService.runRepositoryMethodWithCorrelation(
        correlationId,
        () async => await _accountRepository.getAccountCourses(),
      );
      if (response != null && response.data != null) {
        return response.data!;
      }
      throw Exception('Kurslar yüklenemedi');
    } catch (e) {
      throw Exception('Kurslar yüklenirken bir hata oluştu: $e');
    }
  }

  Future<void> refreshCourses() async {
    state = const AsyncValue.loading();
    try {
      state = AsyncValue.data(await _fetchCourses());
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  @override
  void handleEvent(EntityEvent event) async {
    if (event is AuthTokensRefreshEvent) {
      if (event.oldTokens != null &&
          (event.oldTokens?.email != event.entity.email ||
              event.oldTokens?.guestId != event.entity.guestId)) {
        await cacheFreshness();
        try {
          state = AsyncValue.data(await _fetchCourses());
        } catch (e, stackTrace) {
          state = AsyncValue.error(e, stackTrace);
        }
      }
    }
  }
}
