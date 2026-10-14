import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';


part 'state_province_model.freezed.dart';
part 'state_province_model.g.dart';

@freezed
class StateProvinceModel extends StoreJsonSerializable<StateProvinceModel> with _$StateProvinceModel {
  factory StateProvinceModel({ 
    @JsonKey(name: 'id', includeIfNull: false)
     String? id,

    @JsonKey(name: 'name', includeIfNull: false)
     String? name
}) = _StateProvinceModel;

  factory StateProvinceModel.fromJson(Map<String, dynamic> json) =>
      _$StateProvinceModelFromJson(json);
}