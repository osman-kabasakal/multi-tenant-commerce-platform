import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

part 'anonymous_type_84_f04_ecc.freezed.dart';
part 'anonymous_type_84_f04_ecc.g.dart';

@freezed
class AnonymousType_84F04ECC
    extends StoreJsonSerializable<AnonymousType_84F04ECC>
    with _$AnonymousType_84F04ECC {
  factory AnonymousType_84F04ECC(
      {@JsonKey(name: 'enabledattributeids', includeIfNull: false)
      Object? enabledattributeids,
      @JsonKey(name: 'disabledattributeids', includeIfNull: false)
      Object? disabledattributeids}) = _AnonymousType_84F04ECC;

  factory AnonymousType_84F04ECC.fromJson(Map<String, dynamic> json) =>
      _$AnonymousType_84F04ECCFromJson(json);
}
