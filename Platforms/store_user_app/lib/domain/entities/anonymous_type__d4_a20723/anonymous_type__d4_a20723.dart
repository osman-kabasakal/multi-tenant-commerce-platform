import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

part 'anonymous_type__d4_a20723.freezed.dart';
part 'anonymous_type__d4_a20723.g.dart';

@freezed
class AnonymousType_D4A20723
    extends StoreJsonSerializable<AnonymousType_D4A20723>
    with _$AnonymousType_D4A20723 {
  factory AnonymousType_D4A20723(
          {@JsonKey(name: 'Success', includeIfNull: false) Object? success,
          @JsonKey(name: 'Message', includeIfNull: false) Object? message}) =
      _AnonymousType_D4A20723;

  factory AnonymousType_D4A20723.fromJson(Map<String, dynamic> json) =>
      _$AnonymousType_D4A20723FromJson(json);
}
