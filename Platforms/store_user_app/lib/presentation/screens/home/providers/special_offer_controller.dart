import 'package:store_user_app/core/config/local_demo.dart';
import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/state_management/riverpod/cache_aware_provider.dart';
import 'package:store_user_app/domain/entities/models/components/slider/public_info_model/public_info_model.dart';
import 'package:store_user_app/domain/repositories/component/component_repository.dart';
import 'package:store_user_app/presentation/screens/home/view_models/special_offer_view_model.dart';

part 'special_offer_controller.g.dart';

@riverpod
class SpecialOfferController extends _$SpecialOfferController
    with CacheInvalidationBase, CacheAwareAsyncProvider<SpecialOfferViewModel> {
  @override
  FutureOr<SpecialOfferViewModel> build() async {
    await registerCorrelation();
    return await _build();
  }

  Future<SpecialOfferViewModel> _build() async {
    // The optional slider plugin is not loaded in the local demo.
    if (LocalDemo.enabled) {
      return SpecialOfferViewModel(
        publicInfoModel: PublicInfoModel(),
        isLoading: false,
      );
    }
    var componentRepository = await getIt.getAsync<ComponentRepository>();
    try {
      var publicInfoModel = await correlationService
          .runRepositoryMethodWithCorrelation(
            correlationId,
            () async => await componentRepository.postHomePageSlideComponent(
              'home_page_top',
            ),
          );
      if (publicInfoModel == null) {
        return SpecialOfferViewModel(
          publicInfoModel: PublicInfoModel(),
          loadingError: 'No data found',
        );
      }
      return SpecialOfferViewModel(
        publicInfoModel: publicInfoModel,
        isLoading: false,
      );
    } catch (e) {
      return SpecialOfferViewModel(
        publicInfoModel: PublicInfoModel(),
        isLoading: false,
        loadingError:
            'Beklenmeyen bir hata oluştur lütfen sayfayı yenileyiniz!',
      );
    }
  }

  Future<void> loadState() async {
    state = await AsyncValue.guard(_build);
  }
}
