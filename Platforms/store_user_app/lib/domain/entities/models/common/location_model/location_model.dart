import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

import '../../../common/user_field/user_field.dart';

part 'location_model.freezed.dart';
part 'location_model.g.dart';

@freezed
class LocationModel extends StoreJsonSerializable<LocationModel>
    with _$LocationModel {
  factory LocationModel(
      {@JsonKey(name: 'Latitude', includeIfNull: false) double? latitude,
      @JsonKey(name: 'Longitude', includeIfNull: false) double? longitude,
      @JsonKey(name: 'UserFields', includeIfNull: false)
      @Default([])
      List<UserField>? userFields}) = _LocationModel;

  factory LocationModel.fromJson(Map<String, dynamic> json) =>
      _$LocationModelFromJson(json);
}
