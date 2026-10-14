import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../common/user_field/user_field.dart';

part 'picture_model.freezed.dart';
part 'picture_model.g.dart';

@freezed
class PictureModel extends StoreJsonSerializable<PictureModel>
    with _$PictureModel {
  factory PictureModel(
      {@JsonKey(name: 'ImageUrl', includeIfNull: false) String? imageUrl,
      @JsonKey(name: 'ThumbImageUrl', includeIfNull: false)
      String? thumbImageUrl,
      @JsonKey(name: 'FullSizeImageUrl', includeIfNull: false)
      String? fullSizeImageUrl,
      @JsonKey(name: 'Title', includeIfNull: false) String? title,
      @JsonKey(name: 'AlternateText', includeIfNull: false)
      String? alternateText,
      @JsonKey(name: 'Style', includeIfNull: false) String? style,
      @JsonKey(name: 'ExtraField', includeIfNull: false) String? extraField,
      @JsonKey(name: 'Id', includeIfNull: false) String? id,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _PictureModel;

  factory PictureModel.fromJson(Map<String, dynamic> json) =>
      _$PictureModelFromJson(json);
}
