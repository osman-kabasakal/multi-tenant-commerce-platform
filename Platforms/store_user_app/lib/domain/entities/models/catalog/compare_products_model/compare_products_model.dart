import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../product_overview_model/product_overview_model.dart';

import '../../../common/user_field/user_field.dart';

part 'compare_products_model.freezed.dart';
part 'compare_products_model.g.dart';

@freezed
class CompareProductsModel extends StoreJsonSerializable<CompareProductsModel>
    with _$CompareProductsModel {
  factory CompareProductsModel(
      {@JsonKey(name: 'Products', includeIfNull: false)
      @Default([])
      List<ProductOverviewModel>? products,
      @JsonKey(
          name: 'IncludeShortDescriptionInCompareProducts',
          includeIfNull: false)
      @Default(false)
      bool? includeShortDescriptionInCompareProducts,
      @JsonKey(
          name: 'IncludeFullDescriptionInCompareProducts', includeIfNull: false)
      @Default(false)
      bool? includeFullDescriptionInCompareProducts,
      @JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _CompareProductsModel;

  factory CompareProductsModel.fromJson(Map<String, dynamic> json) =>
      _$CompareProductsModelFromJson(json);
}
