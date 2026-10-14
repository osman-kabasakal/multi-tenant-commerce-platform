import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../common/user_field/user_field.dart';

part 'brand_brief_info_model.freezed.dart';
part 'brand_brief_info_model.g.dart';

@freezed
class BrandBriefInfoModel extends StoreJsonSerializable<BrandBriefInfoModel>
    with _$BrandBriefInfoModel {
  factory BrandBriefInfoModel(
      {@JsonKey(name: 'Name', includeIfNull: false) String? name,
      @JsonKey(name: 'SeName', includeIfNull: false) String? seName,
      @JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _BrandBriefInfoModel;

  factory BrandBriefInfoModel.fromJson(Map<String, dynamic> json) =>
      _$BrandBriefInfoModelFromJson(json);
}
