import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

part 'anonymous_type__fa6_c6_c9_f.freezed.dart';
part 'anonymous_type__fa6_c6_c9_f.g.dart';

@freezed
class AnonymousType_FA6C6C9F
    extends StoreJsonSerializable<AnonymousType_FA6C6C9F>
    with _$AnonymousType_FA6C6C9F {
  factory AnonymousType_FA6C6C9F({
    @JsonKey(name: 'redirect', includeIfNull: false) Object? redirect,
    @JsonKey(name: 'success', includeIfNull: false) bool? success,
    @JsonKey(name: 'message', includeIfNull: false) dynamic message,
  }) = _AnonymousType_FA6C6C9F;

  factory AnonymousType_FA6C6C9F.fromJson(Map<String, dynamic> json) =>
      _$AnonymousType_FA6C6C9FFromJson(json);
}
