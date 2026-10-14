import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/constants/strings.dart' as app_text;
import 'package:store_user_app/core/data/events/entity_created_event.dart';
import 'package:store_user_app/core/data/events/event_bus.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/models/cache/cache_invalidate_type.dart';
import 'package:store_user_app/core/models/network/api_response.dart';
import 'package:store_user_app/core/navigation/app_paths.dart';
import 'package:store_user_app/core/navigation/app_router.dart';
import 'package:store_user_app/core/navigation/app_router.gr.dart';
import 'package:store_user_app/core/services/cache/cache_freshness_service.dart';
import 'package:store_user_app/core/services/dialog/dialog_helper.dart';
import 'package:store_user_app/core/state_management/riverpod/cache_aware_provider.dart';
import 'package:store_user_app/domain/entities/anonymous_type__fa6_c6_c9_f/anonymous_type__fa6_c6_c9_f.dart';
import 'package:store_user_app/domain/entities/models/catalog/customer_out_of_stock_subscriptions_model/out_of_stock_subscription_model/out_of_stock_subscription_model.dart';
import 'package:store_user_app/domain/entities/models/catalog/product_details_model/product_details_model.dart';
import 'package:store_user_app/domain/entities/models/catalog/product_model/product_model.dart';
import 'package:store_user_app/domain/entities/models/shopping_cart/product_details_cart/product_details_cart.dart';
import 'package:store_user_app/domain/entities/models/shopping_cart/shopping_cart_model/shopping_cart_item_model/shopping_cart_item_model.dart';
import 'package:store_user_app/domain/repositories/action_cart/action_cart_repository.dart';
import 'package:store_user_app/domain/repositories/component/component_repository.dart';
import 'package:store_user_app/domain/repositories/out_of_stock_subscription/out_of_stock_subscription_repository.dart';
import 'package:store_user_app/domain/repositories/product/product_repository.dart';

import '../view_models/product_detail_view_model.dart';

part 'product_controller.g.dart';

@riverpod
class ProductController extends _$ProductController
    with
        CacheInvalidationBase,
        CacheAwareAsyncFamilyProvider<ProductDetailViewModel> {
  late ProductRepository _productRepository;
  late ComponentRepository _componentRepository;
  late OutOfStockSubscriptionRepository _outOfStockSubscriptionRepository;
  late ActionCartRepository _actionCartRepository;
  @override
  FutureOr<ProductDetailViewModel> build(String productId) async {
    await registerCorrelation();
    _productRepository = await getIt.getAsync<ProductRepository>();
    _componentRepository = await getIt.getAsync<ComponentRepository>();
    _outOfStockSubscriptionRepository =
        await getIt.getAsync<OutOfStockSubscriptionRepository>();
    _actionCartRepository = await getIt.getAsync<ActionCartRepository>();

    try {
      var productDetail = await getProductDetails(productId);
      return ProductDetailViewModel(
        isLoading: false,
        productDetailsModel: productDetail,
        activeAttributes: productDetail.productAttributes ?? [],
        isFailure: false,
        outOfStockButtonText:
            (await correlationService.runRepositoryMethodWithCorrelation(
              correlationId,
              () async => await _outOfStockSubscriptionRepository
                  .getOutOfStockSubscriptionSubscribeButton(
                    productId,
                    productDetail.allowToSelectWarehouse! &&
                            productDetail.productWarehouses!.isNotEmpty
                        ? productDetail.productWarehouses!
                            .firstWhere(
                              (element) => element.selected!,
                              orElse:
                                  () => productDetail.productWarehouses!.first,
                            )
                            .warehouseId!
                        : '',
                  ),
            )) ??
            '',
      );
    } catch (e) {
      return ProductDetailViewModel(
        isLoading: false,
        errorMessage:
            "Beklenmedik bir hata nedeniyle işeminizi gerçekleştiremiyoruz lütfen tekrar deneyiniz!",
        outOfStockButtonText: '',
      );
    }
  }

  Future<ProductDetailsModel> getProductDetails(String productId) async {
    try {
      var detailResponse = await correlationService
          .runRepositoryMethodWithCorrelation(
            correlationId,
            () async =>
                await _productRepository.getProductProductDetails(productId),
          );

      if (detailResponse != null && detailResponse.data != null) {
        return detailResponse.data!;
      } else {
        await getIt<AppRouter>().replacePath(AppPaths.notFound());
        throw Exception("Failed to get product details");
      }
    } catch (e) {
      throw Exception("Failed to get product details");
    }
  }

  // Track the latest attribute change request ID
  String? _currentAttributeRequestId;

  Future<void> changeProductAttribute(ProductModel productModel) async {
    if (state.isLoading ||
        (!state.hasValue || state.requireValue.productDetailsModel == null)) {
      return;
    }
    
    // If already processing an attribute, don't start another request
    if (state.hasValue && state.requireValue.isProcessingAttribute) {
      return;
    }

    // Generate a unique request ID
    final requestId = DateTime.now().millisecondsSinceEpoch.toString();
    _currentAttributeRequestId = requestId;

    // Set isProcessingAttribute flag to true before processing
    state = AsyncValue.data(
      state.requireValue.copyWith(
        isProcessingAttribute: true,
      ),
    );
    
    try {
      var attributeChangeResponse = await _productRepository
          .postProductProductDetails_AttributeChange(productModel);
        
      // If this isn't the latest request, ignore the result
      if (_currentAttributeRequestId != requestId) {
        return;
      }

    if (attributeChangeResponse != null &&
        attributeChangeResponse.data != null) {
      var changeDetails = attributeChangeResponse.data!;
      var newProductDetailsState =
          state.requireValue.productDetailsModel!.copyWith();
      var newState = state.requireValue.copyWith();

      /* Price handle*/
      if (changeDetails.price != null) {
        if (!((newProductDetailsState.productPrice!.enteredPrice ?? false) &&
            (newProductDetailsState.productPrice?.callForPrice ?? false))) {
          if (newProductDetailsState.productPrice!.isAuction ?? false) {
            if ((newProductDetailsState.productPrice!.highestBidValue ?? 0) >
                0) {
              newProductDetailsState = newProductDetailsState.copyWith(
                productPrice: newProductDetailsState.productPrice?.copyWith(
                  highestBid: changeDetails.price,
                ),
              );
            } else {
              newProductDetailsState = newProductDetailsState.copyWith(
                productPrice: newProductDetailsState.productPrice?.copyWith(
                  startPrice: changeDetails.price,
                ),
              );
            }
          }

          if (!((newProductDetailsState.productPrice!.isAuction ?? false) &&
              (newProductDetailsState.productPrice!.disableBuyButton ??
                  false))) {
            if (newProductDetailsState
                .productPrice!
                .priceWithDiscount
                .isEmptyOrNull) {
              newProductDetailsState = newProductDetailsState.copyWith(
                productPrice: newProductDetailsState.productPrice?.copyWith(
                  price: changeDetails.price,
                ),
              );
            } else {
              newProductDetailsState = newProductDetailsState.copyWith(
                productPrice: newProductDetailsState.productPrice?.copyWith(
                  priceWithDiscount: changeDetails.price,
                ),
              );
            }
          }
        }
      }

      /* Price handle*/

      if (!changeDetails.sku.isEmptyOrNull) {
        newProductDetailsState = newProductDetailsState.copyWith(
          sku: changeDetails.sku,
        );
      }

      if (!changeDetails.mpn.isEmptyOrNull) {
        newProductDetailsState = newProductDetailsState.copyWith(
          mpn: changeDetails.mpn,
        );
      }

      if (!changeDetails.gtin.isEmptyOrNull) {
        newProductDetailsState = newProductDetailsState.copyWith(
          gtin: changeDetails.gtin,
        );
      }

      if (!changeDetails.stockAvailability.isEmptyOrNull) {
        newProductDetailsState = newProductDetailsState.copyWith(
          stockAvailability: changeDetails.stockAvailability,
        );
      }

      if (!(changeDetails.outOfStockSubscription ?? false)) {
        newProductDetailsState = newProductDetailsState.copyWith(
          displayOutOfStockSubscription: changeDetails.outOfStockSubscription,
        );
      }

      if (!(changeDetails.buttonTextOutOfStockSubscription.isEmptyOrNull)) {
        newState = newState.copyWith(
          outOfStockButtonText:
              changeDetails.buttonTextOutOfStockSubscription ?? '',
        );
      }

      if ((changeDetails.enabledattributemappingids?.isNotEmpty ?? false)) {
        newState = newState.copyWith(
          activeAttributes:
              state.requireValue.productDetailsModel!.productAttributes!
                  .where(
                    (attribute) => changeDetails.enabledattributemappingids!
                        .any((ea) => attribute.id == ea),
                  )
                  .toList(),
        );
      }

      if ((changeDetails.disabledattributemappingids?.isNotEmpty ?? false)) {
        newState = newState.copyWith(
          activeAttributes:
              state.requireValue.productDetailsModel!.productAttributes!
                  .where(
                    (attribute) =>
                        !changeDetails.enabledattributemappingids!.any(
                          (ea) => attribute.id == ea,
                        ),
                  )
                  .toList(),
        );
      }

      state = AsyncValue.data(
        newState.copyWith(
          productDetailsModel: newProductDetailsState,
          isProcessingAttribute: false,
        ),
      );
    } else {
      // Only update state if this is still the current request
      if (_currentAttributeRequestId == requestId) {
        state = AsyncValue.data(
          state.requireValue.copyWith(
            isLoading: false,
            isFailure: true,
            isProcessingAttribute: false,
            errorMessage:
                "Özellik değişiminde bilinmeyen bir hata aldık lütfen daha sonra tekrar deneyiniz!",
          ),
        );
      }
    }
    } catch (e) {
      // Only update error state if this is still the current request
      if (_currentAttributeRequestId == requestId) {
        state = AsyncValue.data(
          state.requireValue.copyWith(
            isLoading: false,
            isFailure: true,
            isProcessingAttribute: false,
            errorMessage: "Özellik değişimi sırasında bir bağlantı hatası oluştu.",
          ),
        );
      }
    }
  }

  // Future<void> _cacheFreshness() {
  //   return Future.delayed(
  //     Duration(milliseconds: 300),
  //     () async =>
  //         await (await getIt.getAsync<CacheFreshnessService>())
  //             .checkCacheFreshness(),
  //   );
  // }

  Future<void> subscribeToBackInStock(ProductModel model) async {
    if (state.isLoading || !state.hasValue) return;
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      var subscribeResponse = await _outOfStockSubscriptionRepository
          .postOutOfStockSubscriptionSubscribePopup(model);

      if (subscribeResponse != null && subscribeResponse.data != null) {
        getIt<EventBus>().publish(
          EntityCreatedEvent<OutOfStockSubscriptionModel>(
            entity: OutOfStockSubscriptionModel(productId: model.productId),
          ),
        );

        cacheFreshness(
          _outOfStockSubscriptionRepository.generateCachePrefixForRemoval(
            '/OutOfStockSubscription/SubscribeButton',
          ),
          CacheInvalidateType.prefix,
          false,
        );
        toast(
          subscribeResponse.data!.resource ?? '',
          bgColor: colorPrimaryContainer,
          textColor: Colors.white,
        );
        return state.requireValue.copyWith(
          outOfStockButtonText: subscribeResponse.data!.buttontext ?? '',
        );
      } else {
        return state.requireValue.copyWith(outOfStockButtonText: '');
      }
    });
  }

  Future<void> loadRelatedProducts() async {
    if (state.isLoading || !state.hasValue) return;
    state = await AsyncValue.guard(() async {
      var relatedProductsResponse = await correlationService
          .runRepositoryMethodWithCorrelation(
            correlationId,
            () async => await _productRepository.getProductRelatedProducts(
              productId,
              150,
            ),
          );

      if (relatedProductsResponse != null &&
          relatedProductsResponse.data != null) {
        return state.requireValue.copyWith(
          relatedProducts: relatedProductsResponse.data,
        );
      } else {
        return state.requireValue.copyWith(relatedProducts: []);
      }
    });
  }

  Future<void> loadAlsoPurchasedProducts() async {
    if (state.isLoading || !state.hasValue) return;
    state = await AsyncValue.guard(() async {
      var alsoPurchasedProductsResponse = await correlationService
          .runRepositoryMethodWithCorrelation(
            correlationId,
            () async => await _componentRepository.postProductsAlsoPurchased(
              productId,
              150,
            ),
          );

      return state.requireValue.copyWith(
        alsoPurchasedProducts: alsoPurchasedProductsResponse ?? [],
      );
    });
  }

  Future<void> loadSimilarProducts() async {
    if (!state.hasValue) return;
    state = await AsyncValue.guard(() async {
      var similarProductsResponse = await correlationService
          .runRepositoryMethodWithCorrelation(
            correlationId,
            () async =>
                await _componentRepository.postSimilarProducts(productId, 150),
          );

      return state.requireValue.copyWith(
        similarProducts: similarProductsResponse ?? [],
      );
    });
  }

  Future<void> loadRecentlyViewedProducts() async {
    if (state.isLoading || !state.hasValue) return;
    state = await AsyncValue.guard(() async {
      var recentlyViewedProductsResponse = await correlationService
          .runRepositoryMethodWithCorrelation(
            correlationId,
            () async =>
                await _productRepository.getProductRecentlyViewedProducts(),
          );

      return state.requireValue.copyWith(
        recentlyViewedProducts: recentlyViewedProductsResponse?.data ?? [],
      );
    });
  }

  Future<void> addToCart(ProductDetailsCart detailsCartToProductModel) async {
    if (state.isLoading || !state.hasValue) return;
    state = AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      ApiResponse<AnonymousType_FA6C6C9F>? addToCartResponse =
          await correlationService.runRepositoryMethodWithCorrelation(
            correlationId,
            () async =>
                await _actionCartRepository.postActionCartAddProductDetails(
                  detailsCartToProductModel.copyWith(
                    enteredQuantity:
                        detailsCartToProductModel.enteredQuantity ?? 1,
                  ),
                ),
          );

      if (addToCartResponse != null && addToCartResponse.data != null) {
        if (addToCartResponse.data!.success!) {
          if (addToCartResponse.data!.message != null) {
            DialogHelper.showAlertDialog(
              title: 'Ürününüz başarıyla sepete eklendi!',
              confirmText: 'Sepete Git',
              cancelText: 'Geri Dön',
              message: 'Sepetinizi görüntülemek ister misiniz?',
              type: AppDialogType.content,
            ).then((v) {
              if (v == true) {
                getIt.get<AppRouter>().push(CartRoute());
              }
            });

            getIt.get<EventBus>().publish(
              EntityCreatedEvent<ShoppingCartItemModel>(
                entity: ShoppingCartItemModel(),
              ),
            );

            cacheFreshness();

            // var productDetail = await getProductDetails(productId);
            return state.requireValue.copyWith(
              isLoading: true,
              // productDetailsModel: productDetail,
              // activeAttributes: productDetail.productAttributes ?? [],
              // isFailure: false,
              // outOfStockButtonText:
              //     (await correlationService.runRepositoryMethodWithCorrelation(
              //       correlationId,
              //       () async => await _outOfStockSubscriptionRepository
              //           .getOutOfStockSubscriptionSubscribeButton(
              //             productId,
              //             productDetail.allowToSelectWarehouse! &&
              //                     productDetail.productWarehouses!.isNotEmpty
              //                 ? productDetail.productWarehouses!
              //                     .firstWhere(
              //                       (element) => element.selected!,
              //                       orElse:
              //                           () =>
              //                               productDetail
              //                                   .productWarehouses!
              //                                   .first,
              //                     )
              //                     .warehouseId!
              //                 : '',
              //           ),
              //     )) ??
              //     '',
            );
          } else {
            toast('Ürününüzü sepete eklerken beklenmedik bir hata oluştu.');
          }
        } else {
          if (addToCartResponse.data!.message != null) {
            if (addToCartResponse.data!.message is List) {
              toast(addToCartResponse.data!.message!.join("\n"));
            } else if (addToCartResponse.data!.message is String) {
              toast(addToCartResponse.data!.message);
            } else {
              toast('Ürününüzü sepete eklerken beklenmedik bir hata oluştu.');
            }
          } else {
            toast('Ürününüzü sepete eklerken beklenmedik bir hata oluştu.');
          }
        }
      }

      return state.requireValue.copyWith(
        isLoading: false,
        isFailure: true,
        errorMessage: 'Ürününüzü sepete eklerken beklenmedik bir hata oluştu.',
      );
    });
  }
}
