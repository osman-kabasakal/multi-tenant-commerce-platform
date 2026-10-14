import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

part 'anonymous_type__f96_d6_eb9.freezed.dart';
part 'anonymous_type__f96_d6_eb9.g.dart';

@freezed
class AnonymousType_F96D6EB9
    extends StoreJsonSerializable<AnonymousType_F96D6EB9>
    with _$AnonymousType_F96D6EB9 {
  factory AnonymousType_F96D6EB9(
      {@JsonKey(name: 'model', includeIfNull: false) Object? model,
      @JsonKey(name: 'sidebarshoppingcartmodel', includeIfNull: false)
      Object? sidebarshoppingcartmodel}) = _AnonymousType_F96D6EB9;

  factory AnonymousType_F96D6EB9.fromJson(Map<String, dynamic> json) =>
      _$AnonymousType_F96D6EB9FromJson(json);
}
