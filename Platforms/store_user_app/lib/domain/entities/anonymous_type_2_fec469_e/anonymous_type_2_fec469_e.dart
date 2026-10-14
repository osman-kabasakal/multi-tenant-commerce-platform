import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

part 'anonymous_type_2_fec469_e.freezed.dart';
part 'anonymous_type_2_fec469_e.g.dart';

@freezed
class AnonymousType_2FEC469E
    extends StoreJsonSerializable<AnonymousType_2FEC469E>
    with _$AnonymousType_2FEC469E {
  factory AnonymousType_2FEC469E(
      {@JsonKey(name: 'success', includeIfNull: false)
      @Default(false)
      bool? success,
      @JsonKey(name: 'warnings', includeIfNull: false) String? warnings,
      @JsonKey(name: 'totalproducts', includeIfNull: false)
      int? totalproducts}) = _AnonymousType_2FEC469E;

  factory AnonymousType_2FEC469E.fromJson(Map<String, dynamic> json) =>
      _$AnonymousType_2FEC469EFromJson(json);
}
