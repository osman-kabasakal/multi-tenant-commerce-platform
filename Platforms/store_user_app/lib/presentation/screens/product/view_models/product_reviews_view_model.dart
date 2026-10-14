import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/domain/entities/models/catalog/product_reviews_model/product_reviews_model.dart';

part 'product_reviews_view_model.freezed.dart';

@freezed
class ProductReviewsViewModel with _$ProductReviewsViewModel {
  const factory ProductReviewsViewModel({
    @Default(false) bool isLoading,
    @Default(false) bool isSubmitting,
    @Default(false) bool isUpdatingHelpfulness,
    @Default(null) String? error,
    @Default(null) ProductReviewsModel? reviewsModel,
  }) = _ProductReviewsViewModel;
}
