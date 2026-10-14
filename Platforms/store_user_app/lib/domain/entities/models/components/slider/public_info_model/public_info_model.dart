import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../../common/user_field/user_field.dart';
import 'slider/slider.dart';

part 'public_info_model.freezed.dart';
part 'public_info_model.g.dart';

@freezed
class PublicInfoModel extends StoreJsonSerializable<PublicInfoModel>
    with _$PublicInfoModel {
  const factory PublicInfoModel({
    @JsonKey(name: 'Slide', includeIfNull: false)
    @Default([])
    List<Slider>? slide,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    @Default([])
    List<UserField>? userFields,
  }) = _PublicInfoModel;

  factory PublicInfoModel.fromJson(Map<String, dynamic> json) =>
      _$PublicInfoModelFromJson(json);
}
