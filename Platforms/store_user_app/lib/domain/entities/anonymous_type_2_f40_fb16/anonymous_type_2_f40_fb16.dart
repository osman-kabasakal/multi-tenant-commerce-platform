import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

part 'anonymous_type_2_f40_fb16.freezed.dart';
part 'anonymous_type_2_f40_fb16.g.dart';

@freezed
class AnonymousType_2F40FB16
    extends StoreJsonSerializable<AnonymousType_2F40FB16>
    with _$AnonymousType_2F40FB16 {
  factory AnonymousType_2F40FB16({
    @JsonKey(name: 'model', includeIfNull: false) Object? model,
    @JsonKey(name: 'Showcategories', includeIfNull: false)
    Object? showcategories,
  }) = _AnonymousType_2F40FB16;

  factory AnonymousType_2F40FB16.fromJson(Map<String, dynamic> json) =>
      _$AnonymousType_2F40FB16FromJson(json);
}

@freezed
class AnonymousModel extends StoreJsonSerializable<AnonymousModel>
    with _$AnonymousModel {
  factory AnonymousModel(
      {@JsonKey(name: 'Success', includeIfNull: false) Object? success,
      @JsonKey(name: 'Result', includeIfNull: false) Object? result,
      @JsonKey(name: 'ResultCategory', includeIfNull: false)
      Object? resultCategory}) = _AnonymousModel;

  factory AnonymousModel.fromJson(Map<String, dynamic> json) =>
      _$AnonymousModelFromJson(json);
}
