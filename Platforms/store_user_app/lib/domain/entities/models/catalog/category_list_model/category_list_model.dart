import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../category_paging_model/category_paging_model.dart';

import '../category_model/category_model.dart';

part 'category_list_model.freezed.dart';
part 'category_list_model.g.dart';

@freezed
class CategoryListModel extends StoreJsonSerializable<CategoryListModel>
    with _$CategoryListModel {
  factory CategoryListModel(
      {@JsonKey(name: 'PagingModel', includeIfNull: false)
      CategoryPagingModel? pagingModel,
      @JsonKey(name: 'CategoriesModel', includeIfNull: false)
      @Default([])
      List<CategoryModel>? categoriesModel}) = _CategoryListModel;

  factory CategoryListModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryListModelFromJson(json);
}
