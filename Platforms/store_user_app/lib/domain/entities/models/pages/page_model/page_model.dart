import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../common/user_field/user_field.dart';

part 'page_model.freezed.dart';
part 'page_model.g.dart';

@freezed
class PageModel extends StoreJsonSerializable<PageModel> with _$PageModel {
  factory PageModel(
      {@JsonKey(name: 'SystemName', includeIfNull: false) String? systemName,
      @JsonKey(name: 'IncludeInSitemap', includeIfNull: false)
      @Default(false)
      bool? includeInSitemap,
      @JsonKey(name: 'IsPasswordProtected', includeIfNull: false)
      @Default(false)
      bool? isPasswordProtected,
      @JsonKey(name: 'Password', includeIfNull: false) String? password,
      @JsonKey(name: 'Title', includeIfNull: false) String? title,
      @JsonKey(name: 'Body', includeIfNull: false) String? body,
      @JsonKey(name: 'MetaKeywords', includeIfNull: false) String? metaKeywords,
      @JsonKey(name: 'MetaDescription', includeIfNull: false)
      String? metaDescription,
      @JsonKey(name: 'MetaTitle', includeIfNull: false) String? metaTitle,
      @JsonKey(name: 'SeName', includeIfNull: false) String? seName,
      @JsonKey(name: 'PageLayoutId', includeIfNull: false) String? pageLayoutId,
      @JsonKey(name: 'Published', includeIfNull: false)
      @Default(false)
      bool? published,
      @JsonKey(name: 'StartDate', includeIfNull: false)
      @Default(null)
      DateTime? startDate,
      @JsonKey(name: 'EndDate', includeIfNull: false)
      @Default(null)
      DateTime? endDate,
      @JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _PageModel;

  factory PageModel.fromJson(Map<String, dynamic> json) =>
      _$PageModelFromJson(json);
}
