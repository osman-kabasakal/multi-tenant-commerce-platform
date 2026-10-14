import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/shopping_cart_info_provider.dart';
import 'shopping_cart_info_widget.dart';

class DismissibleShoppingCartInfo extends ConsumerWidget {
  final ShoppingCartInfoVariant variant;
  final VoidCallback? onTap;
  
  const DismissibleShoppingCartInfo({
    Key? key,
    this.variant = ShoppingCartInfoVariant.floating,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(shoppingCartInfoControllerProvider);
    
    if (state.isDismissed) {
      return const SizedBox.shrink();
    }

    return Dismissible(
      key: const Key('shopping_cart_info'),
      direction: DismissDirection.horizontal,
      onDismissed: (_) {
        ref.read(shoppingCartInfoControllerProvider.notifier).dismiss();
      },
      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: Colors.red.shade400,
        child: const Icon(
          Icons.delete_outline,
          color: Colors.white,
        ),
      ),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: Colors.red.shade400,
        child: const Icon(
          Icons.delete_outline,
          color: Colors.white,
        ),
      ),
      child: ShoppingCartInfoWidget(
        variant: variant,
        dismissible: false,
        onTap: onTap,
      ),
    );
  }
}