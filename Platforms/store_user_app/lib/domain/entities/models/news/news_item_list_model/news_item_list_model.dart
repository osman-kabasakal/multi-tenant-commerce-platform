import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../news_paging_filtering_model/news_paging_filtering_model.dart';

import 'news_item_model/news_item_model.dart';

import '../../../common/user_field/user_field.dart';

part 'news_item_list_model.freezed.dart';
part 'news_item_list_model.g.dart';

@freezed
class NewsItemListModel extends StoreJsonSerializable<NewsItemListModel>
    with _$NewsItemListModel {
  factory NewsItemListModel(
      {@JsonKey(name: 'WorkingLanguageId', includeIfNull: false)
      String? workingLanguageId,
      @JsonKey(name: 'PagingFilteringContext', includeIfNull: false)
      NewsPagingFilteringModel? pagingFilteringContext,
      @JsonKey(name: 'NewsItems', includeIfNull: false)
      @Default([])
      List<NewsItemModel>? newsItems,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _NewsItemListModel;

  factory NewsItemListModel.fromJson(Map<String, dynamic> json) =>
      _$NewsItemListModelFromJson(json);
}
