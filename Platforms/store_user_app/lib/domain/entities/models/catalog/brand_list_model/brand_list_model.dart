import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../brand_paging_model/brand_paging_model.dart';

import '../brand_model/brand_model.dart';

part 'brand_list_model.freezed.dart';
part 'brand_list_model.g.dart';

@freezed
class BrandListModel extends StoreJsonSerializable<BrandListModel>
    with _$BrandListModel {
  factory BrandListModel(
      {@JsonKey(name: 'PagingModel', includeIfNull: false)
      BrandPagingModel? pagingModel,
      @JsonKey(name: 'BrandsModel', includeIfNull: false)
      @Default([])
      List<BrandModel>? brandsModel}) = _BrandListModel;

  factory BrandListModel.fromJson(Map<String, dynamic> json) =>
      _$BrandListModelFromJson(json);
}
