import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/state_management/riverpod/cache_aware_provider.dart';
import 'package:store_user_app/domain/entities/models/catalog/product_overview_model/product_overview_model.dart';
import 'package:store_user_app/domain/repositories/component/component_repository.dart';

part 'home_page_products_controller.g.dart';

@riverpod
class HomePageProducts extends _$HomePageProducts
    with
        CacheInvalidationBase,
        CacheAwareAsyncProvider<List<ProductOverviewModel>> {
  @override
  FutureOr<List<ProductOverviewModel>> build() async {
    await registerCorrelation();
    var compoenentRepository = await getIt.getAsync<ComponentRepository>();
    try {
      var products =
          await correlationService.runRepositoryMethodWithCorrelation(
              correlationId,
              () async => await compoenentRepository.postHomePageProducts(200));
      return products ?? [];
    } catch (e) {
      return [];
    }
  }
}
