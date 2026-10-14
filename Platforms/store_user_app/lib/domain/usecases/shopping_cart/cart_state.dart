import 'package:freezed_annotation/freezed_annotation.dart';

import '../../entities/common/custom_attribute/custom_attribute.dart';
import '../../entities/models/shopping_cart/order_totals_model/order_totals_model.dart';
import '../../entities/models/shopping_cart/shopping_cart_model/shopping_cart_model.dart';
import '../../entities/models/shopping_cart_info/shopping_cart_info_response/shopping_cart_info_response.dart';

part 'cart_state.freezed.dart';

@freezed
class CartState with _$CartState {
  const factory CartState({
    @Default(false) bool isLoading,
    @Default(null) ShoppingCartModel? cart,
    @Default(null) String? error,
    @Default({}) Map<String, bool> processingCarts,
    @Default([]) List<CustomAttribute> selectedCustomAttributes,
    @Default(null) OrderTotalsModel? orderTotal,
    @Default(null) ShoppingCartInfoResponse? shoppingCartInfo,
  }) = _CartState;
}
