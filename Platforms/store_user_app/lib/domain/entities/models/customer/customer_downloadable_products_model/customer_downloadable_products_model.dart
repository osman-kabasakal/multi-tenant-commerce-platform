import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import 'downloadable_products_model/downloadable_products_model.dart';

import '../../../common/user_field/user_field.dart';

part 'customer_downloadable_products_model.freezed.dart';
part 'customer_downloadable_products_model.g.dart';

@freezed
class CustomerDownloadableProductsModel
    extends StoreJsonSerializable<CustomerDownloadableProductsModel>
    with _$CustomerDownloadableProductsModel {
  factory CustomerDownloadableProductsModel(
      {@JsonKey(name: 'Items', includeIfNull: false)
      @Default([])
      List<DownloadableProductsModel>? items,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _CustomerDownloadableProductsModel;

  factory CustomerDownloadableProductsModel.fromJson(
          Map<String, dynamic> json) =>
      _$CustomerDownloadableProductsModelFromJson(json);
}
