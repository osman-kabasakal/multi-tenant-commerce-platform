import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

part 'anonymous_type_343_f9_e63.freezed.dart';
part 'anonymous_type_343_f9_e63.g.dart';

@freezed
class AnonymousType_343F9E63
    extends StoreJsonSerializable<AnonymousType_343F9E63>
    with _$AnonymousType_343F9E63 {
  factory AnonymousType_343F9E63(
          {@JsonKey(name: 'html', includeIfNull: false) String? html}) =
      _AnonymousType_343F9E63;

  factory AnonymousType_343F9E63.fromJson(Map<String, dynamic> json) =>
      _$AnonymousType_343F9E63FromJson(json);
}
