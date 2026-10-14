import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../models/shopping_cart/shopping_cart_model/shopping_cart_model.dart';

part 'anonymous_type__ef661507.freezed.dart';
part 'anonymous_type__ef661507.g.dart';

@freezed
class AnonymousType_EF661507
    extends StoreJsonSerializable<AnonymousType_EF661507>
    with _$AnonymousType_EF661507 {
  factory AnonymousType_EF661507(
      {@JsonKey(name: 'model', includeIfNull: false)
      ShoppingCartModel? model}) = _AnonymousType_EF661507;

  factory AnonymousType_EF661507.fromJson(Map<String, dynamic> json) =>
      _$AnonymousType_EF661507FromJson(json);
}
