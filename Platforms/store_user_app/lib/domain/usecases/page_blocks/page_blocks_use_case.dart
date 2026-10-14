import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/models/background_tasks/cancellation_token.dart';
import 'package:store_user_app/core/services/correlation/correlation_service.dart';
import 'package:store_user_app/core/state_management/riverpod/cache_aware_provider.dart';

import '../../entities/models/pages/page_model/page_model.dart';
import '../../repositories/component/component_repository.dart';

part 'page_blocks_use_case.g.dart';

@riverpod
class GetHomePageText extends _$GetHomePageText
    with CacheInvalidationBase, CacheAwareAsyncProvider<PageModel?> {
  @override
  FutureOr<PageModel?> build() async {
    await registerCorrelation();
    return correlationService.runRepositoryMethodWithCorrelation(
        correlationId,
        () async => await (await getIt.getAsync<ComponentRepository>())
            .postPageBlockComponent('HomePageText'));
  }
}
