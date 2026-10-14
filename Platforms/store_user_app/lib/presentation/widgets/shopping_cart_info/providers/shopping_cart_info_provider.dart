import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:store_user_app/domain/entities/models/shopping_cart_info/shopping_cart_info_response/shopping_cart_info_response.dart';
import 'package:store_user_app/domain/usecases/shopping_cart/shopping_cart_use_case.dart';

import '../view_models/shopping_cart_info_state.dart';

part 'shopping_cart_info_provider.g.dart';

@riverpod
class ShoppingCartInfoController extends _$ShoppingCartInfoController {
  @override
  ShoppingCartInfoState build() {
    final cartState = ref.watch(shoppingCartUseCaseProvider);
    final shoppingCartInfo = cartState.valueOrNull?.shoppingCartInfo;

    if (shoppingCartInfo == null) {
      return const ShoppingCartInfoState();
    }

    return _mapCartInfoToState(shoppingCartInfo);
  }

  ShoppingCartInfoState _mapCartInfoToState(ShoppingCartInfoResponse info) {
    ShoppingCartInfoStatus status;
    String? primaryMessage;
    String? secondaryMessage;
    String? actionText;
    double progressPercentage = 0.0;

    if (info.cartIsEmpty == true) {
      status = ShoppingCartInfoStatus.empty;
      primaryMessage = 'Sepetiniz boş';
    } else if (info.minimumOrder != null && info.minimumOrder!.isMet != true) {
      status = ShoppingCartInfoStatus.belowMinimum;
      primaryMessage = 'Min. sipariş: ${info.minimumOrder!.formattedMinimumAmount}';
      secondaryMessage = 'Kalan: ${info.minimumOrder!.formattedRemainingAmount}';
      actionText = '→';
      
      if (info.minimumOrder!.minimumOrderAmount != null && 
          info.minimumOrder!.minimumOrderAmount! > 0) {
        final current = (info.minimumOrder!.minimumOrderAmount! - 
                        (info.minimumOrder!.remainingAmount ?? 0));
        progressPercentage = (current / info.minimumOrder!.minimumOrderAmount!).clamp(0.0, 1.0);
      }
    } else if (info.freeShipping != null && 
               info.freeShipping!.isFreeShippingActive == false &&
               info.freeShipping!.remainingAmountForFreeShipping != null &&
               info.freeShipping!.remainingAmountForFreeShipping! > 0) {
      status = ShoppingCartInfoStatus.aboveMinimumBelowFreeShipping;
      primaryMessage = '✓ Min. sipariş';
      secondaryMessage = '🚚 Ücretsiz kargo: ${info.freeShipping!.formattedRemainingAmount} kaldı';
      actionText = '→';
      
      if (info.freeShipping!.minimumAmountForFreeShipping != null && 
          info.freeShipping!.minimumAmountForFreeShipping! > 0) {
        final current = (info.freeShipping!.minimumAmountForFreeShipping! - 
                        (info.freeShipping!.remainingAmountForFreeShipping ?? 0));
        progressPercentage = (current / info.freeShipping!.minimumAmountForFreeShipping!).clamp(0.0, 1.0);
      }
    } else if (info.canCheckout == true) {
      status = ShoppingCartInfoStatus.readyToCheckout;
      // Hedeflerin tamamlandığını göster
      if (info.freeShipping != null && 
          info.freeShipping!.isFreeShippingActive == true &&
          (info.freeShipping!.remainingAmountForFreeShipping == null || 
           info.freeShipping!.remainingAmountForFreeShipping == 0)) {
        primaryMessage = '✓ Min. sipariş tamamlandı';
        secondaryMessage = '✓ Ücretsiz kargo kazandınız!';
      } else if (info.minimumOrder != null && info.minimumOrder!.isMet == true) {
        primaryMessage = '✓ Min. sipariş tamamlandı';
        secondaryMessage = 'Siparişinizi tamamlayabilirsiniz';
      } else {
        primaryMessage = '✓ Sipariş hazır';
        secondaryMessage = 'Sepete git';
      }
      actionText = '→';
      progressPercentage = 1.0;
    } else {
      status = ShoppingCartInfoStatus.empty;
    }

    return ShoppingCartInfoState(
      status: status,
      primaryMessage: primaryMessage,
      secondaryMessage: secondaryMessage,
      actionText: actionText,
      progressPercentage: progressPercentage,
    );
  }

  void toggleDisplayMode() {
    final currentMode = state.displayMode;
    final newMode = currentMode == ShoppingCartInfoDisplayMode.compact
        ? ShoppingCartInfoDisplayMode.expanded
        : ShoppingCartInfoDisplayMode.compact;
    
    state = state.copyWith(displayMode: newMode, isAnimating: true);
    
    Future.delayed(const Duration(milliseconds: 300), () {
      state = state.copyWith(isAnimating: false);
    });
  }

  void dismiss() {
    state = state.copyWith(isDismissed: true);
  }

  void show() {
    state = state.copyWith(isDismissed: false);
  }
}