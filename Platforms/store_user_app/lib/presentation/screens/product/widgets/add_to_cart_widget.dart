import 'package:flutter/material.dart';
import 'package:store_user_app/domain/entities/models/catalog/product_details_model/add_to_cart_model/add_to_cart_model.dart';
import 'package:store_user_app/domain/entities/orders/shopping_cart_type/shopping_cart_type.dart';

class AddToCartWidget extends StatefulWidget {
  final AddToCartModel model;
  // final Function(String, int, double) onAddToCart;

  const AddToCartWidget({
    super.key,
    required this.model,
    // required this.onAddToCart,
  });

  @override
  State<AddToCartWidget> createState() => _AddToCartWidgetState();
}

class _AddToCartWidgetState extends State<AddToCartWidget> {
  // late TextEditingController quantityController;
  late TextEditingController priceController;
  // late String selectedQuantity;

  @override
  void initState() {
    super.initState();
    // quantityController = TextEditingController(text: '1');
    priceController = TextEditingController(
      text:
          (widget.model.customerEnteredPrice ?? 0) > 0
              ? widget.model.customerEnteredPrice!.ceil().toString()
              : '',
    );

    // selectedQuantity = widget.model.allowedQuantities!.isNotEmpty
    //     ? widget.model.allowedQuantities!
    //         .firstWhere((q) => (q.selected ?? false),
    //             orElse: () => widget.model.allowedQuantities!.first)
    //         .value!
    //     : '1';
  }

  @override
  void dispose() {
    // quantityController.dispose();
    priceController.dispose();
    super.dispose();
  }

  // String _getAddToCartText() {
  //   if ((widget.model.updatedShoppingCartItemId?.isNotEmpty ?? false) &&
  //       widget.model.updateShoppingCartItemType != null &&
  //       (widget.model.updateShoppingCartItemType ==
  //               ShoppingCartType.shoppingCart ||
  //           widget.model.updateShoppingCartItemType ==
  //               ShoppingCartType.onHoldCart)) {
  //     return 'ShoppingCart.AddToCart.Update';
  //   } else if (widget.model.isReservation ?? false) {
  //     return 'ShoppingCart.Reservation';
  //   } else if (widget.model.availableForPreOrder ?? false) {
  //     return 'ShoppingCart.PreOrder';
  //   } else if (widget.model.isAuction ?? false) {
  //     return 'ShoppingCart.BuyNow';
  //   } else {
  //     return 'ShoppingCart.AddToCart';
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    if ((widget.model.disableBuyButton ?? false) &&
        !(widget.model.enteredPrice ?? false)) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.model.enteredPrice ?? false)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ürün Fiyatı Girin',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: priceController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
                if (widget.model.customerEnteredPriceRange?.isNotEmpty ?? false)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      (widget.model.customerEnteredPriceRange!),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
              ],
            ),
          if (widget.model.minimumQuantityNotification?.isNotEmpty ?? false)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                widget.model.minimumQuantityNotification!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          // if (!(widget.model.disableBuyButton ?? false))
          //   Row(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       if (widget.model.allowedQuantities?.isNotEmpty ?? false)
          //         Expanded(
          //           child: DropdownButtonFormField<String>(
          //             value: selectedQuantity,
          //             decoration: const InputDecoration(
          //               border: OutlineInputBorder(),
          //               contentPadding:
          //                   EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          //             ),
          //             items: widget.model.allowedQuantities!
          //                 .map((q) => DropdownMenuItem(
          //                       value: q.value,
          //                       child: Text(q.text!),
          //                     ))
          //                 .toList(),
          //             onChanged: (value) {
          //               if (value != null) {
          //                 setState(() {
          //                   selectedQuantity = value;
          //                 });
          //               }
          //             },
          //           ),
          //         )
          //       else
          //         Expanded(
          //           child: TextFormField(
          //             controller: quantityController,
          //             decoration: const InputDecoration(
          //               border: OutlineInputBorder(),
          //               contentPadding:
          //                   EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          //             ),
          //             keyboardType: TextInputType.number,
          //           ),
          //         ),
          //       if (widget.model.measureUnit?.isNotEmpty ?? false)
          //         Padding(
          //           padding: const EdgeInsets.symmetric(
          //               horizontal: 8.0, vertical: 12.0),
          //           child: Text(widget.model.measureUnit!),
          //         ),
          //       const SizedBox(width: 8),
          //       ElevatedButton(
          //         onPressed: () {
          //           final int quantity =
          //               widget.model.allowedQuantities!.isNotEmpty
          //                   ? int.parse(selectedQuantity)
          //                   : int.tryParse(quantityController.text) ?? 1;
          //           final double price = (widget.model.enteredPrice ?? false)
          //               ? double.tryParse(priceController.text) ?? 0
          //               : 0;
          //           widget.onAddToCart(
          //               widget.model.productId!, quantity, price);
          //         },
          //         style: ElevatedButton.styleFrom(
          //           backgroundColor: Theme.of(context).primaryColor,
          //           padding: const EdgeInsets.symmetric(
          //               horizontal: 16, vertical: 12),
          //         ),
          //         child: Text(_getAddToCartText()),
          //       ),
          //     ],
          //   ),
        ],
      ),
    );
  }
}
