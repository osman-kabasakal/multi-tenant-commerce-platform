import 'dart:async';
import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/config/theme/skeleton_styles.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/constants/images.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/navigation/app_paths.dart';
import 'package:store_user_app/core/navigation/app_router.gr.dart';
import 'package:store_user_app/core/services/form/app_form_controller.dart';
import 'package:store_user_app/core/services/form/form_field.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/core/utils/extensions/double_extensions.dart';
import 'package:store_user_app/domain/entities/models/catalog/product_details_model/product_attribute_model/product_attribute_model.dart';
import 'package:store_user_app/domain/entities/models/catalog/product_details_model/product_details_model.dart';
import 'package:store_user_app/domain/entities/models/catalog/product_model/product_model.dart';
import 'package:store_user_app/domain/entities/models/custom_attribute_model/custom_attribute_model.dart';
import 'package:store_user_app/domain/entities/models/shopping_cart/product_details_cart/product_details_cart.dart';
import 'package:store_user_app/domain/repositories/component/component_repository.dart';
import 'package:store_user_app/presentation/form_builders/product_details_cart_form_builder.dart';
import 'package:store_user_app/presentation/screens/product/providers/product_controller.dart';
import 'package:store_user_app/core/config/theme/theme.dart';
import 'package:store_user_app/presentation/screens/product/view/product_review_screen.dart';
import 'package:store_user_app/presentation/screens/product/widgets/add_to_cart_bottom_bar.dart';
import 'package:store_user_app/presentation/screens/product/widgets/availability_widget.dart';
import 'package:store_user_app/presentation/screens/product/widgets/collections_widget.dart';
import 'package:store_user_app/presentation/screens/product/widgets/delivery_info_widget.dart';
import 'package:store_user_app/presentation/screens/product/widgets/product_app_bar_widget.dart';
import 'package:store_user_app/presentation/screens/product/widgets/product_bundles_widget.dart';
import 'package:store_user_app/presentation/screens/product/widgets/product_expandable_section.dart';
import 'package:store_user_app/presentation/screens/product/widgets/product_gallery_widget.dart';
import 'package:store_user_app/presentation/screens/product/widgets/product_overview.dart';
import 'package:store_user_app/presentation/screens/product/widgets/quantity_selector_widget.dart';
import 'package:store_user_app/presentation/screens/product/widgets/unavailable_widget.dart';
import 'package:store_user_app/presentation/screens/product/widgets/warehouses_widget.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/consumer_futer_builder_widget.dart';
import 'package:store_user_app/presentation/widgets/buttons/view/app_async_waiter_button.dart';
import 'package:store_user_app/presentation/widgets/form/widgets/generic_form.dart';
import 'package:store_user_app/presentation/widgets/layout/view/load_component_when_visible.dart';
import 'package:store_user_app/presentation/widgets/products/widgets/app_section_product_collection_widget.dart';
import 'package:store_user_app/presentation/widgets/skeletons/widgets/product_collection_widget_sceleton.dart';
import 'package:store_user_app/presentation/widgets/skeletons/widgets/widgets.dart';

import '../widgets/download_sample_widget.dart';
import '../widgets/tier_prices_widget.dart';

@RoutePage()
class ProductScreen extends StatefulHookConsumerWidget {
  final String productId;
  const ProductScreen({
    super.key,
    @PathParam('productId') required this.productId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductScreenState();
}

class _ProductScreenState extends ConsumerState<ProductScreen> {
  late ThemeData theme;

  late final ValueNotifier<
    Completer<({bool isValid, ProductDetailsCart model})>?
  >
  _submitNotifier =
      ValueNotifier<Completer<({bool isValid, ProductDetailsCart model})>?>(
        null,
      );
  late final ValueNotifier<Map<String, String>?> _formErrors =
      ValueNotifier<Map<String, String>?>(null);

  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(true);

  // Debounce timer for attribute changes
  Timer? _attributeDebounceTimer;
  
  @override
  void initState() {
    theme =
        getIt<ThemeController>().isDarkMode
            ? AppTheme.foodDarkTheme
            : AppTheme.foodLightTheme;

    _addToCartProductDetailFormModel.addListener(() {
      // Cancel any previous debounce timer
      _attributeDebounceTimer?.cancel();
      
      // Check if another attribute change is in progress
      final productState = ref.read(productControllerProvider(widget.productId));
      if (productState.hasValue && productState.requireValue.isProcessingAttribute) {
        return; // Skip attribute change if already processing
      }
      
      // Debounce attribute changes (300ms)
      _attributeDebounceTimer = Timer(const Duration(milliseconds: 300), () {
        if (!mounted) return;
        
        // Recheck processing state before proceeding
        final currentState = ref.read(productControllerProvider(widget.productId));
        if (currentState.hasValue && currentState.requireValue.isProcessingAttribute) {
          return; // Skip attribute change if processing started during debounce
        }
        
        var productModel = _detailsCartToProductModel(
          _addToCartProductDetailFormModel.value,
        );
        ref
            .read(productControllerProvider(widget.productId).notifier)
            .changeProductAttribute(productModel);
      });
    });

    super.initState();
  }

  ProductModel _detailsCartToProductModel(ProductDetailsCart model) {
    return ProductModel(
      productId: widget.productId,
      warehouseId: model.warehouseId,
      reservationDatepickerFrom: model.reservationDatepickerFrom,
      reservationDatepickerTo: model.reservationDatepickerTo,
      loadPicture: true,
      attributes: model.attributes,
    );
  }

  ColorFilter rightIconColorFilter = ColorFilter.mode(
    getIt<ThemeController>().isDarkMode ? Colors.white : Colors.black,
    BlendMode.srcIn,
  );

  late final ValueNotifier<ProductDetailsCart>
  _addToCartProductDetailFormModel = ValueNotifier(ProductDetailsCart());

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _attributeDebounceTimer?.cancel();
    _addToCartProductDetailFormModel.dispose();
    _submitNotifier.dispose();
    _formErrors.dispose();
    _isLoading.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(productControllerProvider(widget.productId), (oldState, state) {
      _isLoading.value = state.isLoading;
    });
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: ProductAppBar(
        onCartTap: () => context.router.navigate(CartRoute()),
      ),
      bottomNavigationBar: ConsumerFuterBuilderWidget(
        futureBuilder:
            (bottomNavigationAppBarRef) => bottomNavigationAppBarRef.watch(
              productControllerProvider(
                widget.productId,
              ).selectAsync((s) => s.productDetailsModel),
            ),
        builder: (
          buttomNavigationContext,
          bottomNavigationAppBarRef,
          snapshot,
        ) {
          return AddToCartBottomBar(
            product: snapshot.data!,
            onOutOfStockSubscription: () async {
              _submitNotifier.value = Completer();
              var formSubmitResponse = await _submitNotifier.value!.future;
              if (formSubmitResponse.isValid) {
                await (bottomNavigationAppBarRef
                    .read(productControllerProvider(widget.productId).notifier)
                    .subscribeToBackInStock(
                      _detailsCartToProductModel(formSubmitResponse.model),
                    ));
              }
            },
            onAddToCart: () async {
              _submitNotifier.value = Completer();
              var formSubmitResponse = await _submitNotifier.value!.future;
              if (formSubmitResponse.isValid) {
                await (bottomNavigationAppBarRef
                    .read(productControllerProvider(widget.productId).notifier)
                    .addToCart(formSubmitResponse.model));
              }
            },
            onBuyNow: () async {
              _submitNotifier.value = Completer();
              var formSubmitResponse = await _submitNotifier.value!.future;
              if (formSubmitResponse.isValid) {
                await (bottomNavigationAppBarRef
                    .read(productControllerProvider(widget.productId).notifier)
                    .addToCart(formSubmitResponse.model));
              }
            },
          );
        },
        loadingBuilder: (context, snapShotRef, snapshot) {
          return const SizedBox(height: 80);
        },
        errorBuilder: (context, snapShotRef, snapshot) {
          return const SizedBox(height: 80);
        },
      ),
      floatingActionButton: ConsumerFuterBuilderWidget(
        futureBuilder:
            (bottomNavigationAppBarRef) => bottomNavigationAppBarRef.watch(
              productControllerProvider(
                widget.productId,
              ).selectAsync((s) => s.productDetailsModel),
            ),
        builder: (
          buttomNavigationContext,
          bottomNavigationAppBarRef,
          snapshot,
        ) {
          return LoadComponentWhenVisible(
            onVisible: () async {
              if (_addToCartProductDetailFormModel.value.enteredQuantity ==
                  null) {
                _addToCartProductDetailFormModel
                    .value = _addToCartProductDetailFormModel.value.copyWith(
                  enteredQuantity:
                      int.tryParse(
                        (snapshot.data!)
                                .addToCart!
                                .allowedQuantities!
                                .firstOrNull
                                ?.value ??
                            '',
                      ) ??
                      1,
                );
              }
            },
            builder: (context) {
              return ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth:
                      MediaQuery.of(buttomNavigationContext).size.width * 0.4,
                  maxHeight:
                      MediaQuery.of(buttomNavigationContext).size.width * 0.4,
                ),
                child: ValueListenableBuilder(
                  valueListenable: _addToCartProductDetailFormModel,
                  builder: (context, state, child) {
                    return QuantitySelectorWidget(
                      model: snapshot.data!.addToCart!.copyWith(
                        enteredQuantity:
                            state.enteredQuantity ??
                            int.tryParse(
                              (snapshot.data!)
                                      .addToCart!
                                      .allowedQuantities!
                                      .firstOrNull
                                      ?.value ??
                                  '',
                            ) ??
                            1,
                      ),
                      onChanged: (value) {
                        _addToCartProductDetailFormModel
                            .value = _addToCartProductDetailFormModel.value
                            .copyWith(enteredQuantity: value);
                      },
                      onIncrease: () {
                        _addToCartProductDetailFormModel.value =
                            _addToCartProductDetailFormModel.value.copyWith(
                              enteredQuantity:
                                  (_addToCartProductDetailFormModel
                                          .value
                                          .enteredQuantity ??
                                      1) +
                                  1,
                            );
                      },
                      onDecrease: () {
                        if ((_addToCartProductDetailFormModel
                                    .value
                                    .enteredQuantity ??
                                1) >
                            1) {
                          _addToCartProductDetailFormModel.value =
                              _addToCartProductDetailFormModel.value.copyWith(
                                enteredQuantity:
                                    (_addToCartProductDetailFormModel
                                            .value
                                            .enteredQuantity ??
                                        1) -
                                    1,
                              );
                        }
                      },
                    );
                  },
                ),
              );
            },
          );
        },
        loadingBuilder: (context, snapShotRef, snapshot) {
          return const SizedBox(height: 80);
        },
        errorBuilder: (context, snapShotRef, snapshot) {
          return const SizedBox(height: 80);
        },
      ),
      body: _buildProductDetail(context),
    );
  }

  Widget _buildProductDetail(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // Product overview (title, price, rating)
                ConsumerFuterBuilderWidget(
                  futureBuilder:
                      (ref) => ref.watch(
                        productControllerProvider(
                          widget.productId,
                        ).selectAsync((s) => s.productDetailsModel),
                      ),
                  builder: (
                    productOverviewFtContext,
                    productOverviewFtRef,
                    snapshot,
                  ) {
                    return ProductOverview(product: snapshot.data!);
                  },
                  loadingBuilder: (context, snapShotRef, snapshot) {
                    return const SizedBox.shrink();
                  },
                  errorBuilder: (context, snapShotRef, snapshot) {
                    return const SizedBox.shrink();
                  },
                ),

                const SizedBox(height: 20),

                //Reviews
                ConsumerFuterBuilderWidget(
                  futureBuilder: (ref) {
                    return ref.watch(
                      productControllerProvider(
                        widget.productId,
                      ).selectAsync((s) => s.productDetailsModel),
                    );
                  },
                  builder: (context, ref, snapshot) {
                    if (snapshot.data == null ||
                        snapshot.data!.productReviewOverview == null ||
                        ((snapshot.data!.productReviewOverview!.avgRating ??
                                    0) ==
                                0 &&
                            !(snapshot
                                .data!
                                .productReviewOverview!
                                .allowCustomerReviews!))) {
                      return const SizedBox.shrink();
                    }
                    return Column(
                      children: [
                        AppAsyncWaiterButton(
                          onPressed: () async {
                            var model = await (await getIt
                                    .getAsync<ComponentRepository>())
                                .postProductReviewsModel(widget.productId);
                            context.router.pushWidget(
                              ProductReviewScreen(
                                model: model!,
                                productReviewOverviewModel:
                                    snapshot.data!.productReviewOverview,
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  starIcon,
                                  width: 20,
                                  height: 20,
                                ),
                                10.width,
                                Text(
                                  snapshot
                                          .data!
                                          .productReviewOverview
                                          ?.avgRating
                                          ?.toStringAsFixed(1) ??
                                      '',
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                10.width,
                                Expanded(
                                  child: Text(
                                    '(${snapshot.data!.productReviewOverview!.totalReviews} değerlendirme)',
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      color: colorGrey700,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                SvgPicture.asset(
                                  rightArrowIcon,
                                  height: 15,
                                  width: 15,
                                  colorFilter: rightIconColorFilter,
                                ),
                              ],
                            ),
                          ),
                        ),
                        _buildDivider(),
                      ],
                    );
                  },
                ),
                // SliverToBoxAdapter(
                //   child:
                // ),

                // Product images carousel
                ConsumerFuterBuilderWidget(
                  futureBuilder: (ref) {
                    return ref.watch(
                      productControllerProvider(
                        widget.productId,
                      ).selectAsync((s) => s.productDetailsModel),
                    );
                  },
                  builder: (gallertFtContext, galleryFtRef, snapshot) {
                    return Stack(
                      fit: StackFit.loose,
                      children: [
                        ProductGallery(model: snapshot.data!),
                        if (!snapshot.data!.flag.isEmptyOrNull)
                          Positioned(
                            top: 0,
                            left: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: dodgerBlue,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                snapshot.data!.flag!,
                                style: context.textTheme.bodySmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                  loadingBuilder:
                      (context, snapShotRef, snapshot) => AspectRatio(
                        aspectRatio: 1,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SkeletonAvatar(
                            style: SkeletonAvatarStyle(
                              width: double.infinity,
                              height: double.infinity,
                              borderRadius: BorderRadius.all(Radius.zero),
                            ),
                          ),
                        ),
                      ),
                  errorBuilder:
                      (context, snapShotRef, snapshot) =>
                          Center(child: Text('Error loading product')),
                ),

                const SizedBox(height: 12),
              ],
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: ConsumerFuterBuilderWidget(
            futureBuilder:
                (descriptionTabsRef) => descriptionTabsRef.watch(
                  productControllerProvider(
                    widget.productId,
                  ).selectAsync((s) => s.productDetailsModel),
                ),
            builder: (tabsContext, tabsRef, tabsSnapshot) {
              return ConsumerFuterBuilderWidget(
                futureBuilder:
                    (outOfStockButtonTextRef) => outOfStockButtonTextRef.watch(
                      productControllerProvider(
                        widget.productId,
                      ).selectAsync((s) => s.outOfStockButtonText),
                    ),
                builder: (
                  outOfStockButtonTextContext,
                  outOfStockButtonTextRef,
                  outOfStockButtonTextSnapshot,
                ) {
                  return AvailabilityWidget(
                    model: AvailabilityModel(
                      stockAvailability: tabsSnapshot.data!.stockAvailability!,
                      displayOutOfStockSubscription:
                          tabsSnapshot.data!.displayOutOfStockSubscription!,
                      isAvAilablePurchase:
                          !(tabsSnapshot
                                  .data!
                                  .productPrice
                                  ?.disableBuyButton! ??
                              false),
                      buttonTextOutOfStockSubscription:
                          outOfStockButtonTextSnapshot.data ?? '...',
                    ),
                    onSubscribeToBackInStock: () async {
                      _submitNotifier.value = Completer();
                      var formSubmitResponse =
                          await _submitNotifier.value!.future;
                      if (formSubmitResponse.isValid) {
                        await tabsRef
                            .read(
                              productControllerProvider(
                                widget.productId,
                              ).notifier,
                            )
                            .subscribeToBackInStock(
                              _detailsCartToProductModel(
                                formSubmitResponse.model,
                              ),
                            );
                      }
                    },
                  ).paddingSymmetric(horizontal: 15);
                },
              );
            },
            loadingBuilder:
                (context, snapShotRef, snapshot) => const SizedBox.shrink(),
            errorBuilder:
                (context, snapShotRef, snapshot) => const SizedBox.shrink(),
          ),
        ),

        //tierPrices
        SliverToBoxAdapter(
          child: ConsumerFuterBuilderWidget(
            futureBuilder:
                (descriptionTabsRef) => descriptionTabsRef.watch(
                  productControllerProvider(
                    widget.productId,
                  ).selectAsync((s) => s.productDetailsModel),
                ),
            builder: (tabsContext, tabsRef, tabsSnapshot) {
              if (tabsSnapshot.data!.tierPrices!.isEmpty) {
                return const SizedBox.shrink();
              }
              return TierPricesWidget(
                tierPrices: tabsSnapshot.data!.tierPrices!,
              ).paddingSymmetric(horizontal: 15);
            },
            loadingBuilder:
                (context, snapShotRef, snapshot) => const SizedBox.shrink(),
            errorBuilder:
                (context, snapShotRef, snapshot) => const SizedBox.shrink(),
          ),
        ),

        //ShortDescription
        SliverToBoxAdapter(
          child: ConsumerFuterBuilderWidget(
            futureBuilder: (ref) {
              return ref.watch(
                productControllerProvider(
                  widget.productId,
                ).selectAsync((s) => s.productDetailsModel),
              );
            },
            builder: (context, ref, snapshot) {
              if (snapshot.data == null ||
                  snapshot.data!.shortDescription.isEmptyOrNull) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Html(data: snapshot.data!.shortDescription ?? ''),
              );
            },
            loadingBuilder: (context, snapShotRef, snapshot) {
              return const SizedBox.shrink();
            },
            errorBuilder: (context, snapShotRef, snapshot) {
              return const SizedBox.shrink();
            },
          ),
        ),

        //unavailable
        SliverToBoxAdapter(
          child: ConsumerFuterBuilderWidget(
            futureBuilder: (ref) {
              return ref.watch(
                productControllerProvider(
                  widget.productId,
                ).selectAsync((s) => s.productDetailsModel),
              );
            },
            builder: (context, ref, snapshot) {
              if (snapshot.data == null ||
                  !(snapshot.data!.displayDiscontinuedMessage ?? false)) {
                return const SizedBox.shrink();
              }
              return UnavailableWidget(
                displayDiscontinuedMessage:
                    snapshot.data!.displayDiscontinuedMessage!,
              ).paddingSymmetric(horizontal: 15);
            },
            loadingBuilder: (context, snapShotRef, snapshot) {
              return const SizedBox.shrink();
            },
            errorBuilder: (context, snapShotRef, snapshot) {
              return const SizedBox.shrink();
            },
          ),
        ),

        // Tab content based on selected tab
        SliverToBoxAdapter(child: _buildAboutItemView(context)),

        // Similar products
        SliverToBoxAdapter(
          child: Consumer(
            builder: (context, ref, child) {
              return LoadComponentWhenVisible(
                key: const ValueKey('similarProducts'),
                visibilityFraction: 0.01,
                onVisible: () async {
                  // await _waitState();
                  await ref
                      .read(
                        productControllerProvider(widget.productId).notifier,
                      )
                      .loadSimilarProducts();
                },
                builder: (isVisible) {
                  return child!;
                },
              );
            },
            child: ConsumerFuterBuilderWidget(
              futureBuilder:
                  (ref) => ref.watch(
                    productControllerProvider(
                      widget.productId,
                    ).selectAsync((s) => s.similarProducts),
                  ),
              builder: (similarProductContext, similarProductsRef, snapshot) {
                if (snapshot.data == null) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    similarProductsRef
                        .read(
                          productControllerProvider(widget.productId).notifier,
                        )
                        .loadSimilarProducts();
                  }
                  return ProductCollectionWidgetSceleton();
                }
                if (snapshot.data!.isEmpty) {
                  return const SizedBox.shrink();
                }
                return AppSectionProductCollectionWidget(
                  products: snapshot.data ?? [],
                  title: 'Benzer Ürünler',
                ).paddingSymmetric(vertical: 15);
              },
            ),
          ),
        ),
        //alsoPurchasedProducts
        SliverToBoxAdapter(
          child: Consumer(
            builder: (context, ref, child) {
              return LoadComponentWhenVisible(
                key: const ValueKey('alsoPurchasedProducts'),
                visibilityFraction: -15,
                onVisible: () async {
                  // await _waitState();
                  await ref
                      .read(
                        productControllerProvider(widget.productId).notifier,
                      )
                      .loadAlsoPurchasedProducts();
                },
                builder: (isVisible) {
                  return child!;
                },
              );
            },
            child: ConsumerFuterBuilderWidget(
              futureBuilder:
                  (ref) => ref.watch(
                    productControllerProvider(
                      widget.productId,
                    ).selectAsync((s) => s.alsoPurchasedProducts),
                  ),
              builder: (similarProductContext, similarProductsRef, snapshot) {
                if (snapshot.data == null) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    similarProductsRef
                        .read(
                          productControllerProvider(widget.productId).notifier,
                        )
                        .loadAlsoPurchasedProducts();
                  }
                  return ProductCollectionWidgetSceleton();
                }
                if (snapshot.data!.isEmpty) {
                  return const SizedBox.shrink();
                }
                return AppSectionProductCollectionWidget(
                  products: snapshot.data ?? [],
                  title: 'Birlikte Tercih Edilen Ürünler',
                ).paddingSymmetric(vertical: 15);
              },
            ),
          ),
        ),
        //relatedProducts
        SliverToBoxAdapter(
          child: Consumer(
            builder: (context, ref, child) {
              return LoadComponentWhenVisible(
                key: const ValueKey('relatedProducts'),
                visibilityFraction: -15,
                onVisible: () async {
                  // await _waitState();
                  await ref
                      .read(
                        productControllerProvider(widget.productId).notifier,
                      )
                      .loadRelatedProducts();
                },
                builder: (isVisible) {
                  return child!;
                },
              );
            },
            child: ConsumerFuterBuilderWidget(
              futureBuilder:
                  (ref) => ref.watch(
                    productControllerProvider(
                      widget.productId,
                    ).selectAsync((s) => s.relatedProducts),
                  ),
              builder: (similarProductContext, similarProductsRef, snapshot) {
                if (snapshot.data == null) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    similarProductsRef
                        .read(
                          productControllerProvider(widget.productId).notifier,
                        )
                        .loadRelatedProducts();
                  }
                  return ProductCollectionWidgetSceleton();
                }
                if (snapshot.data!.isEmpty) {
                  return const SizedBox.shrink();
                }
                return AppSectionProductCollectionWidget(
                  products: snapshot.data ?? [],
                  title: 'İlişkili Ürünler',
                ).paddingSymmetric(vertical: 15);
              },
            ),
          ),
        ),

        //recentlyViewedProducts
        SliverToBoxAdapter(
          child: Consumer(
            builder: (context, ref, child) {
              return LoadComponentWhenVisible(
                key: const ValueKey('recentlyViewedProducts'),
                visibilityFraction: -15,
                onVisible: () async {
                  // await _waitState();
                  await ref
                      .read(
                        productControllerProvider(widget.productId).notifier,
                      )
                      .loadRecentlyViewedProducts();
                },
                builder: (isVisible) {
                  return child!;
                },
              );
            },
            child: ConsumerFuterBuilderWidget(
              futureBuilder:
                  (ref) => ref.watch(
                    productControllerProvider(
                      widget.productId,
                    ).selectAsync((s) => s.recentlyViewedProducts),
                  ),
              builder: (similarProductContext, similarProductsRef, snapshot) {
                if (snapshot.data == null) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    similarProductsRef
                        .read(
                          productControllerProvider(widget.productId).notifier,
                        )
                        .loadRecentlyViewedProducts();
                  }
                  return ProductCollectionWidgetSceleton();
                }
                if (snapshot.data!.isEmpty) {
                  return const SizedBox.shrink();
                }
                return AppSectionProductCollectionWidget(
                  products: snapshot.data ?? [],
                  title: 'Son Görüntülenen Ürünler',
                ).paddingSymmetric(vertical: 15);
              },
            ),
          ),
        ),
      ],
    );
  }

  // Future<void> _waitState() async {
  //   if (!context.mounted) return;
  //   if (_isLoading.value) {
  //     var loadingCompleter = Completer();
  //     listener() {
  //       if (!_isLoading.value && !loadingCompleter.isCompleted) {
  //         loadingCompleter.complete();
  //       }
  //     }

  //     _isLoading.addListener(listener);

  //     await loadingCompleter.future;
  //   }
  // }

  Widget _buildAboutItemView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConsumerFuterBuilderWidget(
            futureBuilder: (ref) {
              return ref.watch(
                productControllerProvider(
                  widget.productId,
                ).selectAsync((s) => s.productDetailsModel),
              );
            },
            builder: (context, ref, snapshot) {
              if (snapshot.data == null ||
                  (snapshot.data!.fullDescription.isEmptyOrNull)) {
                return const SizedBox.shrink();
              }
              return ProductExpandableSection(
                title: 'Ürün Açıklaması',
                children: [Html(data: snapshot.data!.fullDescription!)],
              ).paddingBottom(10);
            },
            loadingBuilder: (context, snapShotRef, snapshot) {
              return const SizedBox.shrink();
            },
            errorBuilder: (context, snapShotRef, snapshot) {
              return const SizedBox.shrink();
            },
          ),
          ConsumerFuterBuilderWidget(
            futureBuilder: (ref) {
              return ref.watch(
                productControllerProvider(
                  widget.productId,
                ).selectAsync((s) => s.productDetailsModel),
              );
            },
            builder: (context, ref, snapshot) {
              if (snapshot.data == null ||
                  (snapshot.data!.productCollections!.isEmpty)) {
                return const SizedBox.shrink();
              }
              return ProductExpandableSection(
                title: 'Koleksiyonlar',
                children: [
                  CollectionsWidget(
                    collections: snapshot.data!.productCollections!,
                    onCollectionTap: (collection) {
                      context.router.navigatePath(
                        AppPaths.collection(collectionId: collection),
                      );
                    },
                  ),
                ],
              ).paddingBottom(10);
            },
            loadingBuilder: (context, snapShotRef, snapshot) {
              return const SizedBox.shrink();
            },
            errorBuilder: (context, snapShotRef, snapshot) {
              return const SizedBox.shrink();
            },
          ),
          ConsumerFuterBuilderWidget(
            futureBuilder: (ref) {
              return ref.watch(
                productControllerProvider(
                  widget.productId,
                ).selectAsync((s) => s.productDetailsModel),
              );
            },
            builder: (context, ref, snapshot) {
              if (snapshot.data == null ||
                  !(snapshot.data!.hasSampleDownload ?? false)) {
                return const SizedBox.shrink();
              }
              return ProductExpandableSection(
                title: 'Örnek İndir',
                children: [
                  DownloadSampleWidget(
                    hasSampleDownload: snapshot.data!.hasSampleDownload!,
                    productId: snapshot.data!.id!,
                    onDownloadSample: (productId) {
                      // context.router.navigate(ProductSampleDownloadRoute(productId: productId));
                    },
                  ),
                ],
              ).paddingBottom(20);
            },
            loadingBuilder: (context, snapShotRef, snapshot) {
              return const SizedBox.shrink();
            },
            errorBuilder: (context, snapShotRef, snapshot) {
              return const SizedBox.shrink();
            },
          ),
          ConsumerFuterBuilderWidget(
            futureBuilder: (ref) {
              return ref.watch(
                productControllerProvider(
                  widget.productId,
                ).selectAsync((s) => s.productDetailsModel),
              );
            },
            builder: (context, ref, snapshot) {
              if (snapshot.data == null ||
                  (snapshot.data!.productBundleModels!.isEmpty)) {
                return const SizedBox.shrink();
              }
              return ProductExpandableSection(
                title: 'Paket içeriği',
                children: [
                  ProductBundlesWidget(
                    bundles:
                        snapshot.data!.productBundleModels!
                            .map(
                              (b) => BundleItemModel(
                                productId: b.productId ?? '',
                                name: b.name ?? '',
                                seName: b.seName ?? '',
                                shortDescription: b.shortDescription ?? '',
                                quantity: (b.quantity ?? 0).toDouble(),
                                price: b.price ?? '',
                                defaultPictureModel: b.defaultPictureModel!,
                                productAttributes: b.productAttributes!,
                              ),
                            )
                            .toList(),
                    onProductTap: (productId) {
                      // context.router.navigate(ProductSampleDownloadRoute(productId: productId));
                    },
                    onAttributeChanged: (productId, attributeId, value) {
                      // context.router.navigate(ProductSampleDownloadRoute(productId: productId));
                    },
                  ),
                ],
              ).paddingBottom(20);
            },
            loadingBuilder: (context, snapShotRef, snapshot) {
              return const SizedBox.shrink();
            },
            errorBuilder: (context, snapShotRef, snapshot) {
              return const SizedBox.shrink();
            },
          ),
          ConsumerFuterBuilderWidget(
            futureBuilder: (ref) {
              return Future.wait([
                ref.watch(
                  productControllerProvider(
                    widget.productId,
                  ).selectAsync((s) => s.activeAttributes),
                ),
                ref.watch(
                  productControllerProvider(
                    widget.productId,
                  ).selectAsync((s) => s.productDetailsModel),
                ),
              ]);
            },
            builder: (context, ref, snapshot) {
              if (snapshot.data == null || (snapshot.data!.isEmpty)) {
                return const SizedBox.shrink();
              }
              return HookBuilder(
                builder: (context) {
                  var formBuilder = useMemoized(
                    () => ProductDetailsCartFormBuilder(
                      ProductDetailsCartFormModel(
                        product: (snapshot.data![1] as ProductDetailsModel)
                            .copyWith(
                              addToCart: (snapshot.data![1]
                                      as ProductDetailsModel)
                                  .addToCart!
                                  .copyWith(
                                    enteredQuantity:
                                        int.tryParse(
                                          (snapshot.data![1]
                                                      as ProductDetailsModel)
                                                  .addToCart!
                                                  .allowedQuantities!
                                                  .firstOrNull
                                                  ?.value ??
                                              '1',
                                        ) ??
                                        1,
                                  ),
                              productAttributes:
                                  (snapshot.data![0]
                                      as List<ProductAttributeModel>),
                            ),
                      ),
                    ),
                  );
                  late AppFormController formController;
                  formController = useMemoized(
                    () => AppFormController(
                      formBuilder
                          .build()
                          .where((f) => f.name != 'EnteredQuantity')
                          .toList(),
                      onFieldChange: (fieldName, value) {
                        // Always check if attribute processing is in progress before allowing changes
                        final productState = ref.read(productControllerProvider(widget.productId));
                        if (productState.hasValue && 
                            productState.requireValue.isProcessingAttribute) {
                          return; // Skip any field change if already processing attributes
                        }
                        
                        if (fieldName.startsWith('attribute_') &&
                            fieldName.split('_').length > 1) {
                          var attributeId = fieldName.split('_')[1].trim();
                          _addToCartProductDetailFormModel.value =
                              _addToCartProductDetailFormModel.value.copyWith(
                                attributes: [
                                  ..._addToCartProductDetailFormModel
                                      .value
                                      .attributes!
                                      .where((a) => a.key != attributeId),
                                  CustomAttributeModel(
                                    key: attributeId,
                                    value:
                                        value is List
                                            ? value
                                                .map((v) => v.toString())
                                                .join(',')
                                            : value is DateTime
                                            ? value.toIso8601String()
                                            : value.toString(),
                                  ),
                                ],
                              );
                        } else {
                          var jsonAddToCartModel =
                              _addToCartProductDetailFormModel.value.toJson();
                          var definedFormField = formController.fields
                              .firstWhere((f) => f.name == fieldName);
                          if (definedFormField.type == FormFieldType.price) {
                            jsonAddToCartModel[fieldName] =
                                double.parse(
                                  value.toString(),
                                ).toCurrencyString();
                          } else {
                            jsonAddToCartModel[fieldName] =
                                value is DateTime
                                    ? value.toIso8601String()
                                    : value.toString();
                          }

                          _addToCartProductDetailFormModel
                              .value = ProductDetailsCart.fromJson({
                            ..._addToCartProductDetailFormModel.value.toJson(),
                            ...jsonDecode(jsonEncode(jsonAddToCartModel)),
                          });
                        }
                      },
                    ),
                  );

                  useEffect(() {
                    // _addToCartProductDetailFormModel
                    //     .value = ProductDetailsCart.fromJson(
                    //   jsonDecode(
                    //     jsonEncode({
                    //       ..._addToCartProductDetailFormModel.value.toJson(),
                    //       ...jsonDecode(jsonEncode(formController.getValues())),
                    //     }),
                    //   ),
                    // );

                    _submitNotifier.addListener(() {
                      if (_submitNotifier.value != null &&
                          !_submitNotifier.value!.isCompleted) {
                        var submitResult = formController.submit();
                        if (!submitResult) {
                          _formErrors.value = formController.getErrors();
                        }

                        var formValues = formController.getValues();
                        var responseModel = ProductDetailsCart.fromJson(
                          formValues,
                        );
                        responseModel = responseModel.copyWith(
                          attributes:
                              formValues.keys
                                  .where(
                                    (element) =>
                                        element.startsWith('attribute_') &&
                                        formValues[element] != null,
                                  )
                                  .map(
                                    (e) => CustomAttributeModel(
                                      key: e.split('_')[1],
                                      value:
                                          formValues[e] is List
                                              ? (formValues[e] as List)
                                                  .map((v) => v.toString())
                                                  .join(',')
                                              : formValues[e].toString(),
                                    ),
                                  )
                                  .toList(),
                        );
                        _submitNotifier.value!.complete((
                          isValid: submitResult,
                          model: ProductDetailsCart.fromJson(
                            jsonDecode(
                              jsonEncode({
                                ..._addToCartProductDetailFormModel.value
                                    .toJson(),
                                ...jsonDecode(
                                  jsonEncode(responseModel.toJson()),
                                ),
                              }),
                            ),
                          ),
                        ));
                      }
                    });

                    // _addToCartProductDetailFormModel.addListener(() {
                    //   if (_addToCartProductDetailFormModel
                    //           .value.enteredQuantity !=
                    //       null) {
                    //     var quantityField =
                    //         formController.getFieldState('EnteredQuantity');
                    //     if (quantityField?.value !=
                    //         _addToCartProductDetailFormModel
                    //             .value.enteredQuantity!) {
                    //       formController.updateField(
                    //           'EnteredQuantity',
                    //           _addToCartProductDetailFormModel
                    //               .value.enteredQuantity!);
                    //     }
                    //   }
                    // });
                    return () {};
                  });
                  return RepaintBoundary(
                    child: Consumer(
                      builder: (context, ref, child) {
                        final isProcessingAttribute = ref.watch(
                          productControllerProvider(widget.productId).select(
                            (state) => state.hasValue ? state.requireValue.isProcessingAttribute : false,
                          ),
                        );
                        
                        return Stack(
                          children: [
                            Opacity(
                              opacity: isProcessingAttribute ? 0.5 : 1.0,
                              child: AbsorbPointer(
                                absorbing: isProcessingAttribute,
                                child: GenericForm(
                                  formBuilder: formBuilder,
                                  formController: formController,
                                ),
                              ),
                            ),
                            if (isProcessingAttribute)
                              Positioned.fill(
                                child: Container(
                                  color: Colors.black12,
                                  child: Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const CircularProgressIndicator(),
                                        const SizedBox(height: 16),
                                        Text(
                                          'Ürün özellikleri güncelleniyor...',
                                          style: Theme.of(context).textTheme.bodyMedium,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ).paddingBottom(20);
                },
              );

              // ProductExpandableSection(title: 'Ürün Özellikleri', children: [
              //   ProductAttributesWidget(
              //     attributes: snapshot.data!.productAttributes!,
              //     productId: snapshot.data!.id!,
              //     onAttributeChanged: (productId, attributeId, value) {
              //       // context.router.navigate(ProductSampleDownloadRoute(productId: productId));
              //     },
              //   ),
              // ]).paddingBottom(20);
            },
            loadingBuilder: (context, snapShotRef, snapshot) {
              return const SizedBox.shrink();
            },
            errorBuilder: (context, snapShotRef, snapshot) {
              return const SizedBox.shrink();
            },
          ),
          ConsumerFuterBuilderWidget(
            futureBuilder: (ref) {
              return ref.watch(
                productControllerProvider(
                  widget.productId,
                ).selectAsync((s) => s.productDetailsModel),
              );
            },
            builder: (context, ref, snapshot) {
              if (snapshot.data == null ||
                  !(snapshot.data!.allowToSelectWarehouse!)) {
                return const SizedBox.shrink();
              }
              return ProductExpandableSection(
                title: 'Depo Seçimi',
                children: [
                  WarehousesWidget(
                    warehouses:
                        snapshot.data!.productWarehouses!
                            .map(
                              (w) => WarehouseModel(
                                warehouseId: w.warehouseId!,
                                name: w.name ?? '',
                                selected: w.selected!,
                              ),
                            )
                            .toList(),
                    onWarehouseChanged: (wareHouseId) {
                      // Depo seçildiğinde model güncellenir
                      _addToCartProductDetailFormModel
                          .value = _addToCartProductDetailFormModel.value
                          .copyWith(warehouseId: wareHouseId);
                    },
                  ),
                ],
              ).paddingBottom(20);
            },
            loadingBuilder: (context, snapShotRef, snapshot) {
              return const SizedBox.shrink();
            },
            errorBuilder: (context, snapShotRef, snapshot) {
              return const SizedBox.shrink();
            },
          ),

          //TODO: merged all required form fields
          // ConsumerFuterBuilderWidget(
          //   futureBuilder: (ref) {
          //     return ref.watch(productControllerProvider(widget.productId)
          //         .selectAsync((s) => s.productDetailsModel));
          //   },
          //   builder: (context, ref, snapshot) {
          //     if (snapshot.data == null ||
          //         !(snapshot.data!.giftVoucher?.isGiftVoucher! ?? false)) {
          //       return const SizedBox.shrink();
          //     }
          //     return ProductExpandableSection(
          //         title: 'Hediye Çeki Bilgileri',
          //         children: [
          //           GiftVoucherInfoWidget(
          //             productId: snapshot.data!.id!,
          //             model: snapshot.data!.giftVoucher!,
          //             onGiftVoucherInfoChanged: (p0) {},
          //           )
          //         ]).paddingBottom(20);
          //   },
          //   loadingBuilder: (context, snapShotRef, snapshot) {
          //     return const SizedBox.shrink();
          //   },
          //   errorBuilder: (context, snapShotRef, snapshot) {
          //     return const SizedBox.shrink();
          //   },
          // ),

          //TODO: not sported reservation products
          // ConsumerFuterBuilderWidget(
          //   futureBuilder: (ref) {
          //     return ref.watch(productControllerProvider(widget.productId)
          //         .selectAsync((s) => s.productDetailsModel));
          //   },
          //   builder: (context, ref, snapshot) {
          //     if (snapshot.data == null ||
          //         (snapshot.data!.productType != ProductType.reservation)) {
          //       return const SizedBox.shrink();
          //     }
          //     return ProductExpandableSection(
          //         title: 'Reservasyon Bilgileri',
          //         children: [
          //           ReservationInfoWidget(
          //             productId: snapshot.data!.id!,
          //             model: ReservationModel(
          //                 intervalUnit: snapshot.data!.intervalUnit!,
          //                 startDate: snapshot.data!.startDate!,
          //                 parameters: Map.fromEntries(
          //                   snapshot.data!.parameters!.map(
          //                       (p) => MapEntry(p.value ?? '', p.text ?? '')),
          //                 )),
          //             onReservationInfoChanged: (p0) {},
          //           )
          //         ]).paddingBottom(20);
          //   },
          //   loadingBuilder: (context, snapShotRef, snapshot) {
          //     return const SizedBox.shrink();
          //   },
          //   errorBuilder: (context, snapShotRef, snapshot) {
          //     return const SizedBox.shrink();
          //   },
          // ),
          // ConsumerFuterBuilderWidget(
          //   futureBuilder: (ref) {
          //     return ref.watch(productControllerProvider(widget.productId)
          //         .selectAsync((s) => s.productDetailsModel));
          //   },
          //   builder: (context, ref, snapshot) {
          //     if (snapshot.data == null ||
          //         (snapshot.data!.productType != ProductType.auction)) {
          //       return const SizedBox.shrink();
          //     }
          //     return ProductExpandableSection(
          //         title: 'Müzayede Bilgileri',
          //         children: [
          //           AuctionInfoWidget(
          //             model: AuctionInfoModel(
          //                 productId: snapshot.data!.id!,
          //                 endTime: snapshot.data!.endTime!,
          //                 endTimeLocalTime: snapshot.data!.endTimeLocalTime!,
          //                 highestBidValue: snapshot.data!.highestBidValue!,
          //                 startPrice: snapshot.data!.startPrice!),
          //             onPlaceBid: (productId, bidValue) {},
          //           )
          //         ]).paddingBottom(20);
          //   },
          //   loadingBuilder: (context, snapShotRef, snapshot) {
          //     return const SizedBox.shrink();
          //   },
          //   errorBuilder: (context, snapShotRef, snapshot) {
          //     return const SizedBox.shrink();
          //   },
          // ),
          // Shipping information
          ConsumerFuterBuilderWidget(
            futureBuilder:
                (shippingInfoRef) => shippingInfoRef.watch(
                  productControllerProvider(
                    widget.productId,
                  ).selectAsync((s) => s.productDetailsModel),
                ),
            builder: (
              shippingInfoContext,
              shippingInfoRef,
              shippingInfoSnapshot,
            ) {
              var model = DeliveryInfoModel(
                freeShippingNotificationEnabled:
                    shippingInfoSnapshot
                        .data!
                        .freeShippingNotificationEnabled ??
                    false,
                isFreeShipping:
                    shippingInfoSnapshot.data!.isFreeShipping ?? false,
                notReturnable:
                    shippingInfoSnapshot.data!.notReturnable ?? false,
                additionalShippingCharge:
                    shippingInfoSnapshot.data!.additionalShippingCharge!,
                additionalShippingChargeStr:
                    shippingInfoSnapshot.data!.additionalShippingChargeStr ??
                    '',
              );

              if (!(model.freeShippingNotificationEnabled &&
                      model.isFreeShipping) &&
                  model.deliveryDate.isEmpty &&
                  !model.notReturnable &&
                  model.additionalShippingCharge <= 0) {
                return const SizedBox.shrink();
              }
              return DeliveryInfoWidget(model: model).paddingBottom(20);
            },
            loadingBuilder: (context, snapShotRef, snapshot) {
              return const SizedBox.shrink();
            },
            errorBuilder: (context, snapShotRef, snapshot) {
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20),
      child: Divider(
        color: getIt<ThemeController>().isDarkMode ? borderDark : borderColor,
        height: 1,
        thickness: 1,
      ),
    );
  }
}

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
