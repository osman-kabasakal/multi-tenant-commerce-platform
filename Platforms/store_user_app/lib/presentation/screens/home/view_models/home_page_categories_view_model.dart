import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/domain/entities/models/catalog/category_model/category_model.dart';

part 'home_page_categories_view_model.freezed.dart';

@freezed
class HomePageCategoriesViewModel with _$HomePageCategoriesViewModel {
  const factory HomePageCategoriesViewModel({
    @Default(true) bool isLoading,
    @Default(<CategoryModel>[]) List<CategoryModel>? categories,
  }) = _HomePageCategoriesViewModel;
}
