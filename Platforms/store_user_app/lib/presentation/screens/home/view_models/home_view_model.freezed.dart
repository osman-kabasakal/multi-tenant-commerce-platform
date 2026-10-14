// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$HomeViewModel {
  bool get isLoading => throw _privateConstructorUsedError;
  bool get hasMessages => throw _privateConstructorUsedError;

  /// Create a copy of HomeViewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HomeViewModelCopyWith<HomeViewModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeViewModelCopyWith<$Res> {
  factory $HomeViewModelCopyWith(
    HomeViewModel value,
    $Res Function(HomeViewModel) then,
  ) = _$HomeViewModelCopyWithImpl<$Res, HomeViewModel>;
  @useResult
  $Res call({bool isLoading, bool hasMessages});
}

/// @nodoc
class _$HomeViewModelCopyWithImpl<$Res, $Val extends HomeViewModel>
    implements $HomeViewModelCopyWith<$Res> {
  _$HomeViewModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HomeViewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? isLoading = null, Object? hasMessages = null}) {
    return _then(
      _value.copyWith(
            isLoading:
                null == isLoading
                    ? _value.isLoading
                    : isLoading // ignore: cast_nullable_to_non_nullable
                        as bool,
            hasMessages:
                null == hasMessages
                    ? _value.hasMessages
                    : hasMessages // ignore: cast_nullable_to_non_nullable
                        as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$HomeViewModelImplCopyWith<$Res>
    implements $HomeViewModelCopyWith<$Res> {
  factory _$$HomeViewModelImplCopyWith(
    _$HomeViewModelImpl value,
    $Res Function(_$HomeViewModelImpl) then,
  ) = __$$HomeViewModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isLoading, bool hasMessages});
}

/// @nodoc
class __$$HomeViewModelImplCopyWithImpl<$Res>
    extends _$HomeViewModelCopyWithImpl<$Res, _$HomeViewModelImpl>
    implements _$$HomeViewModelImplCopyWith<$Res> {
  __$$HomeViewModelImplCopyWithImpl(
    _$HomeViewModelImpl _value,
    $Res Function(_$HomeViewModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HomeViewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? isLoading = null, Object? hasMessages = null}) {
    return _then(
      _$HomeViewModelImpl(
        isLoading:
            null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                    as bool,
        hasMessages:
            null == hasMessages
                ? _value.hasMessages
                : hasMessages // ignore: cast_nullable_to_non_nullable
                    as bool,
      ),
    );
  }
}

/// @nodoc

class _$HomeViewModelImpl implements _HomeViewModel {
  const _$HomeViewModelImpl({this.isLoading = true, this.hasMessages = false});

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool hasMessages;

  @override
  String toString() {
    return 'HomeViewModel(isLoading: $isLoading, hasMessages: $hasMessages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeViewModelImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.hasMessages, hasMessages) ||
                other.hasMessages == hasMessages));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isLoading, hasMessages);

  /// Create a copy of HomeViewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeViewModelImplCopyWith<_$HomeViewModelImpl> get copyWith =>
      __$$HomeViewModelImplCopyWithImpl<_$HomeViewModelImpl>(this, _$identity);
}

abstract class _HomeViewModel implements HomeViewModel {
  const factory _HomeViewModel({final bool isLoading, final bool hasMessages}) =
      _$HomeViewModelImpl;

  @override
  bool get isLoading;
  @override
  bool get hasMessages;

  /// Create a copy of HomeViewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HomeViewModelImplCopyWith<_$HomeViewModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
