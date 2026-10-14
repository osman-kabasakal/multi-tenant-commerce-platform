import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../collection_paging_model/collection_paging_model.dart';

import '../collection_model/collection_model.dart';

part 'collection_list_model.freezed.dart';
part 'collection_list_model.g.dart';

@freezed
class CollectionListModel extends StoreJsonSerializable<CollectionListModel>
    with _$CollectionListModel {
  factory CollectionListModel(
      {@JsonKey(name: 'PagingModel', includeIfNull: false)
      CollectionPagingModel? pagingModel,
      @JsonKey(name: 'CollectionModel', includeIfNull: false)
      @Default([])
      List<CollectionModel>? collectionModel}) = _CollectionListModel;

  factory CollectionListModel.fromJson(Map<String, dynamic> json) =>
      _$CollectionListModelFromJson(json);
}
