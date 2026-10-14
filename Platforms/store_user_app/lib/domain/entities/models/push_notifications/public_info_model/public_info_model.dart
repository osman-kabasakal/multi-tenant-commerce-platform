import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/core/models/store_json_serializable.dart';

part 'public_info_model.freezed.dart';
part 'public_info_model.g.dart';

@freezed
class PushNotificationsPublicInfoModel extends StoreJsonSerializable<PushNotificationsPublicInfoModel>
    with _$PushNotificationsPublicInfoModel {
  const factory PushNotificationsPublicInfoModel({
    @JsonKey(name: 'SenderId') String? senderId,
    @JsonKey(name: 'PublicApiKey') String? publicApiKey,
    @JsonKey(name: 'AuthDomain') String? authDomain,
    @JsonKey(name: 'DatabaseUrl') String? databaseUrl,
    @JsonKey(name: 'ProjectId') String? projectId,
    @JsonKey(name: 'StorageBucket') String? storageBucket,
    @JsonKey(name: 'AppId') String? appId,
  }) = _PushNotificationsPublicInfoModel;

  factory PushNotificationsPublicInfoModel.fromJson(Map<String, dynamic> json) =>
      _$PushNotificationsPublicInfoModelFromJson(json);
}