import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

part 'anonymous_type_03_ad2_c00.freezed.dart';
part 'anonymous_type_03_ad2_c00.g.dart';

@freezed
class AnonymousType_03AD2C00
    extends StoreJsonSerializable<AnonymousType_03AD2C00>
    with _$AnonymousType_03AD2C00 {
  factory AnonymousType_03AD2C00(
      {@JsonKey(name: 'success', includeIfNull: false)
      @Default(false)
      bool? success}) = _AnonymousType_03AD2C00;

  factory AnonymousType_03AD2C00.fromJson(Map<String, dynamic> json) =>
      _$AnonymousType_03AD2C00FromJson(json);
}
