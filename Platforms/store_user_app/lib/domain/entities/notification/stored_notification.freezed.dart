// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stored_notification.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

StoredNotification _$StoredNotificationFromJson(Map<String, dynamic> json) {
  return _StoredNotification.fromJson(json);
}

/// @nodoc
mixin _$StoredNotification {
  /// Bildirim ID'si
  String get id => throw _privateConstructorUsedError;

  /// Bildirim başlığı
  String? get subject => throw _privateConstructorUsedError;

  /// Bildirim gönderildiği tarih
  DateTime? get sentOnUtc => throw _privateConstructorUsedError;

  /// Bildirim oluşturulduğu tarih
  DateTime? get createdOnUtc => throw _privateConstructorUsedError;

  /// Yerel bildirim gösterildi mi?
  bool get notificationShown => throw _privateConstructorUsedError;

  /// Kullanıcı bildirimi gördü mü?
  bool get seenByUser => throw _privateConstructorUsedError;

  /// Bildirim okundu mu? (ReadOnUtc değeri sunucuda var mı)
  bool get readOnServer => throw _privateConstructorUsedError;

  /// Bildirim bilgilerinin son güncellenme zamanı
  DateTime get lastUpdated => throw _privateConstructorUsedError;

  /// Serializes this StoredNotification to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StoredNotification
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StoredNotificationCopyWith<StoredNotification> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StoredNotificationCopyWith<$Res> {
  factory $StoredNotificationCopyWith(
    StoredNotification value,
    $Res Function(StoredNotification) then,
  ) = _$StoredNotificationCopyWithImpl<$Res, StoredNotification>;
  @useResult
  $Res call({
    String id,
    String? subject,
    DateTime? sentOnUtc,
    DateTime? createdOnUtc,
    bool notificationShown,
    bool seenByUser,
    bool readOnServer,
    DateTime lastUpdated,
  });
}

/// @nodoc
class _$StoredNotificationCopyWithImpl<$Res, $Val extends StoredNotification>
    implements $StoredNotificationCopyWith<$Res> {
  _$StoredNotificationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StoredNotification
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? subject = freezed,
    Object? sentOnUtc = freezed,
    Object? createdOnUtc = freezed,
    Object? notificationShown = null,
    Object? seenByUser = null,
    Object? readOnServer = null,
    Object? lastUpdated = null,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            subject:
                freezed == subject
                    ? _value.subject
                    : subject // ignore: cast_nullable_to_non_nullable
                        as String?,
            sentOnUtc:
                freezed == sentOnUtc
                    ? _value.sentOnUtc
                    : sentOnUtc // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            createdOnUtc:
                freezed == createdOnUtc
                    ? _value.createdOnUtc
                    : createdOnUtc // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            notificationShown:
                null == notificationShown
                    ? _value.notificationShown
                    : notificationShown // ignore: cast_nullable_to_non_nullable
                        as bool,
            seenByUser:
                null == seenByUser
                    ? _value.seenByUser
                    : seenByUser // ignore: cast_nullable_to_non_nullable
                        as bool,
            readOnServer:
                null == readOnServer
                    ? _value.readOnServer
                    : readOnServer // ignore: cast_nullable_to_non_nullable
                        as bool,
            lastUpdated:
                null == lastUpdated
                    ? _value.lastUpdated
                    : lastUpdated // ignore: cast_nullable_to_non_nullable
                        as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StoredNotificationImplCopyWith<$Res>
    implements $StoredNotificationCopyWith<$Res> {
  factory _$$StoredNotificationImplCopyWith(
    _$StoredNotificationImpl value,
    $Res Function(_$StoredNotificationImpl) then,
  ) = __$$StoredNotificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String? subject,
    DateTime? sentOnUtc,
    DateTime? createdOnUtc,
    bool notificationShown,
    bool seenByUser,
    bool readOnServer,
    DateTime lastUpdated,
  });
}

/// @nodoc
class __$$StoredNotificationImplCopyWithImpl<$Res>
    extends _$StoredNotificationCopyWithImpl<$Res, _$StoredNotificationImpl>
    implements _$$StoredNotificationImplCopyWith<$Res> {
  __$$StoredNotificationImplCopyWithImpl(
    _$StoredNotificationImpl _value,
    $Res Function(_$StoredNotificationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StoredNotification
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? subject = freezed,
    Object? sentOnUtc = freezed,
    Object? createdOnUtc = freezed,
    Object? notificationShown = null,
    Object? seenByUser = null,
    Object? readOnServer = null,
    Object? lastUpdated = null,
  }) {
    return _then(
      _$StoredNotificationImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        subject:
            freezed == subject
                ? _value.subject
                : subject // ignore: cast_nullable_to_non_nullable
                    as String?,
        sentOnUtc:
            freezed == sentOnUtc
                ? _value.sentOnUtc
                : sentOnUtc // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        createdOnUtc:
            freezed == createdOnUtc
                ? _value.createdOnUtc
                : createdOnUtc // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        notificationShown:
            null == notificationShown
                ? _value.notificationShown
                : notificationShown // ignore: cast_nullable_to_non_nullable
                    as bool,
        seenByUser:
            null == seenByUser
                ? _value.seenByUser
                : seenByUser // ignore: cast_nullable_to_non_nullable
                    as bool,
        readOnServer:
            null == readOnServer
                ? _value.readOnServer
                : readOnServer // ignore: cast_nullable_to_non_nullable
                    as bool,
        lastUpdated:
            null == lastUpdated
                ? _value.lastUpdated
                : lastUpdated // ignore: cast_nullable_to_non_nullable
                    as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StoredNotificationImpl implements _StoredNotification {
  const _$StoredNotificationImpl({
    required this.id,
    this.subject,
    this.sentOnUtc,
    this.createdOnUtc,
    this.notificationShown = false,
    this.seenByUser = false,
    this.readOnServer = false,
    required this.lastUpdated,
  });

  factory _$StoredNotificationImpl.fromJson(Map<String, dynamic> json) =>
      _$$StoredNotificationImplFromJson(json);

  /// Bildirim ID'si
  @override
  final String id;

  /// Bildirim başlığı
  @override
  final String? subject;

  /// Bildirim gönderildiği tarih
  @override
  final DateTime? sentOnUtc;

  /// Bildirim oluşturulduğu tarih
  @override
  final DateTime? createdOnUtc;

  /// Yerel bildirim gösterildi mi?
  @override
  @JsonKey()
  final bool notificationShown;

  /// Kullanıcı bildirimi gördü mü?
  @override
  @JsonKey()
  final bool seenByUser;

  /// Bildirim okundu mu? (ReadOnUtc değeri sunucuda var mı)
  @override
  @JsonKey()
  final bool readOnServer;

  /// Bildirim bilgilerinin son güncellenme zamanı
  @override
  final DateTime lastUpdated;

  @override
  String toString() {
    return 'StoredNotification(id: $id, subject: $subject, sentOnUtc: $sentOnUtc, createdOnUtc: $createdOnUtc, notificationShown: $notificationShown, seenByUser: $seenByUser, readOnServer: $readOnServer, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StoredNotificationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.subject, subject) || other.subject == subject) &&
            (identical(other.sentOnUtc, sentOnUtc) ||
                other.sentOnUtc == sentOnUtc) &&
            (identical(other.createdOnUtc, createdOnUtc) ||
                other.createdOnUtc == createdOnUtc) &&
            (identical(other.notificationShown, notificationShown) ||
                other.notificationShown == notificationShown) &&
            (identical(other.seenByUser, seenByUser) ||
                other.seenByUser == seenByUser) &&
            (identical(other.readOnServer, readOnServer) ||
                other.readOnServer == readOnServer) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    subject,
    sentOnUtc,
    createdOnUtc,
    notificationShown,
    seenByUser,
    readOnServer,
    lastUpdated,
  );

  /// Create a copy of StoredNotification
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StoredNotificationImplCopyWith<_$StoredNotificationImpl> get copyWith =>
      __$$StoredNotificationImplCopyWithImpl<_$StoredNotificationImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$StoredNotificationImplToJson(this);
  }
}

abstract class _StoredNotification implements StoredNotification {
  const factory _StoredNotification({
    required final String id,
    final String? subject,
    final DateTime? sentOnUtc,
    final DateTime? createdOnUtc,
    final bool notificationShown,
    final bool seenByUser,
    final bool readOnServer,
    required final DateTime lastUpdated,
  }) = _$StoredNotificationImpl;

  factory _StoredNotification.fromJson(Map<String, dynamic> json) =
      _$StoredNotificationImpl.fromJson;

  /// Bildirim ID'si
  @override
  String get id;

  /// Bildirim başlığı
  @override
  String? get subject;

  /// Bildirim gönderildiği tarih
  @override
  DateTime? get sentOnUtc;

  /// Bildirim oluşturulduğu tarih
  @override
  DateTime? get createdOnUtc;

  /// Yerel bildirim gösterildi mi?
  @override
  bool get notificationShown;

  /// Kullanıcı bildirimi gördü mü?
  @override
  bool get seenByUser;

  /// Bildirim okundu mu? (ReadOnUtc değeri sunucuda var mı)
  @override
  bool get readOnServer;

  /// Bildirim bilgilerinin son güncellenme zamanı
  @override
  DateTime get lastUpdated;

  /// Create a copy of StoredNotification
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StoredNotificationImplCopyWith<_$StoredNotificationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NotificationStore _$NotificationStoreFromJson(Map<String, dynamic> json) {
  return _NotificationStore.fromJson(json);
}

/// @nodoc
mixin _$NotificationStore {
  /// Saklanan tüm bildirimler
  List<StoredNotification> get notifications =>
      throw _privateConstructorUsedError;

  /// Son kontrol edilme zamanı
  DateTime? get lastChecked => throw _privateConstructorUsedError;

  /// Serializes this NotificationStore to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NotificationStore
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotificationStoreCopyWith<NotificationStore> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationStoreCopyWith<$Res> {
  factory $NotificationStoreCopyWith(
    NotificationStore value,
    $Res Function(NotificationStore) then,
  ) = _$NotificationStoreCopyWithImpl<$Res, NotificationStore>;
  @useResult
  $Res call({List<StoredNotification> notifications, DateTime? lastChecked});
}

/// @nodoc
class _$NotificationStoreCopyWithImpl<$Res, $Val extends NotificationStore>
    implements $NotificationStoreCopyWith<$Res> {
  _$NotificationStoreCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotificationStore
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? notifications = null, Object? lastChecked = freezed}) {
    return _then(
      _value.copyWith(
            notifications:
                null == notifications
                    ? _value.notifications
                    : notifications // ignore: cast_nullable_to_non_nullable
                        as List<StoredNotification>,
            lastChecked:
                freezed == lastChecked
                    ? _value.lastChecked
                    : lastChecked // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NotificationStoreImplCopyWith<$Res>
    implements $NotificationStoreCopyWith<$Res> {
  factory _$$NotificationStoreImplCopyWith(
    _$NotificationStoreImpl value,
    $Res Function(_$NotificationStoreImpl) then,
  ) = __$$NotificationStoreImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<StoredNotification> notifications, DateTime? lastChecked});
}

/// @nodoc
class __$$NotificationStoreImplCopyWithImpl<$Res>
    extends _$NotificationStoreCopyWithImpl<$Res, _$NotificationStoreImpl>
    implements _$$NotificationStoreImplCopyWith<$Res> {
  __$$NotificationStoreImplCopyWithImpl(
    _$NotificationStoreImpl _value,
    $Res Function(_$NotificationStoreImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NotificationStore
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? notifications = null, Object? lastChecked = freezed}) {
    return _then(
      _$NotificationStoreImpl(
        notifications:
            null == notifications
                ? _value._notifications
                : notifications // ignore: cast_nullable_to_non_nullable
                    as List<StoredNotification>,
        lastChecked:
            freezed == lastChecked
                ? _value.lastChecked
                : lastChecked // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationStoreImpl implements _NotificationStore {
  const _$NotificationStoreImpl({
    final List<StoredNotification> notifications = const [],
    this.lastChecked,
  }) : _notifications = notifications;

  factory _$NotificationStoreImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationStoreImplFromJson(json);

  /// Saklanan tüm bildirimler
  final List<StoredNotification> _notifications;

  /// Saklanan tüm bildirimler
  @override
  @JsonKey()
  List<StoredNotification> get notifications {
    if (_notifications is EqualUnmodifiableListView) return _notifications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_notifications);
  }

  /// Son kontrol edilme zamanı
  @override
  final DateTime? lastChecked;

  @override
  String toString() {
    return 'NotificationStore(notifications: $notifications, lastChecked: $lastChecked)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationStoreImpl &&
            const DeepCollectionEquality().equals(
              other._notifications,
              _notifications,
            ) &&
            (identical(other.lastChecked, lastChecked) ||
                other.lastChecked == lastChecked));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_notifications),
    lastChecked,
  );

  /// Create a copy of NotificationStore
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationStoreImplCopyWith<_$NotificationStoreImpl> get copyWith =>
      __$$NotificationStoreImplCopyWithImpl<_$NotificationStoreImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationStoreImplToJson(this);
  }
}

abstract class _NotificationStore implements NotificationStore {
  const factory _NotificationStore({
    final List<StoredNotification> notifications,
    final DateTime? lastChecked,
  }) = _$NotificationStoreImpl;

  factory _NotificationStore.fromJson(Map<String, dynamic> json) =
      _$NotificationStoreImpl.fromJson;

  /// Saklanan tüm bildirimler
  @override
  List<StoredNotification> get notifications;

  /// Son kontrol edilme zamanı
  @override
  DateTime? get lastChecked;

  /// Create a copy of NotificationStore
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificationStoreImplCopyWith<_$NotificationStoreImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
