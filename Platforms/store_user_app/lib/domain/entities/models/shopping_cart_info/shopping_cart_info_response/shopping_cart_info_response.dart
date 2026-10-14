import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../minimum_order_info_dto/minimum_order_info_dto.dart';

import '../free_shipping_info_dto/free_shipping_info_dto.dart';

import '../cart_summary_dto/cart_summary_dto.dart';


part 'shopping_cart_info_response.freezed.dart';
part 'shopping_cart_info_response.g.dart';

@freezed
class ShoppingCartInfoResponse extends StoreJsonSerializable<ShoppingCartInfoResponse> with _$ShoppingCartInfoResponse {
  factory ShoppingCartInfoResponse({ 
    @JsonKey(name: 'Success', includeIfNull: false)
    @Default(false) bool? success,

    @JsonKey(name: 'Message', includeIfNull: false)
     String? message,

    @JsonKey(name: 'CartIsEmpty', includeIfNull: false)
    @Default(false) bool? cartIsEmpty,

    @JsonKey(name: 'CanCheckout', includeIfNull: false)
    @Default(false) bool? canCheckout,

    @JsonKey(name: 'MinimumOrder', includeIfNull: false)
     MinimumOrderInfoDto? minimumOrder,

    @JsonKey(name: 'FreeShipping', includeIfNull: false)
     FreeShippingInfoDto? freeShipping,

    @JsonKey(name: 'CartSummary', includeIfNull: false)
     CartSummaryDto? cartSummary,

    @JsonKey(name: 'ValidationMessages', includeIfNull: false)
    @Default([]) List<String>? validationMessages
}) = _ShoppingCartInfoResponse;

  factory ShoppingCartInfoResponse.fromJson(Map<String, dynamic> json) =>
      _$ShoppingCartInfoResponseFromJson(json);
}