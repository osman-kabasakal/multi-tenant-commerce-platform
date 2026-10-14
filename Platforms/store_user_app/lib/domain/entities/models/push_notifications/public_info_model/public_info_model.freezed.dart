// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'public_info_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PushNotificationsPublicInfoModel _$PushNotificationsPublicInfoModelFromJson(
  Map<String, dynamic> json,
) {
  return _PushNotificationsPublicInfoModel.fromJson(json);
}

/// @nodoc
mixin _$PushNotificationsPublicInfoModel {
  @JsonKey(name: 'SenderId')
  String? get senderId => throw _privateConstructorUsedError;
  @JsonKey(name: 'PublicApiKey')
  String? get publicApiKey => throw _privateConstructorUsedError;
  @JsonKey(name: 'AuthDomain')
  String? get authDomain => throw _privateConstructorUsedError;
  @JsonKey(name: 'DatabaseUrl')
  String? get databaseUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'ProjectId')
  String? get projectId => throw _privateConstructorUsedError;
  @JsonKey(name: 'StorageBucket')
  String? get storageBucket => throw _privateConstructorUsedError;
  @JsonKey(name: 'AppId')
  String? get appId => throw _privateConstructorUsedError;

  /// Serializes this PushNotificationsPublicInfoModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PushNotificationsPublicInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PushNotificationsPublicInfoModelCopyWith<PushNotificationsPublicInfoModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PushNotificationsPublicInfoModelCopyWith<$Res> {
  factory $PushNotificationsPublicInfoModelCopyWith(
    PushNotificationsPublicInfoModel value,
    $Res Function(PushNotificationsPublicInfoModel) then,
  ) =
      _$PushNotificationsPublicInfoModelCopyWithImpl<
        $Res,
        PushNotificationsPublicInfoModel
      >;
  @useResult
  $Res call({
    @JsonKey(name: 'SenderId') String? senderId,
    @JsonKey(name: 'PublicApiKey') String? publicApiKey,
    @JsonKey(name: 'AuthDomain') String? authDomain,
    @JsonKey(name: 'DatabaseUrl') String? databaseUrl,
    @JsonKey(name: 'ProjectId') String? projectId,
    @JsonKey(name: 'StorageBucket') String? storageBucket,
    @JsonKey(name: 'AppId') String? appId,
  });
}

/// @nodoc
class _$PushNotificationsPublicInfoModelCopyWithImpl<
  $Res,
  $Val extends PushNotificationsPublicInfoModel
>
    implements $PushNotificationsPublicInfoModelCopyWith<$Res> {
  _$PushNotificationsPublicInfoModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PushNotificationsPublicInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? senderId = freezed,
    Object? publicApiKey = freezed,
    Object? authDomain = freezed,
    Object? databaseUrl = freezed,
    Object? projectId = freezed,
    Object? storageBucket = freezed,
    Object? appId = freezed,
  }) {
    return _then(
      _value.copyWith(
            senderId:
                freezed == senderId
                    ? _value.senderId
                    : senderId // ignore: cast_nullable_to_non_nullable
                        as String?,
            publicApiKey:
                freezed == publicApiKey
                    ? _value.publicApiKey
                    : publicApiKey // ignore: cast_nullable_to_non_nullable
                        as String?,
            authDomain:
                freezed == authDomain
                    ? _value.authDomain
                    : authDomain // ignore: cast_nullable_to_non_nullable
                        as String?,
            databaseUrl:
                freezed == databaseUrl
                    ? _value.databaseUrl
                    : databaseUrl // ignore: cast_nullable_to_non_nullable
                        as String?,
            projectId:
                freezed == projectId
                    ? _value.projectId
                    : projectId // ignore: cast_nullable_to_non_nullable
                        as String?,
            storageBucket:
                freezed == storageBucket
                    ? _value.storageBucket
                    : storageBucket // ignore: cast_nullable_to_non_nullable
                        as String?,
            appId:
                freezed == appId
                    ? _value.appId
                    : appId // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PushNotificationsPublicInfoModelImplCopyWith<$Res>
    implements $PushNotificationsPublicInfoModelCopyWith<$Res> {
  factory _$$PushNotificationsPublicInfoModelImplCopyWith(
    _$PushNotificationsPublicInfoModelImpl value,
    $Res Function(_$PushNotificationsPublicInfoModelImpl) then,
  ) = __$$PushNotificationsPublicInfoModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'SenderId') String? senderId,
    @JsonKey(name: 'PublicApiKey') String? publicApiKey,
    @JsonKey(name: 'AuthDomain') String? authDomain,
    @JsonKey(name: 'DatabaseUrl') String? databaseUrl,
    @JsonKey(name: 'ProjectId') String? projectId,
    @JsonKey(name: 'StorageBucket') String? storageBucket,
    @JsonKey(name: 'AppId') String? appId,
  });
}

/// @nodoc
class __$$PushNotificationsPublicInfoModelImplCopyWithImpl<$Res>
    extends
        _$PushNotificationsPublicInfoModelCopyWithImpl<
          $Res,
          _$PushNotificationsPublicInfoModelImpl
        >
    implements _$$PushNotificationsPublicInfoModelImplCopyWith<$Res> {
  __$$PushNotificationsPublicInfoModelImplCopyWithImpl(
    _$PushNotificationsPublicInfoModelImpl _value,
    $Res Function(_$PushNotificationsPublicInfoModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PushNotificationsPublicInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? senderId = freezed,
    Object? publicApiKey = freezed,
    Object? authDomain = freezed,
    Object? databaseUrl = freezed,
    Object? projectId = freezed,
    Object? storageBucket = freezed,
    Object? appId = freezed,
  }) {
    return _then(
      _$PushNotificationsPublicInfoModelImpl(
        senderId:
            freezed == senderId
                ? _value.senderId
                : senderId // ignore: cast_nullable_to_non_nullable
                    as String?,
        publicApiKey:
            freezed == publicApiKey
                ? _value.publicApiKey
                : publicApiKey // ignore: cast_nullable_to_non_nullable
                    as String?,
        authDomain:
            freezed == authDomain
                ? _value.authDomain
                : authDomain // ignore: cast_nullable_to_non_nullable
                    as String?,
        databaseUrl:
            freezed == databaseUrl
                ? _value.databaseUrl
                : databaseUrl // ignore: cast_nullable_to_non_nullable
                    as String?,
        projectId:
            freezed == projectId
                ? _value.projectId
                : projectId // ignore: cast_nullable_to_non_nullable
                    as String?,
        storageBucket:
            freezed == storageBucket
                ? _value.storageBucket
                : storageBucket // ignore: cast_nullable_to_non_nullable
                    as String?,
        appId:
            freezed == appId
                ? _value.appId
                : appId // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PushNotificationsPublicInfoModelImpl
    implements _PushNotificationsPublicInfoModel {
  const _$PushNotificationsPublicInfoModelImpl({
    @JsonKey(name: 'SenderId') this.senderId,
    @JsonKey(name: 'PublicApiKey') this.publicApiKey,
    @JsonKey(name: 'AuthDomain') this.authDomain,
    @JsonKey(name: 'DatabaseUrl') this.databaseUrl,
    @JsonKey(name: 'ProjectId') this.projectId,
    @JsonKey(name: 'StorageBucket') this.storageBucket,
    @JsonKey(name: 'AppId') this.appId,
  });

  factory _$PushNotificationsPublicInfoModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$PushNotificationsPublicInfoModelImplFromJson(json);

  @override
  @JsonKey(name: 'SenderId')
  final String? senderId;
  @override
  @JsonKey(name: 'PublicApiKey')
  final String? publicApiKey;
  @override
  @JsonKey(name: 'AuthDomain')
  final String? authDomain;
  @override
  @JsonKey(name: 'DatabaseUrl')
  final String? databaseUrl;
  @override
  @JsonKey(name: 'ProjectId')
  final String? projectId;
  @override
  @JsonKey(name: 'StorageBucket')
  final String? storageBucket;
  @override
  @JsonKey(name: 'AppId')
  final String? appId;

  @override
  String toString() {
    return 'PushNotificationsPublicInfoModel(senderId: $senderId, publicApiKey: $publicApiKey, authDomain: $authDomain, databaseUrl: $databaseUrl, projectId: $projectId, storageBucket: $storageBucket, appId: $appId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PushNotificationsPublicInfoModelImpl &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.publicApiKey, publicApiKey) ||
                other.publicApiKey == publicApiKey) &&
            (identical(other.authDomain, authDomain) ||
                other.authDomain == authDomain) &&
            (identical(other.databaseUrl, databaseUrl) ||
                other.databaseUrl == databaseUrl) &&
            (identical(other.projectId, projectId) ||
                other.projectId == projectId) &&
            (identical(other.storageBucket, storageBucket) ||
                other.storageBucket == storageBucket) &&
            (identical(other.appId, appId) || other.appId == appId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    senderId,
    publicApiKey,
    authDomain,
    databaseUrl,
    projectId,
    storageBucket,
    appId,
  );

  /// Create a copy of PushNotificationsPublicInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PushNotificationsPublicInfoModelImplCopyWith<
    _$PushNotificationsPublicInfoModelImpl
  >
  get copyWith => __$$PushNotificationsPublicInfoModelImplCopyWithImpl<
    _$PushNotificationsPublicInfoModelImpl
  >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PushNotificationsPublicInfoModelImplToJson(this);
  }
}

abstract class _PushNotificationsPublicInfoModel
    implements PushNotificationsPublicInfoModel {
  const factory _PushNotificationsPublicInfoModel({
    @JsonKey(name: 'SenderId') final String? senderId,
    @JsonKey(name: 'PublicApiKey') final String? publicApiKey,
    @JsonKey(name: 'AuthDomain') final String? authDomain,
    @JsonKey(name: 'DatabaseUrl') final String? databaseUrl,
    @JsonKey(name: 'ProjectId') final String? projectId,
    @JsonKey(name: 'StorageBucket') final String? storageBucket,
    @JsonKey(name: 'AppId') final String? appId,
  }) = _$PushNotificationsPublicInfoModelImpl;

  factory _PushNotificationsPublicInfoModel.fromJson(
    Map<String, dynamic> json,
  ) = _$PushNotificationsPublicInfoModelImpl.fromJson;

  @override
  @JsonKey(name: 'SenderId')
  String? get senderId;
  @override
  @JsonKey(name: 'PublicApiKey')
  String? get publicApiKey;
  @override
  @JsonKey(name: 'AuthDomain')
  String? get authDomain;
  @override
  @JsonKey(name: 'DatabaseUrl')
  String? get databaseUrl;
  @override
  @JsonKey(name: 'ProjectId')
  String? get projectId;
  @override
  @JsonKey(name: 'StorageBucket')
  String? get storageBucket;
  @override
  @JsonKey(name: 'AppId')
  String? get appId;

  /// Create a copy of PushNotificationsPublicInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PushNotificationsPublicInfoModelImplCopyWith<
    _$PushNotificationsPublicInfoModelImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}
