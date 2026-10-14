import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:store_user_app/core/cache/cache_manager.dart';
import 'package:store_user_app/core/data/events/entity_created_event.dart';
import 'package:store_user_app/core/data/events/entity_event.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/state_management/riverpod/base_event_listener_provider.dart';
import 'package:store_user_app/core/state_management/riverpod/cache_aware_provider.dart';
import 'package:store_user_app/core/utils/extensions/api_response_extensions.dart';
import 'package:store_user_app/domain/entities/models/catalog/add_product_review_model/add_product_review_model.dart';
import 'package:store_user_app/domain/entities/models/customer/customer_product_reviews_model/customer_product_reviews_model.dart';
import 'package:store_user_app/domain/repositories/account/account_repository.dart';

part 'customer_reviews_controller.g.dart';

@riverpod
class CustomerReviewsController extends _$CustomerReviewsController
    with
        BaseEventListenerProvider<CustomerProductReviewsModel>,
        CacheInvalidationBase,
        CacheAwareAsyncProvider<CustomerProductReviewsModel> {
  late AccountRepository _accountRepository;
  late CacheManager _cacheManager;

  @override
  FutureOr<CustomerProductReviewsModel> build() async {
    await registerCorrelation();
    _accountRepository = await getIt.getAsync<AccountRepository>();
    _cacheManager = await getIt.getAsync<CacheManager>();

    initListenar();
    return getReviews();
  }

  Future<CustomerProductReviewsModel> getReviews() async {
    var result = await correlationService.runRepositoryMethodWithCorrelation(
      correlationId,
      () async => await _accountRepository.getAccountReviews(),
    );
    if (result.success) {
      return result!.data!;
    }

    throw Exception(
        'Yorumlarınızı çekerken bir hata oluştu! Lütfen tekrar deneyiniz!');
  }

  Future<void> refresh() async {
    state = AsyncValue.loading();
    await getReviews().then((value) => state = AsyncValue.data(value));
  }

  @override
  void handleEvent(EntityEvent event) async {
    if (event is EntityCreatedEvent<AddProductReviewModel>) {
      if (event.entity.successfullyAdded!) {
        await cacheFreshness();
        state = await AsyncValue.guard(() async => await getReviews());
      }
    }
  }
}
