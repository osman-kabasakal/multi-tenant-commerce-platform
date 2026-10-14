import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/config/theme/theme.dart';
// import 'package:path/path.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/constants/images.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/navigation/app_router.dart';
import 'package:store_user_app/core/navigation/app_router.gr.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/core/utils/extensions/collection_extensions.dart';
import 'package:store_user_app/core/utils/provider/hooks.dart';
import 'package:store_user_app/domain/entities/microsoft/asp_net_core/mvc/rendering/select_list_item/select_list_item.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_animated_loading_widget.dart';
import 'package:store_user_app/presentation/widgets/layout/view/app_inifinite_scroll_list.dart';
import 'package:store_user_app/presentation/widgets/products/providers/product_catalog_controller.dart';
import 'package:store_user_app/presentation/widgets/products/view_models/catalog_state.dart';
import 'package:store_user_app/presentation/widgets/products/view_models/filter_state.dart';
import 'package:store_user_app/presentation/widgets/products/view_models/product_view_type.dart';
import 'package:store_user_app/presentation/widgets/products/widgets/catalog_product_list_item_view.dart';
import 'package:store_user_app/presentation/widgets/products/widgets/filter_buttom_sheet.dart';
import 'package:store_user_app/presentation/widgets/products/widgets/product_item_widget.dart';
import 'package:store_user_app/presentation/widgets/skeletons/widgets/product_catalog_grid_skeleton.dart';
import 'package:store_user_app/presentation/widgets/skeletons/widgets/product_catalog_list_item_skeleton.dart';

class ProductCatalogWidget extends HookConsumerWidget {
  final String? categoryId;
  final String? vendorId;
  final String? searchTerm;
  final String? brandId;
  final String? collectionId;
  final String title;
  final bool showFilterBar;
  final bool showSortBar;
  final bool priceFilterEnabled;
  final bool attributeFilterEnabled;
  final void Function(CatalogState state)? onStateUpdated;

  ProductCatalogWidget({
    super.key,
    this.categoryId,
    this.vendorId,
    this.searchTerm,
    this.brandId,
    this.collectionId,
    required this.title,
    this.showFilterBar = true,
    this.showSortBar = true,
    this.onStateUpdated,
    this.priceFilterEnabled = true,
    this.attributeFilterEnabled = true,
  });

  late final controllerProvider = productCatalogControllerProvider(
    categoryId: categoryId,
    vendorId: vendorId,
    searchTerm: searchTerm,
    brandId: brandId,
    collectionId: collectionId,
    priceFilterEnable: priceFilterEnabled,
    attributeFilterEnabled: attributeFilterEnabled,
  );

  bool isInitialLoading = true;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeController = getIt<ThemeController>();
    final loadingState = ValueNotifier(
      ref.read(controllerProvider.select((state) => state.isLoading)),
    );
    // Track if theme has changed to prevent showing loading on theme changes
    final isInitialLoad = useRef(true);

    ref.listen(controllerProvider, (oldState, state) {
      if (state.error == null && !state.isLoading && state.hasValue) {
        onStateUpdated?.call(state.requireValue);
      }
      // Only show loading indicator during initial load or explicit loading states
      // Not during theme changes

      if (isInitialLoad.value || (oldState?.isLoading != state.isLoading)) {
        loadingState.value =
            state.isLoading &&
            (state.valueOrNull == null || state.valueOrNull!.products.isEmpty);

        if (!state.isLoading) {
          isInitialLoad.value = false;
          isInitialLoading = false;
        }
      }
    });
    useEffect(() {
      return () {
        loadingState.dispose();
      };
    }, [loadingState]);

    return Scaffold(
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        // padding: EdgeInsets.symmetric(horizontal: 5),
        child: ValueListenableBuilder(
          valueListenable: loadingState,
          builder: (context, state, child) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  child!,
                  if (state)
                    Positioned.fill(
                      top: 0,
                      left: 0,
                      child: AppAnimatedLoadingWidget(),
                    ),
                ],
              ),
            );
          },
          child: Column(
            children: [
              _buildFilterBar(
                context,
                ref,
                controllerProvider,
                themeController,
              ),
              5.height,
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Consumer(
                      builder: (csContext, csRef, child) {
                        return FutureBuilder(
                          future: csRef.watch(
                            controllerProvider.selectAsync((s) => s.viewType),
                          ),
                          builder: (ftContext, viewTypeSnapshot) {
                            if (viewTypeSnapshot.data == null) {
                              return SizedBox();
                            }

                            if (viewTypeSnapshot.data == ProductViewType.grid) {
                              return _buildGridView(ref, controllerProvider);
                            } else {
                              return _buildListView(ref, controllerProvider);
                            }
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterBar(
    BuildContext context,
    WidgetRef ref,
    ProductCatalogControllerProvider controllerProvider,
    ThemeController themeController,
  ) {
    return Consumer(
      builder: (filterConsContext, filterConsRef, filterConsChild) {
        return Container(
          decoration: BoxDecoration(
            color:
                getIt<ThemeController>().isDarkMode
                    ? darkPrimary
                    : Colors.white,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Consumer(
                  builder: (filterConsContext, filterConsRef, filterConsChild) {
                    return FutureBuilder(
                      initialData: FilterState(),
                      future: filterConsRef.watch(
                        controllerProvider.selectAsync((s) => s.filter),
                      ),
                      builder: (ftContext, snapshot) {
                        if (snapshot.data == null) return SizedBox();
                        var filter = snapshot.data!;
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (_hasFilter(filter))
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: _buildFilterButton(
                                  'Tümünü Temizle',
                                  () async {
                                    await filterConsRef
                                        .read(controllerProvider.notifier)
                                        .clearAllFilters();
                                  },
                                  colorPrimary,
                                  Icon(
                                    Icons.clear_all,
                                    color: context.theme.colorScheme.error,
                                  ),
                                ),
                              ),
                            Expanded(
                              child: SizedBox(
                                height: kToolbarHeight,
                                child: ListView(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  children: _buildFilterChips(
                                    ref,
                                    controllerProvider,
                                    filter,
                                    colorPrimary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
              Row(
                children: [
                  if (showFilterBar)
                    Consumer(
                      builder: (
                        filterButtonConsContext,
                        filterButtonConsRef,
                        filterButtunConsChild,
                      ) {
                        return _buildFilterButton(
                          'Filtrele',
                          () async {
                            if (filterConsRef.read(
                              controllerProvider.select((s) => s.isLoading),
                            )) {
                              return;
                            }
                            await _showFilterDrawer(
                              filterButtonConsContext,
                              filterButtonConsRef,
                            );
                          },
                          colorPrimary,
                          Icon(Icons.filter_alt, color: colorPrimary),
                        );
                      },
                    ),
                  if (showSortBar) _buildSortButton(controllerProvider),
                  Consumer(
                    builder: (
                      gridTypeConsContext,
                      gridTypeConsRef,
                      gridTypeConsChild,
                    ) {
                      return SnapHelperWidget(
                        initialData: ProductViewType.grid,
                        future: gridTypeConsRef.watch(
                          controllerProvider.selectAsync((s) => s.viewType),
                        ),
                        onSuccess: (viewType) {
                          return _buildFilterButton(
                            'Görünüm',
                            () async {
                              gridTypeConsRef
                                  .read(controllerProvider.notifier)
                                  .toggleViewType();
                            },
                            colorPrimary,
                            viewType == ProductViewType.grid
                                ? Icon(Icons.grid_view, color: colorPrimary)
                                : Icon(Icons.list, color: colorPrimary),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterButton(
    String? message,
    FutureOr<void> Function()? onPressed,
    Color borderColor,
    Widget icon,
  ) {
    return HookBuilder(
      builder: (context) {
        var (
          :pending,
          :snapshot,
          :hasError,
          loaderColor: _,
          loaderStrokeWidth: _,
        ) = useAsyncTask();
        return Tooltip(
          message: message,
          padding: EdgeInsets.all(0),
          margin: EdgeInsets.all(0),
          child: Container(
            margin: const EdgeInsets.only(right: 5),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(color: borderColor, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap:
                  snapshot.connectionState == ConnectionState.waiting ||
                          onPressed == null
                      ? null
                      : () =>
                          (pending.value =
                              (() async => await onPressed.call())()),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  icon,
                  if (snapshot.connectionState == ConnectionState.waiting)
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: Container(
                        color: Theme.of(
                          context,
                        ).cardColor.withValues(alpha: 0.5),
                        child: Center(
                          child: SizedBox(
                            width: 10,
                            height: 10,
                            child: CircularProgressIndicator.adaptive(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                colorPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  bool _hasFilter(FilterState filter) {
    return (filter.priceFilterEnebale &&
            (filter.minPrice != null || filter.maxPrice != null)) ||
        filter.rating != null ||
        (filter.attributeFilterEnbaled &&
            filter.alreadyFilteredItems.isNotEmpty);
  }

  List<Widget> _buildFilterChips(
    WidgetRef ref,
    ProductCatalogControllerProvider controllerProvider,
    FilterState filter,
    Color backgroundColor,
  ) {
    List<Widget> chips = [];
    if (filter.priceFilterEnebale &&
        ((filter.minPrice != null && filter.minPrice! > 0) ||
            (filter.maxPrice != null && filter.maxPrice! > 0))) {
      chips.add(
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Chip(
            label: Text(
              filter.minPrice != null &&
                      filter.minPrice! > 0 &&
                      filter.maxPrice != null &&
                      filter.maxPrice! > 0
                  ? '${filter.minPrice}₺ - ${filter.maxPrice}₺'
                  : filter.minPrice != null && filter.minPrice! > 0
                  ? '≥ ${filter.minPrice}₺'
                  : '≤ ${filter.maxPrice}₺',
              style:
                  getIt<ThemeController>().isDarkMode
                      ? AppTheme.foodDarkTheme.textTheme.bodyMedium?.copyWith(
                        fontFamily: '',
                      )
                      : AppTheme.foodLightTheme.textTheme.bodyMedium?.copyWith(
                        fontFamily: '',
                      ),
            ),
            onDeleted: () async {
              ref
                  .read(controllerProvider.notifier)
                  .filterByPriceRange(null, null);
              await ref
                  .read(controllerProvider.notifier)
                  .filterBySpecifications();
            },
            backgroundColor: backgroundColor.withValues(alpha: 0.1),
          ),
        ),
      );
    }
    if (filter.rating != null) {
      chips.add(
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Chip(
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${filter.rating}'),
                const Icon(Icons.star, size: 16),
              ],
            ),
            onDeleted: () async {
              ref.read(controllerProvider.notifier).setRatingFilter(null);
              await ref
                  .read(controllerProvider.notifier)
                  .filterBySpecifications();
            },
            backgroundColor: backgroundColor.withValues(alpha: 0.1),
          ),
        ),
      );
    }
    if (filter.attributeFilterEnbaled &&
        filter.alreadyFilteredItems.isNotEmpty) {
      chips.addAll(
        filter.alreadyFilteredItems
            .groupBy((a) => a.specificationAttributeName)
            .entries
            .expand((attribute) {
              return attribute.value.map((e) {
                return Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Chip(
                    label: Text(
                      '${e.specificationAttributeName}: ${e.specificationAttributeOptionName}',
                    ),
                    onDeleted: () {
                      ref
                          .read(controllerProvider.notifier)
                          .filterBySpecifications(
                            filters: [
                              ...filter.alreadyFilteredItems.where(
                                (a) =>
                                    a.specificationAttributeOptionSeName !=
                                    e.specificationAttributeOptionSeName,
                              ),
                            ],
                          );
                    },
                    backgroundColor: backgroundColor.withValues(alpha: 0.1),
                  ),
                );
              });
            }),
      );
    }
    return chips;
  }

  Widget _buildGridView(
    WidgetRef ref,
    ProductCatalogControllerProvider controllerProvider,
  ) {
    return Consumer(
      builder: (productsConsContext, productsConsRef, productsConsChild) {
        return FutureBuilder(
          future: productsConsRef.watch(
            controllerProvider.selectAsync((s) => s.products),
          ),
          builder: (productsFutureContext, productsSnapshot) {
            if (productsSnapshot.data == null &&
                productsConsRef.read(
                  controllerProvider.select((s) => s.isLoading),
                )) {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return ProductCatalogGridSkeleton(last: false);
                },
              );
            }

            // Show no results found message when products list is empty
            if (productsSnapshot.data != null &&
                productsSnapshot.data!.isEmpty &&
                !productsConsRef.read(
                  controllerProvider.select((s) => s.isLoading),
                )) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(noSearchResultIcon, width: 120, height: 120),
                    const SizedBox(height: 16),
                    Text(
                      "Sonuç bulunamadı",
                      style: Theme.of(productsConsContext).textTheme.titleLarge,
                    ),
                  ],
                ),
              );
            }

            return HookBuilder(
              builder: (context) {
                var loading = useState(false);
                return NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (!productsConsRef.read(
                          controllerProvider.select((s) => s.isLoading),
                        ) &&
                        !loading.value &&
                        (productsConsRef
                                .read(
                                  controllerProvider.select(
                                    (s) => s.valueOrNull,
                                  ),
                                )
                                ?.hasMore ??
                            false) &&
                        scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent) {
                      loading.value = true;
                      ref
                          .read(controllerProvider.notifier)
                          .loadMoreProducts()
                          .then((v) {
                            loading.value = false;
                          });
                      return true;
                    }
                    return false;
                  },
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.5, // Daha yüksek kartlar için ratio düşürüldü
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount:
                        (productsSnapshot.data?.length ?? 0) +
                        ((productsConsRef
                                    .read(
                                      controllerProvider.select(
                                        (s) => s.valueOrNull,
                                      ),
                                    )
                                    ?.hasMore ??
                                false)
                            ? (2 - ((productsSnapshot.data?.length ?? 0) % 2))
                            : 0),
                    padding: const EdgeInsets.all(10),
                    itemBuilder: (context, index) {
                      if (index > ((productsSnapshot.data?.length ?? 0) - 1)) {
                        return ProductCatalogGridSkeleton(last: true);
                      }
                      return ProductItemWidget(
                        onPressed: () {
                          context.router.navigate(
                            ProductRoute(
                              productId: productsSnapshot.data![index].id ?? '',
                            ),
                          );
                        },
                        product: productsSnapshot.data![index],
                      );
                    },
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildListView(
    WidgetRef ref,
    ProductCatalogControllerProvider controllerProvider,
  ) {
    return Consumer(
      builder: (productsConsContext, productsConsRef, productsConsChild) {
        var state = productsConsRef.watch(controllerProvider);

        // Show no results found message when products list is empty and not loading
        if (!state.isLoading &&
            state.hasValue &&
            state.requireValue.products.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(noSearchResultIcon, width: 120, height: 120),
                const SizedBox(height: 16),
                Text(
                  "Sonuç bulunamadı",
                  style: Theme.of(productsConsContext).textTheme.titleLarge,
                ),
              ],
            ),
          );
        }

        return AppInifiniteScrollList(
          key: ValueKey(
            '${categoryId}_${vendorId}_${searchTerm}_${brandId}_${title}_${showFilterBar}_$showSortBar',
          ),
          isLoading: state.isLoading,
          hasMore: state.valueOrNull?.hasMore ?? false,
          itemCount: state.value?.products.length ?? 0,
          // itemExtend: productsConsContext.width() * 0.5,
          itemBuilder: (context, index) {
            return CatalogProductListItemView(
              onPressed: () {
                context.router.navigate(
                  ProductRoute(
                    productId: state.value?.products[index].id ?? '',
                  ),
                );
              },
              product: state.requireValue.products[index],
            );
          },
          loadingBuilder: (context) {
            return ProductCatalogListItemSkeleton();
          },
          onLoadMore: () async {
            await productsConsRef
                .read(controllerProvider.notifier)
                .loadMoreProducts();
          },
        );
      },
    );
  }

  Widget _buildSortButton(ProductCatalogControllerProvider controllerProvider) {
    return Consumer(
      builder: (context, ref, child) {
        return FutureBuilder(
          future: ref.watch(
            controllerProvider.selectAsync((s) => s.filter.pagingFilterModel),
          ),
          builder: (ftContext, snapshot) {
            return PopupMenuButton<SelectListItem>(
              color: context.theme.scaffoldBackgroundColor,
              shadowColor: context.theme.shadowColor,
              padding: EdgeInsets.zero,
              offset: const Offset(0, 0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onSelected: (opt) {
                ref.read(controllerProvider.notifier).updateSortOption(opt);
              },
              itemBuilder: (BuildContext context) {
                return snapshot.data?.availableSortOptions?.map((option) {
                      return PopupMenuItem<SelectListItem>(
                        value: option,
                        child: Container(
                          padding: const EdgeInsets.only(right: 0),
                          child: Row(
                            children: [
                              const SizedBox(width: 12),
                              Text(
                                option.text ?? '',
                                style: context.theme.textTheme.bodySmall!
                                    .copyWith(
                                      color:
                                          option.selected ?? false
                                              ? colorPrimary
                                              : Theme.of(
                                                context,
                                              ).textTheme.bodyMedium?.color,
                                      fontWeight:
                                          option.selected ?? false
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                    ),
                              ),
                              if (option.selected ?? false) ...[
                                const Spacer(),
                                Icon(
                                  Icons.check,
                                  size: 20,
                                  color: colorPrimary,
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    }).toList() ??
                    [];
              },
              child: _buildFilterButton(
                'Sırala',
                null,
                colorPrimary,
                Icon(Icons.sort, color: colorPrimary),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showFilterDrawer(BuildContext context, WidgetRef ref) async {
    var filterState = await showModalBottomSheet<FilterState>(
      showDragHandle: true,
      isScrollControlled: true,
      context: getIt<AppRouter>().navigatorKey.currentContext!,
      builder: (context) {
        return RepaintBoundary(
          child: Consumer(
            builder: (filterConsContext, filterConsRef, filterConsChild) {
              return FutureBuilder(
                initialData: FilterState(),
                future: filterConsRef.watch(
                  controllerProvider.selectAsync((s) => s.filter),
                ),
                builder: (ftContext, snapshot) {
                  if (snapshot.data == null) return SizedBox();
                  var filter = snapshot.data!;
                  return FilterButtomSheet(filterState: filter);
                },
              );
            },
          ),
        );
      },
    );

    if (filterState == null) {
      return;
    }

    var savedFilterValue = await ref.read(
      controllerProvider.selectAsync((s) => s.filter),
    );

    var selectedCategoryId =
        savedFilterValue.selectedCategory != filterState.selectedCategory
            ? filterState.selectedCategory
            : null;
    var collectionId =
        savedFilterValue.selectedCollectionId !=
                filterState.selectedCollectionId
            ? filterState.selectedCollectionId
            : null;
    var selectedVendorId =
        savedFilterValue.vendorId != filterState.vendorId
            ? filterState.vendorId
            : null;
    var minPrice =
        savedFilterValue.minPrice != filterState.minPrice
            ? filterState.minPrice
            : null;
    var maxPrice =
        savedFilterValue.maxPrice != filterState.maxPrice
            ? filterState.maxPrice
            : null;
    var rating =
        savedFilterValue.rating != filterState.rating
            ? filterState.rating
            : null;
    var attributeFilter =
        savedFilterValue.alreadyFilteredItems !=
                filterState.alreadyFilteredItems
            ? filterState.alreadyFilteredItems
            : null;

    await ref
        .read(controllerProvider.notifier)
        .filterBySpecifications(
          categoryId: selectedCategoryId,
          collectionId: collectionId,
          vendorId: selectedVendorId,
          rating: rating,
          minPrice: minPrice,
          maxPrice: maxPrice,
          filters: attributeFilter,
        );
  }
}
