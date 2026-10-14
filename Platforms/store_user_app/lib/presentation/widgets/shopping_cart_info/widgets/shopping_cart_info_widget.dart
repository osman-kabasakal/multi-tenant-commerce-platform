import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store_user_app/core/navigation/app_router.gr.dart';
import 'package:store_user_app/presentation/widgets/shopping_cart_info/view_models/shopping_cart_info_state.dart';

import '../providers/shopping_cart_info_provider.dart';

enum ShoppingCartInfoVariant {
  fixed,
  floating,
  inline,
}

class ShoppingCartInfoWidget extends ConsumerWidget {
  final ShoppingCartInfoVariant variant;
  final bool dismissible;
  final VoidCallback? onTap;
  
  const ShoppingCartInfoWidget({
    Key? key,
    this.variant = ShoppingCartInfoVariant.fixed,
    this.dismissible = true,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(shoppingCartInfoControllerProvider);
    
    if (state.isDismissed || state.status == ShoppingCartInfoStatus.empty) {
      return const SizedBox.shrink();
    }
    
    // readyToCheckout durumunda sadece ücretsiz kargo kazanıldıysa göster
    if (state.status == ShoppingCartInfoStatus.readyToCheckout &&
        !state.secondaryMessage!.contains('Ücretsiz kargo')) {
      return const SizedBox.shrink();
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: _buildVariant(context, ref, state),
    );
  }

  Widget _buildVariant(BuildContext context, WidgetRef ref, ShoppingCartInfoState state) {
    switch (variant) {
      case ShoppingCartInfoVariant.fixed:
        return _buildFixedVariant(context, ref, state);
      case ShoppingCartInfoVariant.floating:
        return _buildFloatingVariant(context, ref, state);
      case ShoppingCartInfoVariant.inline:
        return _buildInlineVariant(context, ref, state);
    }
  }

  Widget _buildFixedVariant(BuildContext context, WidgetRef ref, ShoppingCartInfoState state) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap ?? () => _handleTap(context, ref, state),
          child: _buildContent(context, ref, state),
        ),
      ),
    );
  }

  Widget _buildFloatingVariant(BuildContext context, WidgetRef ref, ShoppingCartInfoState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap ?? () => _handleTap(context, ref, state),
            child: _buildContent(context, ref, state),
          ),
        ),
      ),
    );
  }

  Widget _buildInlineVariant(BuildContext context, WidgetRef ref, ShoppingCartInfoState state) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap ?? () => _handleTap(context, ref, state),
          child: _buildContent(context, ref, state),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, ShoppingCartInfoState state) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              _buildIcon(context, state),
              const SizedBox(width: 12),
              Expanded(
                child: _buildText(context, state),
              ),
              if (state.actionText != null) ...[
                const SizedBox(width: 8),
                Text(
                  state.actionText!,
                  style: TextStyle(
                    fontSize: 16,
                    color: _getStatusColor(context, state.status),
                  ),
                ),
              ],
              if (dismissible) ...[
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: () => ref.read(shoppingCartInfoControllerProvider.notifier).dismiss(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ],
            ],
          ),
        ),
        if (state.progressPercentage > 0) _buildProgressIndicator(context, state),
      ],
    );
  }

  Widget _buildIcon(BuildContext context, ShoppingCartInfoState state) {
    IconData iconData;
    switch (state.status) {
      case ShoppingCartInfoStatus.empty:
        iconData = Icons.shopping_cart_outlined;
        break;
      case ShoppingCartInfoStatus.belowMinimum:
        iconData = Icons.shopping_cart_outlined;
        break;
      case ShoppingCartInfoStatus.aboveMinimumBelowFreeShipping:
        iconData = Icons.local_shipping_outlined;
        break;
      case ShoppingCartInfoStatus.readyToCheckout:
        iconData = Icons.check_circle_outline;
        break;
    }

    return Icon(
      iconData,
      size: 24,
      color: _getStatusColor(context, state.status),
    );
  }

  Widget _buildText(BuildContext context, ShoppingCartInfoState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (state.primaryMessage != null)
          Text(
            state.primaryMessage!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: _getStatusColor(context, state.status),
                ),
          ),
        if (state.secondaryMessage != null) ...[
          const SizedBox(height: 2),
          Text(
            state.secondaryMessage!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                ),
          ),
        ],
      ],
    );
  }

  Widget _buildProgressIndicator(BuildContext context, ShoppingCartInfoState state) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: LinearProgressIndicator(
        value: state.progressPercentage,
        backgroundColor: Colors.transparent,
        valueColor: AlwaysStoppedAnimation<Color>(
          _getStatusColor(context, state.status).withOpacity(0.3),
        ),
        minHeight: 2,
      ),
    );
  }

  Color _getStatusColor(BuildContext context, ShoppingCartInfoStatus status) {
    switch (status) {
      case ShoppingCartInfoStatus.empty:
        return Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey;
      case ShoppingCartInfoStatus.belowMinimum:
        return Colors.red.shade600;
      case ShoppingCartInfoStatus.aboveMinimumBelowFreeShipping:
        return Colors.orange.shade600;
      case ShoppingCartInfoStatus.readyToCheckout:
        return Colors.green.shade600;
    }
  }

  void _handleTap(BuildContext context, WidgetRef ref, ShoppingCartInfoState state) {
    if (state.status == ShoppingCartInfoStatus.empty) {
      return;
    }
    
    context.router.push(const CartRoute());
  }
}