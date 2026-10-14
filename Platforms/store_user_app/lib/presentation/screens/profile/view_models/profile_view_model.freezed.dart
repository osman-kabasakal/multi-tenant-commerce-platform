// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ProfileViewModel {
  String? get error => throw _privateConstructorUsedError;
  CustomerNavigationModel get customerNavigation =>
      throw _privateConstructorUsedError;
  CustomerInfoModel get customerInfo => throw _privateConstructorUsedError;

  /// Create a copy of ProfileViewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProfileViewModelCopyWith<ProfileViewModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileViewModelCopyWith<$Res> {
  factory $ProfileViewModelCopyWith(
    ProfileViewModel value,
    $Res Function(ProfileViewModel) then,
  ) = _$ProfileViewModelCopyWithImpl<$Res, ProfileViewModel>;
  @useResult
  $Res call({
    String? error,
    CustomerNavigationModel customerNavigation,
    CustomerInfoModel customerInfo,
  });

  $CustomerNavigationModelCopyWith<$Res> get customerNavigation;
  $CustomerInfoModelCopyWith<$Res> get customerInfo;
}

/// @nodoc
class _$ProfileViewModelCopyWithImpl<$Res, $Val extends ProfileViewModel>
    implements $ProfileViewModelCopyWith<$Res> {
  _$ProfileViewModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProfileViewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = freezed,
    Object? customerNavigation = null,
    Object? customerInfo = null,
  }) {
    return _then(
      _value.copyWith(
            error:
                freezed == error
                    ? _value.error
                    : error // ignore: cast_nullable_to_non_nullable
                        as String?,
            customerNavigation:
                null == customerNavigation
                    ? _value.customerNavigation
                    : customerNavigation // ignore: cast_nullable_to_non_nullable
                        as CustomerNavigationModel,
            customerInfo:
                null == customerInfo
                    ? _value.customerInfo
                    : customerInfo // ignore: cast_nullable_to_non_nullable
                        as CustomerInfoModel,
          )
          as $Val,
    );
  }

  /// Create a copy of ProfileViewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CustomerNavigationModelCopyWith<$Res> get customerNavigation {
    return $CustomerNavigationModelCopyWith<$Res>(_value.customerNavigation, (
      value,
    ) {
      return _then(_value.copyWith(customerNavigation: value) as $Val);
    });
  }

  /// Create a copy of ProfileViewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CustomerInfoModelCopyWith<$Res> get customerInfo {
    return $CustomerInfoModelCopyWith<$Res>(_value.customerInfo, (value) {
      return _then(_value.copyWith(customerInfo: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ProfileViewModelImplCopyWith<$Res>
    implements $ProfileViewModelCopyWith<$Res> {
  factory _$$ProfileViewModelImplCopyWith(
    _$ProfileViewModelImpl value,
    $Res Function(_$ProfileViewModelImpl) then,
  ) = __$$ProfileViewModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? error,
    CustomerNavigationModel customerNavigation,
    CustomerInfoModel customerInfo,
  });

  @override
  $CustomerNavigationModelCopyWith<$Res> get customerNavigation;
  @override
  $CustomerInfoModelCopyWith<$Res> get customerInfo;
}

/// @nodoc
class __$$ProfileViewModelImplCopyWithImpl<$Res>
    extends _$ProfileViewModelCopyWithImpl<$Res, _$ProfileViewModelImpl>
    implements _$$ProfileViewModelImplCopyWith<$Res> {
  __$$ProfileViewModelImplCopyWithImpl(
    _$ProfileViewModelImpl _value,
    $Res Function(_$ProfileViewModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProfileViewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = freezed,
    Object? customerNavigation = null,
    Object? customerInfo = null,
  }) {
    return _then(
      _$ProfileViewModelImpl(
        error:
            freezed == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                    as String?,
        customerNavigation:
            null == customerNavigation
                ? _value.customerNavigation
                : customerNavigation // ignore: cast_nullable_to_non_nullable
                    as CustomerNavigationModel,
        customerInfo:
            null == customerInfo
                ? _value.customerInfo
                : customerInfo // ignore: cast_nullable_to_non_nullable
                    as CustomerInfoModel,
      ),
    );
  }
}

/// @nodoc

class _$ProfileViewModelImpl implements _ProfileViewModel {
  const _$ProfileViewModelImpl({
    this.error = null,
    required this.customerNavigation,
    required this.customerInfo,
  });

  @override
  @JsonKey()
  final String? error;
  @override
  final CustomerNavigationModel customerNavigation;
  @override
  final CustomerInfoModel customerInfo;

  @override
  String toString() {
    return 'ProfileViewModel(error: $error, customerNavigation: $customerNavigation, customerInfo: $customerInfo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileViewModelImpl &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.customerNavigation, customerNavigation) ||
                other.customerNavigation == customerNavigation) &&
            (identical(other.customerInfo, customerInfo) ||
                other.customerInfo == customerInfo));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, error, customerNavigation, customerInfo);

  /// Create a copy of ProfileViewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileViewModelImplCopyWith<_$ProfileViewModelImpl> get copyWith =>
      __$$ProfileViewModelImplCopyWithImpl<_$ProfileViewModelImpl>(
        this,
        _$identity,
      );
}

abstract class _ProfileViewModel implements ProfileViewModel {
  const factory _ProfileViewModel({
    final String? error,
    required final CustomerNavigationModel customerNavigation,
    required final CustomerInfoModel customerInfo,
  }) = _$ProfileViewModelImpl;

  @override
  String? get error;
  @override
  CustomerNavigationModel get customerNavigation;
  @override
  CustomerInfoModel get customerInfo;

  /// Create a copy of ProfileViewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProfileViewModelImplCopyWith<_$ProfileViewModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
