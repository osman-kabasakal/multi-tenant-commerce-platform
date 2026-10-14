import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

part 'anonymous_type_5_f706788.freezed.dart';
part 'anonymous_type_5_f706788.g.dart';

@freezed
class AnonymousType_5F706788
    extends StoreJsonSerializable<AnonymousType_5F706788>
    with _$AnonymousType_5F706788 {
  factory AnonymousType_5F706788({
    @JsonKey(name: 'success', includeIfNull: false)
    @Default(false)
    bool? success,
    @JsonKey(name: 'downloadGuid', includeIfNull: false) String? downloadGuid,
    @Default(null) String? downloadUrl,
    @Default(null) String? message,
  }) = _AnonymousType_5F706788;

  factory AnonymousType_5F706788.fromJson(Map<String, dynamic> json) =>
      _$AnonymousType_5F706788FromJson(json);
}
