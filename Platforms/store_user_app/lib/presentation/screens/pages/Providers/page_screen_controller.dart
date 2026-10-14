

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/state_management/riverpod/cache_aware_provider.dart';
import 'package:store_user_app/domain/repositories/component/component_repository.dart';
import 'package:store_user_app/domain/repositories/page/page_repository.dart';

import '../view_model/page_screen_view_model.dart';

part 'page_screen_controller.g.dart';

@riverpod
class PageScreenController extends _$PageScreenController  
with
        CacheInvalidationBase,
        CacheAwareAsyncProvider<PageScreenViewModel> {
  late ComponentRepository _componentRepository;
  late PageRepository _pageRepository;
  @override
  FutureOr<PageScreenViewModel> build() async {
    _componentRepository = await getIt.getAsync<ComponentRepository>();
    _pageRepository = await getIt.getAsync<PageRepository>();

     await registerCorrelation();
    return PageScreenViewModel(isLoading: true);
  }

  Future<void> loadPage(String systemName) async {
    if(state.isLoading || !state.hasValue) return;
    state = AsyncValue.data( state.requireValue.copyWith(isLoading: true));
    try {
      var pageResponse = await correlationService.runRepositoryMethodWithCorrelation(correlationId, ()=>_pageRepository.getPagePageDetailsPopup(systemName));
      if (pageResponse != null &&  pageResponse.data!=null) {
        final page=pageResponse.data!;
        state = AsyncValue.data(PageScreenViewModel(
          pageId: page.id,
          pageTitle: page.title,
          pageContent: page.body,
          lastUpdated: page.startDate,
          isLoading: false,
        ));
      } else {
        state = AsyncValue.data(PageScreenViewModel(isLoading: false));
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}