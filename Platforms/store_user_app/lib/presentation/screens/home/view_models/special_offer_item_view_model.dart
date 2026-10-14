import 'package:freezed_annotation/freezed_annotation.dart';

part 'special_offer_item_view_model.freezed.dart';

@freezed
class SpecialOfferItemViewModel with _$SpecialOfferItemViewModel {
  const factory SpecialOfferItemViewModel({
    required String title,
    required String description,
    required String imageUrl,
  }) = _SpecialOfferItemViewModel;
}
