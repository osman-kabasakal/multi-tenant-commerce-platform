// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'check_out_route_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CheckOutRouteData {
  bool get requireAuthorization => throw _privateConstructorUsedError;
  bool get checkoutAsGuest => throw _privateConstructorUsedError;

  /// Create a copy of CheckOutRouteData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CheckOutRouteDataCopyWith<CheckOutRouteData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CheckOutRouteDataCopyWith<$Res> {
  factory $CheckOutRouteDataCopyWith(
    CheckOutRouteData value,
    $Res Function(CheckOutRouteData) then,
  ) = _$CheckOutRouteDataCopyWithImpl<$Res, CheckOutRouteData>;
  @useResult
  $Res call({bool requireAuthorization, bool checkoutAsGuest});
}

/// @nodoc
class _$CheckOutRouteDataCopyWithImpl<$Res, $Val extends CheckOutRouteData>
    implements $CheckOutRouteDataCopyWith<$Res> {
  _$CheckOutRouteDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CheckOutRouteData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? requireAuthorization = null,
    Object? checkoutAsGuest = null,
  }) {
    return _then(
      _value.copyWith(
            requireAuthorization:
                null == requireAuthorization
                    ? _value.requireAuthorization
                    : requireAuthorization // ignore: cast_nullable_to_non_nullable
                        as bool,
            checkoutAsGuest:
                null == checkoutAsGuest
                    ? _value.checkoutAsGuest
                    : checkoutAsGuest // ignore: cast_nullable_to_non_nullable
                        as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CheckOutRouteDataImplCopyWith<$Res>
    implements $CheckOutRouteDataCopyWith<$Res> {
  factory _$$CheckOutRouteDataImplCopyWith(
    _$CheckOutRouteDataImpl value,
    $Res Function(_$CheckOutRouteDataImpl) then,
  ) = __$$CheckOutRouteDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool requireAuthorization, bool checkoutAsGuest});
}

/// @nodoc
class __$$CheckOutRouteDataImplCopyWithImpl<$Res>
    extends _$CheckOutRouteDataCopyWithImpl<$Res, _$CheckOutRouteDataImpl>
    implements _$$CheckOutRouteDataImplCopyWith<$Res> {
  __$$CheckOutRouteDataImplCopyWithImpl(
    _$CheckOutRouteDataImpl _value,
    $Res Function(_$CheckOutRouteDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CheckOutRouteData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? requireAuthorization = null,
    Object? checkoutAsGuest = null,
  }) {
    return _then(
      _$CheckOutRouteDataImpl(
        requireAuthorization:
            null == requireAuthorization
                ? _value.requireAuthorization
                : requireAuthorization // ignore: cast_nullable_to_non_nullable
                    as bool,
        checkoutAsGuest:
            null == checkoutAsGuest
                ? _value.checkoutAsGuest
                : checkoutAsGuest // ignore: cast_nullable_to_non_nullable
                    as bool,
      ),
    );
  }
}

/// @nodoc

class _$CheckOutRouteDataImpl implements _CheckOutRouteData {
  const _$CheckOutRouteDataImpl({
    required this.requireAuthorization,
    required this.checkoutAsGuest,
  });

  @override
  final bool requireAuthorization;
  @override
  final bool checkoutAsGuest;

  @override
  String toString() {
    return 'CheckOutRouteData(requireAuthorization: $requireAuthorization, checkoutAsGuest: $checkoutAsGuest)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CheckOutRouteDataImpl &&
            (identical(other.requireAuthorization, requireAuthorization) ||
                other.requireAuthorization == requireAuthorization) &&
            (identical(other.checkoutAsGuest, checkoutAsGuest) ||
                other.checkoutAsGuest == checkoutAsGuest));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, requireAuthorization, checkoutAsGuest);

  /// Create a copy of CheckOutRouteData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CheckOutRouteDataImplCopyWith<_$CheckOutRouteDataImpl> get copyWith =>
      __$$CheckOutRouteDataImplCopyWithImpl<_$CheckOutRouteDataImpl>(
        this,
        _$identity,
      );
}

abstract class _CheckOutRouteData implements CheckOutRouteData {
  const factory _CheckOutRouteData({
    required final bool requireAuthorization,
    required final bool checkoutAsGuest,
  }) = _$CheckOutRouteDataImpl;

  @override
  bool get requireAuthorization;
  @override
  bool get checkoutAsGuest;

  /// Create a copy of CheckOutRouteData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CheckOutRouteDataImplCopyWith<_$CheckOutRouteDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
