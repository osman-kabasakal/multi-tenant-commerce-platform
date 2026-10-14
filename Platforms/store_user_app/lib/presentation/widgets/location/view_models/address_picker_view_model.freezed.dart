// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'address_picker_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AddressPickerViewModel {
  String? get error => throw _privateConstructorUsedError;
  List<AddressModel> get addresses => throw _privateConstructorUsedError;

  /// Create a copy of AddressPickerViewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AddressPickerViewModelCopyWith<AddressPickerViewModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddressPickerViewModelCopyWith<$Res> {
  factory $AddressPickerViewModelCopyWith(
    AddressPickerViewModel value,
    $Res Function(AddressPickerViewModel) then,
  ) = _$AddressPickerViewModelCopyWithImpl<$Res, AddressPickerViewModel>;
  @useResult
  $Res call({String? error, List<AddressModel> addresses});
}

/// @nodoc
class _$AddressPickerViewModelCopyWithImpl<
  $Res,
  $Val extends AddressPickerViewModel
>
    implements $AddressPickerViewModelCopyWith<$Res> {
  _$AddressPickerViewModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AddressPickerViewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? error = freezed, Object? addresses = null}) {
    return _then(
      _value.copyWith(
            error:
                freezed == error
                    ? _value.error
                    : error // ignore: cast_nullable_to_non_nullable
                        as String?,
            addresses:
                null == addresses
                    ? _value.addresses
                    : addresses // ignore: cast_nullable_to_non_nullable
                        as List<AddressModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AddressPickerViewModelImplCopyWith<$Res>
    implements $AddressPickerViewModelCopyWith<$Res> {
  factory _$$AddressPickerViewModelImplCopyWith(
    _$AddressPickerViewModelImpl value,
    $Res Function(_$AddressPickerViewModelImpl) then,
  ) = __$$AddressPickerViewModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? error, List<AddressModel> addresses});
}

/// @nodoc
class __$$AddressPickerViewModelImplCopyWithImpl<$Res>
    extends
        _$AddressPickerViewModelCopyWithImpl<$Res, _$AddressPickerViewModelImpl>
    implements _$$AddressPickerViewModelImplCopyWith<$Res> {
  __$$AddressPickerViewModelImplCopyWithImpl(
    _$AddressPickerViewModelImpl _value,
    $Res Function(_$AddressPickerViewModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AddressPickerViewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? error = freezed, Object? addresses = null}) {
    return _then(
      _$AddressPickerViewModelImpl(
        error:
            freezed == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                    as String?,
        addresses:
            null == addresses
                ? _value._addresses
                : addresses // ignore: cast_nullable_to_non_nullable
                    as List<AddressModel>,
      ),
    );
  }
}

/// @nodoc

class _$AddressPickerViewModelImpl implements _AddressPickerViewModel {
  const _$AddressPickerViewModelImpl({
    this.error,
    final List<AddressModel> addresses = const [],
  }) : _addresses = addresses;

  @override
  final String? error;
  final List<AddressModel> _addresses;
  @override
  @JsonKey()
  List<AddressModel> get addresses {
    if (_addresses is EqualUnmodifiableListView) return _addresses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_addresses);
  }

  @override
  String toString() {
    return 'AddressPickerViewModel(error: $error, addresses: $addresses)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddressPickerViewModelImpl &&
            (identical(other.error, error) || other.error == error) &&
            const DeepCollectionEquality().equals(
              other._addresses,
              _addresses,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    error,
    const DeepCollectionEquality().hash(_addresses),
  );

  /// Create a copy of AddressPickerViewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AddressPickerViewModelImplCopyWith<_$AddressPickerViewModelImpl>
  get copyWith =>
      __$$AddressPickerViewModelImplCopyWithImpl<_$AddressPickerViewModelImpl>(
        this,
        _$identity,
      );
}

abstract class _AddressPickerViewModel implements AddressPickerViewModel {
  const factory _AddressPickerViewModel({
    final String? error,
    final List<AddressModel> addresses,
  }) = _$AddressPickerViewModelImpl;

  @override
  String? get error;
  @override
  List<AddressModel> get addresses;

  /// Create a copy of AddressPickerViewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AddressPickerViewModelImplCopyWith<_$AddressPickerViewModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
