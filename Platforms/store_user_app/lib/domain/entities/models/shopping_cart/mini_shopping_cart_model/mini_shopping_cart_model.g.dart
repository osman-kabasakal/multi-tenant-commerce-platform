// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mini_shopping_cart_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MiniShoppingCartModelImpl _$$MiniShoppingCartModelImplFromJson(
  Map<String, dynamic> json,
) => _$MiniShoppingCartModelImpl(
  items:
      (json['Items'] as List<dynamic>?)
          ?.map(
            (e) => ShoppingCartItemModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  totalProducts: (json['TotalProducts'] as num?)?.toInt(),
  subTotal: json['SubTotal'] as String?,
  subTotalIncludingTax: json['SubTotalIncludingTax'] as bool? ?? false,
  displayShoppingCartButton:
      json['DisplayShoppingCartButton'] as bool? ?? false,
  displayCheckoutButton: json['DisplayCheckoutButton'] as bool? ?? false,
  currentCustomerIsGuest: json['CurrentCustomerIsGuest'] as bool? ?? false,
  anonymousCheckoutAllowed: json['AnonymousCheckoutAllowed'] as bool? ?? false,
  showProductImages: json['ShowProductImages'] as bool? ?? false,
  userFields:
      (json['UserFields'] as List<dynamic>?)
          ?.map((e) => UserField.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$MiniShoppingCartModelImplToJson(
  _$MiniShoppingCartModelImpl instance,
) => <String, dynamic>{
  if (instance.items case final value?) 'Items': value,
  if (instance.totalProducts case final value?) 'TotalProducts': value,
  if (instance.subTotal case final value?) 'SubTotal': value,
  if (instance.subTotalIncludingTax case final value?)
    'SubTotalIncludingTax': value,
  if (instance.displayShoppingCartButton case final value?)
    'DisplayShoppingCartButton': value,
  if (instance.displayCheckoutButton case final value?)
    'DisplayCheckoutButton': value,
  if (instance.currentCustomerIsGuest case final value?)
    'CurrentCustomerIsGuest': value,
  if (instance.anonymousCheckoutAllowed case final value?)
    'AnonymousCheckoutAllowed': value,
  if (instance.showProductImages case final value?) 'ShowProductImages': value,
  if (instance.userFields case final value?) 'UserFields': value,
};
