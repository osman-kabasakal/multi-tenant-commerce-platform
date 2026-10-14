import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../models/shopping_cart/shopping_cart_model/shopping_cart_model.dart';

part 'anonymous_type_845_badbc.freezed.dart';
part 'anonymous_type_845_badbc.g.dart';

@freezed
class AnonymousType_845BADBC
    extends StoreJsonSerializable<AnonymousType_845BADBC>
    with _$AnonymousType_845BADBC {
  factory AnonymousType_845BADBC(
      {@JsonKey(name: 'totalproducts', includeIfNull: false)
      String? totalproducts,
      @JsonKey(name: 'model', includeIfNull: false) ShoppingCartModel? model,
      @JsonKey(name: 'sidebarshoppingcartmodel', includeIfNull: false)
      Object? sidebarshoppingcartmodel}) = _AnonymousType_845BADBC;

  factory AnonymousType_845BADBC.fromJson(Map<String, dynamic> json) =>
      _$AnonymousType_845BADBCFromJson(json);
}
