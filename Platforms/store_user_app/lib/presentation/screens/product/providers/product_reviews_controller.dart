import 'package:nb_utils/nb_utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:store_user_app/core/cache/cache_manager.dart';
import 'package:store_user_app/core/data/events/entity_created_event.dart';
import 'package:store_user_app/core/data/events/event_bus.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/domain/entities/models/catalog/add_product_review_model/add_product_review_model.dart';
import 'package:store_user_app/domain/entities/models/catalog/product_reviews_model/product_reviews_model.dart';
import 'package:store_user_app/domain/repositories/component/component_repository.dart';
import 'package:store_user_app/domain/repositories/product/product_repository.dart';
import 'package:store_user_app/presentation/screens/product/view_models/product_reviews_view_model.dart';

part 'product_reviews_controller.g.dart';

@riverpod
class ProductReviewsController extends _$ProductReviewsController {
  late ProductRepository _productRepository;
  late ComponentRepository _componentRepository;
  late CacheManager _cacheManager;

  @override
  FutureOr<ProductReviewsViewModel> build(
      ProductReviewsModel initialReviews) async {
    _productRepository = await getIt.getAsync<ProductRepository>();
    _cacheManager = await getIt.getAsync<CacheManager>();
    _componentRepository = await getIt.getAsync<ComponentRepository>();

    return ProductReviewsViewModel(
      reviewsModel: initialReviews,
      isLoading: false,
    );
  }

  // Get reviews for a product
  Future<void> getProductReviews(String productId) async {
    try {
      state = AsyncValue.data(state.requireValue.copyWith(isLoading: true));

      final response =
          await _componentRepository.postProductReviewsModel(productId);

      if (response != null) {
        state = AsyncValue.data(state.requireValue.copyWith(
          reviewsModel: response,
          isLoading: false,
        ));
      } else {
        state = AsyncValue.data(state.requireValue.copyWith(
          error: 'Failed to load reviews',
          isLoading: false,
        ));
      }
    } catch (e) {
      state = AsyncValue.data(state.requireValue.copyWith(
        error: 'Error loading reviews: ${e.toString()}',
        isLoading: false,
      ));
    }
  }

  // Submit a new review
  Future<bool> submitReview(AddProductReviewModel reviewModel) async {
    try {
      state = AsyncValue.data(
          state.requireValue.copyWith(isSubmitting: true, error: null));

      // Create a copy of the current reviews model with the new review form data
      final updatedModel = state.requireValue.reviewsModel
          ?.copyWith(addProductReview: reviewModel);

      if (updatedModel == null) {
        state = AsyncValue.data(state.requireValue.copyWith(
          error: 'Review data missing',
          isSubmitting: false,
        ));
        return false;
      }

      final response =
          await _productRepository.postProductProductReviews(updatedModel);

      if (response?.data != null &&
          response!.data!.addProductReview?.successfullyAdded == true) {
        // Clear cache to ensure fresh data on next load
        await _cacheManager.removeByPrefix(
            _productRepository.generateCachePrefixForRemoval('/Product'));

        await _cacheManager.removeByPrefix(_componentRepository
            .generateCachePrefixForRemoval('/Component/Index/ProductReviews'));

        getIt<EventBus>().publish<AddProductReviewModel>(
            EntityCreatedEvent<AddProductReviewModel>(
                entity: response.data!.addProductReview!));

        // Refresh the reviews list after successful submission
        await getProductReviews(updatedModel.productId ?? '');

        state =
            AsyncValue.data(state.requireValue.copyWith(isSubmitting: false));
        return true;
      } else {
        state = AsyncValue.data(state.requireValue.copyWith(
          error: response?.data?.addProductReview?.result ??
              'Failed to submit review',
          isSubmitting: false,
        ));
        return false;
      }
    } catch (e) {
      state = AsyncValue.data(state.requireValue.copyWith(
        error: 'Error submitting review: ${e.toString()}',
        isSubmitting: false,
      ));
      return false;
    }
  }

  // Update helpfulness of a review
  Future<bool> updateReviewHelpfulness(
      String productReviewId, String productId, bool isHelpful) async {
    try {
      state = AsyncValue.data(state.requireValue
          .copyWith(isUpdatingHelpfulness: true, error: null));

      final response =
          await _productRepository.postProductSetProductReviewHelpfulness(
              productReviewId, productId, isHelpful);

      if (response != null && response.data != null) {
        // Clear cache to ensure fresh data
        await _cacheManager.removeByPrefix(
            _productRepository.generateCachePrefixForRemoval('/Product'));
        await _cacheManager.removeByPrefix(_componentRepository
            .generateCachePrefixForRemoval('/Component/Index/ProductReviews'));

        // Update the review in the local state to reflect the change immediately
        if (state.requireValue.reviewsModel?.items != null) {
          final updatedItems = [...state.requireValue.reviewsModel!.items!];
          final reviewIndex =
              updatedItems.indexWhere((review) => review.id == productReviewId);

          if (reviewIndex >= 0) {
            final review = updatedItems[reviewIndex];
            final helpfulness = review.helpfulness;

            if (helpfulness != null) {
              // Create updated helpfulness model
              final updatedHelpfulness = helpfulness.copyWith(
                helpfulYesTotal: response.data!.totalYes,
                helpfulNoTotal: response.data!.totalNo,
              );

              // Create updated review with new helpfulness
              final updatedReview =
                  review.copyWith(helpfulness: updatedHelpfulness);

              // Replace in list
              updatedItems[reviewIndex] = updatedReview;

              // Update state with new list
              state = AsyncValue.data(state.requireValue.copyWith(
                reviewsModel: state.requireValue.reviewsModel!
                    .copyWith(items: updatedItems),
                isUpdatingHelpfulness: false,
              ));
            }
          }
        }
        toast(response.data!.result ?? '');
        return true;
      } else {
        state = AsyncValue.data(state.requireValue.copyWith(
          error: 'Failed to update review helpfulness',
          isUpdatingHelpfulness: false,
        ));
        return false;
      }
    } catch (e) {
      state = AsyncValue.data(state.requireValue.copyWith(
        error: 'Error updating review helpfulness: ${e.toString()}',
        isUpdatingHelpfulness: false,
      ));
      return false;
    }
  }
}
