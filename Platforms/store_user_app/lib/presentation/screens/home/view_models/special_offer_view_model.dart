import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/domain/entities/models/components/slider/public_info_model/public_info_model.dart';

part 'special_offer_view_model.freezed.dart';

@freezed
class SpecialOfferViewModel with _$SpecialOfferViewModel {
  const factory SpecialOfferViewModel({
    required PublicInfoModel publicInfoModel,
    String? loadingError,
    @Default(true) bool isLoading,
  }) = _SpecialOfferViewModel;
}
