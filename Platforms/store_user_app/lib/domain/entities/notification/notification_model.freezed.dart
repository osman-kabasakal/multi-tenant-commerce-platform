// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

NotificationListResponse _$NotificationListResponseFromJson(
  Map<String, dynamic> json,
) {
  return _NotificationListResponse.fromJson(json);
}

/// @nodoc
mixin _$NotificationListResponse {
  @JsonKey(name: 'Data')
  List<QueuedEmail>? get data => throw _privateConstructorUsedError;
  @JsonKey(name: 'Total')
  int? get total => throw _privateConstructorUsedError;

  /// Serializes this NotificationListResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NotificationListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotificationListResponseCopyWith<NotificationListResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationListResponseCopyWith<$Res> {
  factory $NotificationListResponseCopyWith(
    NotificationListResponse value,
    $Res Function(NotificationListResponse) then,
  ) = _$NotificationListResponseCopyWithImpl<$Res, NotificationListResponse>;
  @useResult
  $Res call({
    @JsonKey(name: 'Data') List<QueuedEmail>? data,
    @JsonKey(name: 'Total') int? total,
  });
}

/// @nodoc
class _$NotificationListResponseCopyWithImpl<
  $Res,
  $Val extends NotificationListResponse
>
    implements $NotificationListResponseCopyWith<$Res> {
  _$NotificationListResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotificationListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? data = freezed, Object? total = freezed}) {
    return _then(
      _value.copyWith(
            data:
                freezed == data
                    ? _value.data
                    : data // ignore: cast_nullable_to_non_nullable
                        as List<QueuedEmail>?,
            total:
                freezed == total
                    ? _value.total
                    : total // ignore: cast_nullable_to_non_nullable
                        as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NotificationListResponseImplCopyWith<$Res>
    implements $NotificationListResponseCopyWith<$Res> {
  factory _$$NotificationListResponseImplCopyWith(
    _$NotificationListResponseImpl value,
    $Res Function(_$NotificationListResponseImpl) then,
  ) = __$$NotificationListResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'Data') List<QueuedEmail>? data,
    @JsonKey(name: 'Total') int? total,
  });
}

/// @nodoc
class __$$NotificationListResponseImplCopyWithImpl<$Res>
    extends
        _$NotificationListResponseCopyWithImpl<
          $Res,
          _$NotificationListResponseImpl
        >
    implements _$$NotificationListResponseImplCopyWith<$Res> {
  __$$NotificationListResponseImplCopyWithImpl(
    _$NotificationListResponseImpl _value,
    $Res Function(_$NotificationListResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NotificationListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? data = freezed, Object? total = freezed}) {
    return _then(
      _$NotificationListResponseImpl(
        data:
            freezed == data
                ? _value._data
                : data // ignore: cast_nullable_to_non_nullable
                    as List<QueuedEmail>?,
        total:
            freezed == total
                ? _value.total
                : total // ignore: cast_nullable_to_non_nullable
                    as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationListResponseImpl implements _NotificationListResponse {
  const _$NotificationListResponseImpl({
    @JsonKey(name: 'Data') final List<QueuedEmail>? data = const [],
    @JsonKey(name: 'Total') this.total,
  }) : _data = data;

  factory _$NotificationListResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationListResponseImplFromJson(json);

  final List<QueuedEmail>? _data;
  @override
  @JsonKey(name: 'Data')
  List<QueuedEmail>? get data {
    final value = _data;
    if (value == null) return null;
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'Total')
  final int? total;

  @override
  String toString() {
    return 'NotificationListResponse(data: $data, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationListResponseImpl &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.total, total) || other.total == total));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_data),
    total,
  );

  /// Create a copy of NotificationListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationListResponseImplCopyWith<_$NotificationListResponseImpl>
  get copyWith => __$$NotificationListResponseImplCopyWithImpl<
    _$NotificationListResponseImpl
  >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationListResponseImplToJson(this);
  }
}

abstract class _NotificationListResponse implements NotificationListResponse {
  const factory _NotificationListResponse({
    @JsonKey(name: 'Data') final List<QueuedEmail>? data,
    @JsonKey(name: 'Total') final int? total,
  }) = _$NotificationListResponseImpl;

  factory _NotificationListResponse.fromJson(Map<String, dynamic> json) =
      _$NotificationListResponseImpl.fromJson;

  @override
  @JsonKey(name: 'Data')
  List<QueuedEmail>? get data;
  @override
  @JsonKey(name: 'Total')
  int? get total;

  /// Create a copy of NotificationListResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificationListResponseImplCopyWith<_$NotificationListResponseImpl>
  get copyWith => throw _privateConstructorUsedError;
}

NotificationDetailResponse _$NotificationDetailResponseFromJson(
  Map<String, dynamic> json,
) {
  return _NotificationDetailResponse.fromJson(json);
}

/// @nodoc
mixin _$NotificationDetailResponse {
  bool? get success => throw _privateConstructorUsedError;
  QueuedEmail? get message => throw _privateConstructorUsedError;

  /// Serializes this NotificationDetailResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NotificationDetailResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotificationDetailResponseCopyWith<NotificationDetailResponse>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationDetailResponseCopyWith<$Res> {
  factory $NotificationDetailResponseCopyWith(
    NotificationDetailResponse value,
    $Res Function(NotificationDetailResponse) then,
  ) =
      _$NotificationDetailResponseCopyWithImpl<
        $Res,
        NotificationDetailResponse
      >;
  @useResult
  $Res call({bool? success, QueuedEmail? message});

  $QueuedEmailCopyWith<$Res>? get message;
}

/// @nodoc
class _$NotificationDetailResponseCopyWithImpl<
  $Res,
  $Val extends NotificationDetailResponse
>
    implements $NotificationDetailResponseCopyWith<$Res> {
  _$NotificationDetailResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotificationDetailResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? success = freezed, Object? message = freezed}) {
    return _then(
      _value.copyWith(
            success:
                freezed == success
                    ? _value.success
                    : success // ignore: cast_nullable_to_non_nullable
                        as bool?,
            message:
                freezed == message
                    ? _value.message
                    : message // ignore: cast_nullable_to_non_nullable
                        as QueuedEmail?,
          )
          as $Val,
    );
  }

  /// Create a copy of NotificationDetailResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $QueuedEmailCopyWith<$Res>? get message {
    if (_value.message == null) {
      return null;
    }

    return $QueuedEmailCopyWith<$Res>(_value.message!, (value) {
      return _then(_value.copyWith(message: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$NotificationDetailResponseImplCopyWith<$Res>
    implements $NotificationDetailResponseCopyWith<$Res> {
  factory _$$NotificationDetailResponseImplCopyWith(
    _$NotificationDetailResponseImpl value,
    $Res Function(_$NotificationDetailResponseImpl) then,
  ) = __$$NotificationDetailResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool? success, QueuedEmail? message});

  @override
  $QueuedEmailCopyWith<$Res>? get message;
}

/// @nodoc
class __$$NotificationDetailResponseImplCopyWithImpl<$Res>
    extends
        _$NotificationDetailResponseCopyWithImpl<
          $Res,
          _$NotificationDetailResponseImpl
        >
    implements _$$NotificationDetailResponseImplCopyWith<$Res> {
  __$$NotificationDetailResponseImplCopyWithImpl(
    _$NotificationDetailResponseImpl _value,
    $Res Function(_$NotificationDetailResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NotificationDetailResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? success = freezed, Object? message = freezed}) {
    return _then(
      _$NotificationDetailResponseImpl(
        success:
            freezed == success
                ? _value.success
                : success // ignore: cast_nullable_to_non_nullable
                    as bool?,
        message:
            freezed == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                    as QueuedEmail?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationDetailResponseImpl implements _NotificationDetailResponse {
  const _$NotificationDetailResponseImpl({this.success, this.message});

  factory _$NotificationDetailResponseImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$NotificationDetailResponseImplFromJson(json);

  @override
  final bool? success;
  @override
  final QueuedEmail? message;

  @override
  String toString() {
    return 'NotificationDetailResponse(success: $success, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationDetailResponseImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, success, message);

  /// Create a copy of NotificationDetailResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationDetailResponseImplCopyWith<_$NotificationDetailResponseImpl>
  get copyWith => __$$NotificationDetailResponseImplCopyWithImpl<
    _$NotificationDetailResponseImpl
  >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationDetailResponseImplToJson(this);
  }
}

abstract class _NotificationDetailResponse
    implements NotificationDetailResponse {
  const factory _NotificationDetailResponse({
    final bool? success,
    final QueuedEmail? message,
  }) = _$NotificationDetailResponseImpl;

  factory _NotificationDetailResponse.fromJson(Map<String, dynamic> json) =
      _$NotificationDetailResponseImpl.fromJson;

  @override
  bool? get success;
  @override
  QueuedEmail? get message;

  /// Create a copy of NotificationDetailResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificationDetailResponseImplCopyWith<_$NotificationDetailResponseImpl>
  get copyWith => throw _privateConstructorUsedError;
}
