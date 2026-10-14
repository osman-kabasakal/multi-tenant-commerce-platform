import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../category_simple_model/category_simple_model.dart';

import '../../../../common/user_field/user_field.dart';

part 'product_breadcrumb_model.freezed.dart';
part 'product_breadcrumb_model.g.dart';

@freezed
class ProductBreadcrumbModel
    extends StoreJsonSerializable<ProductBreadcrumbModel>
    with _$ProductBreadcrumbModel {
  factory ProductBreadcrumbModel(
      {@JsonKey(name: 'Id', includeIfNull: false) int? id,
      @JsonKey(name: 'Enabled', includeIfNull: false)
      @Default(false)
      bool? enabled,
      @JsonKey(name: 'ProductId', includeIfNull: false) String? productId,
      @JsonKey(name: 'ProductName', includeIfNull: false) String? productName,
      @JsonKey(name: 'ProductSeName', includeIfNull: false)
      String? productSeName,
      @JsonKey(name: 'CategoryBreadcrumb', includeIfNull: false)
      @Default([])
      List<CategorySimpleModel>? categoryBreadcrumb,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _ProductBreadcrumbModel;

  factory ProductBreadcrumbModel.fromJson(Map<String, dynamic> json) =>
      _$ProductBreadcrumbModelFromJson(json);
}
