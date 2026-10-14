import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/domain/entities/models/catalog/product_details_model/product_attribute_model/product_attribute_model.dart';
import 'package:store_user_app/domain/entities/models/catalog/product_details_model/product_details_model.dart';
import 'package:store_user_app/domain/entities/models/catalog/product_overview_model/product_overview_model.dart';

part 'product_detail_view_model.freezed.dart';

@freezed
class ProductDetailViewModel with _$ProductDetailViewModel {
  const factory ProductDetailViewModel({
    ProductDetailsModel? productDetailsModel,
    @Default([]) List<ProductAttributeModel> activeAttributes,
    List<ProductOverviewModel>? relatedProducts,
    List<ProductOverviewModel>? alsoPurchasedProducts,
    List<ProductOverviewModel>? similarProducts,
    List<ProductOverviewModel>? recentlyViewedProducts,
    required String outOfStockButtonText,
    @Default(true) bool isLoading,
    @Default(false) bool isFailure,
    @Default(false) bool isProcessingAttribute,
    String? errorMessage,
  }) = _ProductDetailViewModel;
}
