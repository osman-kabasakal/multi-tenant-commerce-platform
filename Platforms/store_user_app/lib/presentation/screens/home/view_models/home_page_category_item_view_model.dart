import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_page_category_item_view_model.freezed.dart';

@freezed
class HomePageCategoryItemViewModel with _$HomePageCategoryItemViewModel {
  const factory HomePageCategoryItemViewModel({
    required String id,
    required String name,
    required String imageUrl,
  }) = _HomePageCategoryItemViewModel;
}
