import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../../common/user_field/user_field.dart';

part 'downloadable_products_model.freezed.dart';
part 'downloadable_products_model.g.dart';

@freezed
class DownloadableProductsModel
    extends StoreJsonSerializable<DownloadableProductsModel>
    with _$DownloadableProductsModel {
  factory DownloadableProductsModel(
      {@JsonKey(name: 'OrderItemGuid', includeIfNull: false)
      String? orderItemGuid,
      @JsonKey(name: 'OrderId', includeIfNull: false) String? orderId,
      @JsonKey(name: 'OrderNumber', includeIfNull: false) int? orderNumber,
      @JsonKey(name: 'ProductId', includeIfNull: false) String? productId,
      @JsonKey(name: 'ProductName', includeIfNull: false) String? productName,
      @JsonKey(name: 'ProductSeName', includeIfNull: false)
      String? productSeName,
      @JsonKey(name: 'ProductAttributes', includeIfNull: false)
      String? productAttributes,
      @JsonKey(name: 'DownloadId', includeIfNull: false) String? downloadId,
      @JsonKey(name: 'LicenseId', includeIfNull: false) String? licenseId,
      @JsonKey(name: 'CreatedOn', includeIfNull: false) DateTime? createdOn,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _DownloadableProductsModel;

  factory DownloadableProductsModel.fromJson(Map<String, dynamic> json) =>
      _$DownloadableProductsModelFromJson(json);
}
