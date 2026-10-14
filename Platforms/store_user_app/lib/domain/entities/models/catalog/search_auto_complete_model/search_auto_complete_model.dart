import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

part 'search_auto_complete_model.freezed.dart';
part 'search_auto_complete_model.g.dart';

@freezed
class SearchAutoCompleteModel
    extends StoreJsonSerializable<SearchAutoCompleteModel>
    with _$SearchAutoCompleteModel {
  factory SearchAutoCompleteModel(
      {@JsonKey(name: 'SearchType', includeIfNull: false) String? searchType,
      @JsonKey(name: 'Label', includeIfNull: false) String? label,
      @JsonKey(name: 'Url', includeIfNull: false) String? url,
      @JsonKey(name: 'Desc', includeIfNull: false) String? desc,
      @JsonKey(name: 'Price', includeIfNull: false) String? price,
      @JsonKey(name: 'PriceWithDiscount', includeIfNull: false)
      String? priceWithDiscount,
      @JsonKey(name: 'AllowCustomerReviews', includeIfNull: false)
      @Default(false)
      bool? allowCustomerReviews,
      @JsonKey(name: 'Rating', includeIfNull: false) double? rating,
      @JsonKey(name: 'PictureUrl', includeIfNull: false)
      String? pictureUrl}) = _SearchAutoCompleteModel;

  factory SearchAutoCompleteModel.fromJson(Map<String, dynamic> json) =>
      _$SearchAutoCompleteModelFromJson(json);
}
