import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../models/shopping_cart/shopping_cart_model/shopping_cart_model.dart';

part 'anonymous_type_6_f488518.freezed.dart';
part 'anonymous_type_6_f488518.g.dart';

@freezed
class AnonymousType_6F488518
    extends StoreJsonSerializable<AnonymousType_6F488518>
    with _$AnonymousType_6F488518 {
  factory AnonymousType_6F488518(
      {@JsonKey(name: 'success', includeIfNull: false)
      @Default(false)
      bool? success,
      @JsonKey(name: 'model', includeIfNull: false) ShoppingCartModel? model,
      @JsonKey(name: 'warnings', includeIfNull: false)
      String? warnings}) = _AnonymousType_6F488518;

  factory AnonymousType_6F488518.fromJson(Map<String, dynamic> json) =>
      _$AnonymousType_6F488518FromJson(json);
}
