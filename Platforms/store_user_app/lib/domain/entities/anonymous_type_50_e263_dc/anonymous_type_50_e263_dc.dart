import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

part 'anonymous_type_50_e263_dc.freezed.dart';
part 'anonymous_type_50_e263_dc.g.dart';

@freezed
class AnonymousType_50E263DC
    extends StoreJsonSerializable<AnonymousType_50E263DC>
    with _$AnonymousType_50E263DC {
  factory AnonymousType_50E263DC(
      {@JsonKey(name: 'redirect', includeIfNull: false) Object? redirect,
      @JsonKey(name: 'success', includeIfNull: false)
      @Default(false)
      bool? success}) = _AnonymousType_50E263DC;

  factory AnonymousType_50E263DC.fromJson(Map<String, dynamic> json) =>
      _$AnonymousType_50E263DCFromJson(json);
}
