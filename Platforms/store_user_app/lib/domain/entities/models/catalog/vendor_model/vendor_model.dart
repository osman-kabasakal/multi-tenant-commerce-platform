import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../vendors/vendor_address_model/vendor_address_model.dart';

import '../../media/picture_model/picture_model.dart';

import '../catalog_paging_filtering_model/catalog_paging_filtering_model.dart';

import '../../vendors/vendor_review_overview_model/vendor_review_overview_model.dart';

import '../product_overview_model/product_overview_model.dart';

import '../../../common/user_field/user_field.dart';

part 'vendor_model.freezed.dart';
part 'vendor_model.g.dart';

@freezed
class VendorModel extends StoreJsonSerializable<VendorModel>
    with _$VendorModel {
  factory VendorModel(
      {@JsonKey(name: 'Name', includeIfNull: false) String? name,
      @JsonKey(name: 'Description', includeIfNull: false) String? description,
      @JsonKey(name: 'MetaKeywords', includeIfNull: false) String? metaKeywords,
      @JsonKey(name: 'MetaDescription', includeIfNull: false)
      String? metaDescription,
      @JsonKey(name: 'MetaTitle', includeIfNull: false) String? metaTitle,
      @JsonKey(name: 'SeName', includeIfNull: false) String? seName,
      @JsonKey(name: 'AllowCustomersToContactVendors', includeIfNull: false)
      @Default(false)
      bool? allowCustomersToContactVendors,
      @JsonKey(name: 'RenderCaptcha', includeIfNull: false)
      @Default(false)
      bool? renderCaptcha,
      @JsonKey(name: 'Address', includeIfNull: false)
      VendorAddressModel? address,
      @JsonKey(name: 'PictureModel', includeIfNull: false)
      PictureModel? pictureModel,
      @JsonKey(name: 'PagingFilteringContext', includeIfNull: false)
      CatalogPagingFilteringModel? pagingFilteringContext,
      @JsonKey(name: 'VendorReviewOverview', includeIfNull: false)
      VendorReviewOverviewModel? vendorReviewOverview,
      @JsonKey(name: 'Products', includeIfNull: false)
      @Default([])
      List<ProductOverviewModel>? products,
      @JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _VendorModel;

  factory VendorModel.fromJson(Map<String, dynamic> json) =>
      _$VendorModelFromJson(json);
}
