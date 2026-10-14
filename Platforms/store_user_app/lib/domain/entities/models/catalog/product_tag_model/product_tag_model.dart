import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../common/user_field/user_field.dart';

part 'product_tag_model.freezed.dart';
part 'product_tag_model.g.dart';

@freezed
class ProductTagModel extends StoreJsonSerializable<ProductTagModel>
    with _$ProductTagModel {
  factory ProductTagModel(
      {@JsonKey(name: 'Name', includeIfNull: false) String? name,
      @JsonKey(name: 'SeName', includeIfNull: false) String? seName,
      @JsonKey(name: 'ProductCount', includeIfNull: false) int? productCount,
      @JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _ProductTagModel;

  factory ProductTagModel.fromJson(Map<String, dynamic> json) =>
      _$ProductTagModelFromJson(json);
}
