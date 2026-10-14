import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

part 'anonymous_type_10783450.freezed.dart';
part 'anonymous_type_10783450.g.dart';

@freezed
class AnonymousType_10783450
    extends StoreJsonSerializable<AnonymousType_10783450>
    with _$AnonymousType_10783450 {
  factory AnonymousType_10783450(
          {@JsonKey(name: 'Authenticated', includeIfNull: false)
          @Default(false)
          bool? authenticated,
          @JsonKey(name: 'Error', includeIfNull: false) String? error}) =
      _AnonymousType_10783450;

  factory AnonymousType_10783450.fromJson(Map<String, dynamic> json) =>
      _$AnonymousType_10783450FromJson(json);
}
