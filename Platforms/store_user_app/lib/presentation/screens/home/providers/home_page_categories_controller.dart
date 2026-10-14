import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/state_management/riverpod/cache_aware_provider.dart';
import 'package:store_user_app/domain/repositories/component/component_repository.dart';

import '../view_models/home_page_categories_view_model.dart';

part 'home_page_categories_controller.g.dart';

@riverpod
class HomePageCategoriesController extends _$HomePageCategoriesController with CacheInvalidationBase, CacheAwareAsyncProvider<HomePageCategoriesViewModel>  {
  @override
  FutureOr<HomePageCategoriesViewModel> build() async {
    await registerCorrelation();
    return HomePageCategoriesViewModel();
  }

  Future<HomePageCategoriesViewModel> _build() async {
    var componentRespository = await getIt.getAsync<ComponentRepository>();
    try {
      var categories =
          await correlationService.runRepositoryMethodWithCorrelation(correlationId, () async =>await componentRespository.getHomePageCategoriesComponent());
      return HomePageCategoriesViewModel(
          categories: categories, isLoading: false);
    } catch (e) {
      return HomePageCategoriesViewModel(categories: [], isLoading: false);
    }
  }

  Future<void> loadState() async {
    state = await AsyncValue.guard(_build);
  }
}
