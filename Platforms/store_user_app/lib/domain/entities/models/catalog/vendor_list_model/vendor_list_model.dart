import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../vendor_paging_model/vendor_paging_model.dart';

import '../vendor_model/vendor_model.dart';

part 'vendor_list_model.freezed.dart';
part 'vendor_list_model.g.dart';

@freezed
class VendorListModel extends StoreJsonSerializable<VendorListModel>
    with _$VendorListModel {
  factory VendorListModel(
      {@JsonKey(name: 'PagingModel', includeIfNull: false)
      VendorPagingModel? pagingModel,
      @JsonKey(name: 'VendorsModel', includeIfNull: false)
      @Default([])
      List<VendorModel>? vendorsModel}) = _VendorListModel;

  factory VendorListModel.fromJson(Map<String, dynamic> json) =>
      _$VendorListModelFromJson(json);
}
