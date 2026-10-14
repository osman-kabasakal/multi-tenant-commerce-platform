import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

part 'anonymous_type__af73_d8_d8.freezed.dart';
part 'anonymous_type__af73_d8_d8.g.dart';

@freezed
class AnonymousType_AF73D8D8
    extends StoreJsonSerializable<AnonymousType_AF73D8D8>
    with _$AnonymousType_AF73D8D8 {
  factory AnonymousType_AF73D8D8(
          {@JsonKey(name: 'Available', includeIfNull: false)
          @Default(false)
          bool? available,
          @JsonKey(name: 'Text', includeIfNull: false) Object? text}) =
      _AnonymousType_AF73D8D8;

  factory AnonymousType_AF73D8D8.fromJson(Map<String, dynamic> json) =>
      _$AnonymousType_AF73D8D8FromJson(json);
}
