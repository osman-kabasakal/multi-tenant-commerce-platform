import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:store_user_app/core/cache/cache_manager.dart';
import 'package:store_user_app/core/data/events/event_bus.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/auth/app_tokens_refresh_event.dart';
import 'package:store_user_app/core/services/background_task_queue/background_task_queue.dart';
import 'package:store_user_app/core/state_management/riverpod/cache_aware_provider.dart';
import 'package:store_user_app/domain/entities/models/catalog/product_overview_model/product_overview_model.dart';
import 'package:store_user_app/domain/repositories/component/component_repository.dart';

part 'component_providers.g.dart';

@riverpod
class CustomerRecomendedProducts extends _$CustomerRecomendedProducts
    with
        CacheInvalidationBase,
        CacheAwareAsyncProvider<List<ProductOverviewModel>> {
  @override
  FutureOr<List<ProductOverviewModel>> build() async {
    await registerCorrelation();

    var compoenentRepository = await getIt.getAsync<ComponentRepository>();
    var authStateChangedListener = getIt<EventBus>().stream.listen((event) {
      getIt<BackgroundTaskQueue>().enqueueTask((cancellationToken) async {
        if (event is AuthTokensRefreshEvent) {
          if (event.oldTokens?.email != event.entity.email &&
              event.oldTokens?.guestId != event.entity.guestId) {
            await getIt<CacheManager>().removeByPrefix(
              compoenentRepository.generateCachePrefixForRemoval(
                compoenentRepository
                    .postCustomerRecommendedProductsCacheKeyPrefix,
              ),
            );
          }
        }
      });
    });

    ref.onDispose(() {
      authStateChangedListener.cancel();
    });
    try {
      var products = await correlationService
          .runRepositoryMethodWithCorrelation(
            correlationId,
            () async =>
                await compoenentRepository.postCustomerRecommendedProducts(200),
          );

      return products ?? [];
    } catch (e) {
      return [];
    }
  }
}

// @riverpod
// FutureOr<List<ProductOverviewModel>> customerRecomendedProducts(Ref ref) async {
//   var compoenentRepository = await getIt.getAsync<ComponentRepository>();
//   var authStateChangedListener = getIt<EventBus>().stream.listen((event) {
//     getIt<BackgroundTaskQueue>().enqueueTask((cancellationToken) async {
//       if (event is AuthTokensRefreshEvent) {
//         if (event.oldTokens?.email != event.entity.email &&
//             event.oldTokens?.guestId != event.entity.guestId) {
//           await getIt<CacheManager>().removeByPrefix(compoenentRepository
//               .generateCachePrefixForRemoval(compoenentRepository
//                   .postCustomerRecommendedProductsCacheKeyPrefix));
//           ref.invalidateSelf();
//         }
//       }
//     });
//   });

//   ref.onDispose(() {
//     authStateChangedListener.cancel();
//   });
//   try {
//     var products =
//         await compoenentRepository.postCustomerRecommendedProducts(200);

//     return products ?? [];
//   } catch (e) {
//     return [];
//   }
// }

@riverpod
class SuggestedProducts extends _$SuggestedProducts
    with
        CacheInvalidationBase,
        CacheAwareAsyncProvider<List<ProductOverviewModel>> {
  @override
  FutureOr<List<ProductOverviewModel>> build() async {
    await registerCorrelation();

    var compoenentRepository = await getIt.getAsync<ComponentRepository>();
    var authStateChangedListener = getIt<EventBus>().stream.listen((event) {
      getIt<BackgroundTaskQueue>().enqueueTask((cancellationToken) async {
        if (event is AuthTokensRefreshEvent) {
          if (event.oldTokens?.email != event.entity.email &&
              event.oldTokens?.guestId != event.entity.guestId) {
            await getIt<CacheManager>().removeByPrefix(
              compoenentRepository.generateCachePrefixForRemoval(
                compoenentRepository.postSuggestedProductsCacheKeyPrefix,
              ),
            );
          }
        }
      });
    });

    ref.onDispose(() {
      authStateChangedListener.cancel();
    });

    try {
      var products = await correlationService
          .runRepositoryMethodWithCorrelation(
            correlationId,
            () async => await compoenentRepository.postSuggestedProducts(200),
          );
      return products ?? [];
    } catch (e) {
      return [];
    }
  }
}
