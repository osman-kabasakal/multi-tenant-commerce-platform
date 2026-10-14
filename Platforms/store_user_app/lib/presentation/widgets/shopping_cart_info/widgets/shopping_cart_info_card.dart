import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store_user_app/presentation/widgets/shopping_cart_info/view_models/shopping_cart_info_state.dart';

import '../providers/shopping_cart_info_provider.dart';
import 'animated_progress_indicator.dart';

class ShoppingCartInfoCard extends ConsumerWidget {
  const ShoppingCartInfoCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(shoppingCartInfoControllerProvider);
    
    if (state.status == ShoppingCartInfoStatus.empty) {
      return const SizedBox.shrink();
    }
    
    // readyToCheckout durumunda da kartı göster

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildHeader(context, state),
          if (state.progressPercentage > 0) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AnimatedProgressIndicator(
                progress: state.progressPercentage,
                color: _getStatusColor(context, state.status),
                height: 8,
              ),
            ),
            const SizedBox(height: 12),
          ],
          _buildContent(context, state),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ShoppingCartInfoState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getStatusColor(context, state.status).withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          Icon(
            _getStatusIcon(state.status),
            size: 28,
            color: _getStatusColor(context, state.status),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getStatusTitle(state.status),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: _getStatusColor(context, state.status),
                      ),
                ),
                if (state.primaryMessage != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    state.primaryMessage!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getStatusColor(context, state.status),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${(state.progressPercentage * 100).toInt()}%',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, ShoppingCartInfoState state) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          if (state.secondaryMessage != null) ...[
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 20,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    state.secondaryMessage!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
          _buildMotivationalMessage(context, state),
        ],
      ),
    );
  }

  Widget _buildMotivationalMessage(BuildContext context, ShoppingCartInfoState state) {
    String message;
    IconData icon;
    
    switch (state.status) {
      case ShoppingCartInfoStatus.belowMinimum:
        if (state.progressPercentage < 0.3) {
          message = 'Harika ürünlerle sepetinizi doldurmaya başlayın!';
          icon = Icons.shopping_bag_outlined;
        } else if (state.progressPercentage < 0.7) {
          message = 'Çok az kaldı, alışverişe devam edin!';
          icon = Icons.trending_up;
        } else {
          message = 'Neredeyse minimum tutara ulaştınız!';
          icon = Icons.celebration_outlined;
        }
        break;
      case ShoppingCartInfoStatus.aboveMinimumBelowFreeShipping:
        if (state.progressPercentage < 0.5) {
          message = 'Ücretsiz kargo için biraz daha alışveriş yapın!';
          icon = Icons.local_shipping_outlined;
        } else {
          message = 'Ücretsiz kargoya çok yakınsınız!';
          icon = Icons.rocket_launch_outlined;
        }
        break;
      case ShoppingCartInfoStatus.readyToCheckout:
        if (state.secondaryMessage != null && state.secondaryMessage!.contains('Ücretsiz kargo')) {
          message = 'Tebrikler! Artık siparişinizi ücretsiz kargo ile tamamlayabilirsiniz.';
          icon = Icons.celebration;
        } else {
          message = 'Siparişiniz hazır! Hemen tamamlayabilirsiniz.';
          icon = Icons.check_circle;
        }
        break;
      default:
        message = '';
        icon = Icons.check_circle_outline;
    }

    if (message.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Theme.of(context).primaryColor,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusTitle(ShoppingCartInfoStatus status) {
    switch (status) {
      case ShoppingCartInfoStatus.empty:
        return 'Sepet Boş';
      case ShoppingCartInfoStatus.belowMinimum:
        return 'Minimum Sipariş Tutarı';
      case ShoppingCartInfoStatus.aboveMinimumBelowFreeShipping:
        return 'Ücretsiz Kargo Hedefi';
      case ShoppingCartInfoStatus.readyToCheckout:
        return 'Sipariş Hazır';
    }
  }

  IconData _getStatusIcon(ShoppingCartInfoStatus status) {
    switch (status) {
      case ShoppingCartInfoStatus.empty:
        return Icons.shopping_cart_outlined;
      case ShoppingCartInfoStatus.belowMinimum:
        return Icons.shopping_cart_outlined;
      case ShoppingCartInfoStatus.aboveMinimumBelowFreeShipping:
        return Icons.local_shipping_outlined;
      case ShoppingCartInfoStatus.readyToCheckout:
        return Icons.check_circle_outline;
    }
  }

  Color _getStatusColor(BuildContext context, ShoppingCartInfoStatus status) {
    switch (status) {
      case ShoppingCartInfoStatus.empty:
        return Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey;
      case ShoppingCartInfoStatus.belowMinimum:
        return Colors.orange.shade600;
      case ShoppingCartInfoStatus.aboveMinimumBelowFreeShipping:
        return Colors.blue.shade600;
      case ShoppingCartInfoStatus.readyToCheckout:
        return Colors.green.shade600;
    }
  }
}