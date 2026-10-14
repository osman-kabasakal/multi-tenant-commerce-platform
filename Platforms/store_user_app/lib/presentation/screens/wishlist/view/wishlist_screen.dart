import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:store_user_app/core/config/theme/skeleton_styles.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/constants/images.dart';
import 'package:store_user_app/core/utils/extensions/build_context_extensions.dart';
import 'package:store_user_app/domain/entities/models/shopping_cart/product_details_cart/product_details_cart.dart';
import 'package:store_user_app/domain/entities/models/shopping_cart/update_quantity_model/update_quantity_model.dart';
import 'package:store_user_app/domain/entities/models/shopping_cart/wishlist_model/shopping_cart_item_model/shopping_cart_item_model.dart';
import 'package:store_user_app/domain/entities/models/shopping_cart/wishlist_model/wishlist_model.dart';
import 'package:store_user_app/domain/entities/orders/shopping_cart_type/shopping_cart_type.dart';
import 'package:store_user_app/domain/usecases/wish_list/wish_list_state.dart';
import 'package:store_user_app/domain/usecases/wish_list/wish_list_use_case.dart';
import 'package:store_user_app/presentation/screens/wishlist/widgets/email_wishlist_dialog.dart';
import 'package:store_user_app/presentation/screens/wishlist/widgets/wishlist_cart_item_list_tile.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_error_widget.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_widget.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/consumer_futer_builder_widget.dart';
import 'package:store_user_app/presentation/widgets/layout/view/app_back_button_handler.dart';
import 'package:store_user_app/presentation/widgets/layout/view/app_inifinite_scroll_list.dart';
import 'package:store_user_app/presentation/widgets/products/widgets/quick_add_to_cart_bottom_sheet.dart';
import 'package:store_user_app/presentation/widgets/skeletons/widgets/shimmer.dart';
import 'package:store_user_app/presentation/widgets/skeletons/widgets/widgets.dart';

@RoutePage()
class WishlistScreen extends StatefulHookConsumerWidget {
  const WishlistScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends ConsumerState<WishlistScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    super.dispose();
  }

  void _showSnackBar(String message, {bool isError = false}) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: isError ? Colors.red : colorPrimary,
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // void _shareWishlist(String customerGuid) {
  //   final String shareUrl = 'https://${Uri.base.host}/wishlist/$customerGuid';
  //   // Share.share(shareUrl, subject: 'Check out my wishlist!');
  // }

  void _showEmailWishlistDialog(WishlistModel wishlist) {
    showDialog(
      context: context,
      builder:
          (context) => EmailWishlistDialog(
            onSubmit: (model) async {
              var emailResponse = await ref
                  .watch(wishListUseCaseProvider.notifier)
                  .emailWishlist(model);
              if (emailResponse.successfullySent!) {
                _showSnackBar(
                  emailResponse.result ??
                      'İstek listesi e-posta ile gönderildi',
                );
                context.router.maybePop();
              } else {
                _showSnackBar(
                  emailResponse.result ??
                      'İstek listesi e-posta ile gönderilemedi',
                  isError: true,
                );
              }
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: fdCommonAppBarWidget(
        context,
        titleText: 'Favori Listem'.padLeft(20),
        isback: false,
        actionWidget: IconButton(
          icon: SvgPicture.asset(
            heartIcon,
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(
              Theme.of(context).iconTheme.color ?? Colors.black,
              BlendMode.srcIn,
            ),
          ),
          onPressed: () {},
        ),
      ),
      body: _buildContent(context),
    );
  }

  RefreshIndicator _buildContent(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(wishListUseCaseProvider.notifier).refresh();
      },
      color: context.colorScheme.primary,
      child: ConsumerFuterBuilderWidget(
        futureBuilder:
            (wishlistRef) => wishlistRef.watch(
              wishListUseCaseProvider.selectAsync((s) => s),
            ),
        builder: (wishlistContext, wishlistRef, wishlistSnapshot) {
          final WishListState wishlistState = wishlistSnapshot.data!;
          final WishlistModel? wishlist = wishlistState.wishList;

          if (wishlist == null || (wishlist.items?.isEmpty ?? true)) {
            return _buildEmptyWishlist();
          }

          return Column(
            children: [
              // Display warnings if any
              if (wishlist.warnings?.isNotEmpty ?? false)
                _buildWarningMessages(wishlist.warnings!),

              // Main wishlist content
              Expanded(
                child: AppInifiniteScrollList(
                  key: const ValueKey('WishlistItems_list'),
                  isLoading: false,
                  hasMore: false,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  onLoadMore: () => Future.value(),
                  itemCount: wishlist.items?.length ?? 0,
                  itemBuilder: (context, index) {
                    final item = wishlist.items![index];
                    return _buildWishlistItem(item);
                  },
                ),
              ),

              // Bottom Actions
              if (wishlist.isEditable ?? false) _buildBottomActions(wishlist),
            ],
          );
        },
        errorBuilder: (context, snapShotRef, snapshot) {
          return AppErrorWidget(
            message: snapshot.error.toString(),
            onRetry: () {
              snapShotRef.invalidate(wishListUseCaseProvider);
            },
          );
        },
        loadingBuilder: (context, snapShotRef, snapshot) {
          return _buildLoadingState();
        },
      ),
    );
  }

  Widget _buildEmptyWishlist() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            heartIcon,
            width: 64,
            height: 64,
            colorFilter: ColorFilter.mode(colorGrey400, BlendMode.srcIn),
          ),
          const SizedBox(height: 16),
          Text(
            'İstek listeniz boş',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Beğendiğiniz ürünleri istek listenize ekleyin',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: colorGrey500),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningMessages(List<String> warnings) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.orange),
              const SizedBox(width: 8),
              Text(
                'Uyarılar',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: Colors.orange),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...warnings.map(
            (warning) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(color: Colors.orange)),
                  Expanded(
                    child: Text(
                      warning,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.orange[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWishlistItem(ShoppingCartItemModel item) {
    return Consumer(
      builder: (itemContext, itemRef, _) {
        return WishlistCartItemListTile(
          cartItem: item,
          onItemEdit: () async {
            var model = await itemRef
                .read(wishListUseCaseProvider.notifier)
                .getItemCart(item.id!);
            var detailResponse = await showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              useSafeArea: true,
              showDragHandle: true,
              builder: (bottomSheetContext) {
                return QuickAddToCartBottomSheet(product: model);
              },
            );
            if (detailResponse != null &&
                detailResponse is ProductDetailsCart) {
              await ref
                  .read(wishListUseCaseProvider.notifier)
                  .updateWishlistItem(
                    detailResponse.copyWith(
                      shoppingCartTypeId: ShoppingCartType.wishlist,
                    ),
                  );
            }
          },
          onAddToCart:
              item.id != null
                  ? () async {
                    try {
                      await itemRef
                          .read(wishListUseCaseProvider.notifier)
                          .addToCartFromWishlist(item.id!);
                      _showSnackBar('Ürün sepete eklendi');
                    } catch (e) {
                      _showSnackBar(
                        'Ürün sepete eklenirken hata oluştu',
                        isError: true,
                      );
                    }
                  }
                  : null,
          onChanged: (value) async {
            if (item.id == null) return;

            try {
              await itemRef
                  .read(wishListUseCaseProvider.notifier)
                  .updateQuantity(
                    UpdateQuantityModel(
                      shoppingCartId: item.id!,
                      quantity: value,
                    ),
                  );
            } catch (e) {
              _showSnackBar('Miktar güncellenirken hata oluştu', isError: true);
            }
          },
          onIncrease: () async {
            if (item.id == null) return;

            try {
              await itemRef
                  .read(wishListUseCaseProvider.notifier)
                  .updateQuantity(
                    UpdateQuantityModel(
                      shoppingCartId: item.id!,
                      quantity: (item.quantity ?? 0) + 1,
                    ),
                  );
            } catch (e) {
              _showSnackBar('Miktar artırılırken hata oluştu', isError: true);
            }
          },
          onDecrease: () async {
            if (item.id == null) return;
            if ((item.quantity ?? 0) <= 1) {
              await itemRef
                  .read(wishListUseCaseProvider.notifier)
                  .removeFromWishListByProductId(item.productId!);
              return;
            }

            try {
              await itemRef
                  .read(wishListUseCaseProvider.notifier)
                  .updateQuantity(
                    UpdateQuantityModel(
                      shoppingCartId: item.id!,
                      quantity: (item.quantity ?? 0) - 1,
                    ),
                  );
            } catch (e) {
              _showSnackBar('Miktar azaltılırken hata oluştu', isError: true);
            }
          },
          onRemove: () async {
            if (item.productId == null) return;

            try {
              await itemRef
                  .read(wishListUseCaseProvider.notifier)
                  .removeFromWishListByProductId(item.productId!);
              _showSnackBar('Ürün listeden kaldırıldı');
            } catch (e) {
              _showSnackBar('Ürün kaldırılırken hata oluştu', isError: true);
            }
          },
        );
      },
    );
  }

  Widget _buildBottomActions(WishlistModel wishlist) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Email wishlist button
          if (wishlist.emailWishlistEnabled ?? false)
            ElevatedButton.icon(
              onPressed: () => _showEmailWishlistDialog(wishlist),
              icon: const Icon(Icons.email),
              label: const Text('İstek Listesini Paylaş'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(50),
              ),
            ),

          // // Share URL
          // if (wishlist.customerGuid != null && (wishlist.isEditable ?? false))
          //   Padding(
          //     padding: const EdgeInsets.only(top: 16),
          //     child: Row(
          //       children: [
          //         Text(
          //           'İstek Listenizin Bağlantısı:',
          //           style: Theme.of(context).textTheme.bodyMedium,
          //         ),
          //         const SizedBox(width: 8),
          //         Expanded(
          //           child: GestureDetector(
          //             onTap: () => _shareWishlist(wishlist.customerGuid!),
          //             child: Text(
          //               'İstek Listemi Paylaş',
          //               style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          //                     color: Theme.of(context).primaryColor,
          //                     decoration: TextDecoration.underline,
          //                   ),
          //               overflow: TextOverflow.ellipsis,
          //             ),
          //           ),
          //         ),
          //         IconButton(
          //           icon: const Icon(Icons.share),
          //           onPressed: () => _shareWishlist(wishlist.customerGuid!),
          //           color: Theme.of(context).primaryColor,
          //         ),
          //       ],
          //     ),
          //   ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: ShimmerWidget(
        child: Column(
          children: List.generate(
            5,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: SkeletonListTile(
                hasLeading: true,
                leadingStyle: const SkeletonAvatarStyle(
                  width: 110,
                  height: 110,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                ),
                titleStyle: const SkeletonLineStyle(
                  height: 20,
                  width: 200,
                  padding: EdgeInsets.only(bottom: 8),
                ),
                hasSubtitle: true,
                subtitleStyle: const SkeletonLineStyle(
                  height: 16,
                  width: 250,
                  padding: EdgeInsets.only(bottom: 6),
                ),
                trailing: Container(
                  width: 100,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                contentSpacing: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
