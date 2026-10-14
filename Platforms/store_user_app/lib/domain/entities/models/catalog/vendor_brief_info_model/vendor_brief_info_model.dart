import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../common/user_field/user_field.dart';

part 'vendor_brief_info_model.freezed.dart';
part 'vendor_brief_info_model.g.dart';

@freezed
class VendorBriefInfoModel extends StoreJsonSerializable<VendorBriefInfoModel>
    with _$VendorBriefInfoModel {
  factory VendorBriefInfoModel(
      {@JsonKey(name: 'Name', includeIfNull: false) String? name,
      @JsonKey(name: 'SeName', includeIfNull: false) String? seName,
      @JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _VendorBriefInfoModel;

  factory VendorBriefInfoModel.fromJson(Map<String, dynamic> json) =>
      _$VendorBriefInfoModelFromJson(json);
}
