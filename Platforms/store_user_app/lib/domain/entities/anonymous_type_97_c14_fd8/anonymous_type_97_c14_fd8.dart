import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../models/catalog/product_details_model/product_details_model.dart';

part 'anonymous_type_97_c14_fd8.freezed.dart';
part 'anonymous_type_97_c14_fd8.g.dart';

@freezed
class AnonymousType_97C14FD8
    extends StoreJsonSerializable<AnonymousType_97C14FD8>
    with _$AnonymousType_97C14FD8 {
  factory AnonymousType_97C14FD8(
      {@JsonKey(name: 'success', includeIfNull: false)
      @Default(false)
      bool? success,
      @JsonKey(name: 'message', includeIfNull: false) String? message,
      @JsonKey(name: 'product', includeIfNull: false) bool? product,
      @JsonKey(name: 'model', includeIfNull: false)
      ProductDetailsModel? model}) = _AnonymousType_97C14FD8;

  factory AnonymousType_97C14FD8.fromJson(Map<String, dynamic> json) =>
      _$AnonymousType_97C14FD8FromJson(json);
}
