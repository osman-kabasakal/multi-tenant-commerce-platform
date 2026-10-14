import 'package:flutter/material.dart';
import 'package:store_user_app/domain/entities/orders/shopping_cart_type/shopping_cart_type.dart';

class AddToWishlistModel {
  final String productId;
  final bool disableWishlistButton;
  final String updatedShoppingCartItemId;
  final ShoppingCartType? updateShoppingCartItemType;

  AddToWishlistModel({
    required this.productId,
    required this.disableWishlistButton,
    this.updatedShoppingCartItemId = '',
    this.updateShoppingCartItemType,
  });
}

class AddToWishlistWidget extends StatelessWidget {
  final AddToWishlistModel model;
  final Function(String) onAddToWishlist;

  const AddToWishlistWidget({
    super.key,
    required this.model,
    required this.onAddToWishlist,
  });

  @override
  Widget build(BuildContext context) {
    if (model.disableWishlistButton) {
      return const SizedBox.shrink();
    }

    String buttonText = '';
    if (model.updatedShoppingCartItemId.isNotEmpty &&
        model.updateShoppingCartItemType == ShoppingCartType.wishlist) {
      buttonText = 'İstek Listemi Güncelle';
    } else {
      buttonText = 'İstek Listeme Ekle';
    }

    return Container(
      margin: const EdgeInsets.only(top: 4.0),
      child: IconButton(
        onPressed: () => onAddToWishlist(model.productId),
        icon: const Icon(Icons.favorite_border),
        tooltip: buttonText,
        style: IconButton.styleFrom(
          backgroundColor: Colors.grey[300],
          foregroundColor: Colors.black87,
        ),
      ),
    );
  }
}
