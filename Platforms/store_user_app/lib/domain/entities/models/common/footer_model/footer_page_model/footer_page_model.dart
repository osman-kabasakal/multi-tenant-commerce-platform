import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../../common/user_field/user_field.dart';

part 'footer_page_model.freezed.dart';
part 'footer_page_model.g.dart';

@freezed
class FooterPageModel extends StoreJsonSerializable<FooterPageModel>
    with _$FooterPageModel {
  factory FooterPageModel(
      {@JsonKey(name: 'Name', includeIfNull: false) String? name,
      @JsonKey(name: 'SeName', includeIfNull: false) String? seName,
      @JsonKey(name: 'IncludeInFooterRow1', includeIfNull: false)
      @Default(false)
      bool? includeInFooterRow1,
      @JsonKey(name: 'IncludeInFooterRow2', includeIfNull: false)
      @Default(false)
      bool? includeInFooterRow2,
      @JsonKey(name: 'IncludeInFooterRow3', includeIfNull: false)
      @Default(false)
      bool? includeInFooterRow3,
      @JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _FooterPageModel;

  factory FooterPageModel.fromJson(Map<String, dynamic> json) =>
      _$FooterPageModelFromJson(json);
}
