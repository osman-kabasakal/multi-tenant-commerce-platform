import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

part 'anonymous_type__f3_e1_e574.freezed.dart';
part 'anonymous_type__f3_e1_e574.g.dart';

@freezed
class AnonymousType_F3E1E574
    extends StoreJsonSerializable<AnonymousType_F3E1E574>
    with _$AnonymousType_F3E1E574 {
  factory AnonymousType_F3E1E574(
          {@JsonKey(name: 'subscribe', includeIfNull: false)
          @Default(false)
          bool? subscribe,
          @JsonKey(name: 'buttontext', includeIfNull: false) String? buttontext,
          @JsonKey(name: 'resource', includeIfNull: false) String? resource}) =
      _AnonymousType_F3E1E574;

  factory AnonymousType_F3E1E574.fromJson(Map<String, dynamic> json) =>
      _$AnonymousType_F3E1E574FromJson(json);
}
