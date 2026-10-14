// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'special_offer_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SpecialOfferViewModel {
  PublicInfoModel get publicInfoModel => throw _privateConstructorUsedError;
  String? get loadingError => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;

  /// Create a copy of SpecialOfferViewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SpecialOfferViewModelCopyWith<SpecialOfferViewModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpecialOfferViewModelCopyWith<$Res> {
  factory $SpecialOfferViewModelCopyWith(
    SpecialOfferViewModel value,
    $Res Function(SpecialOfferViewModel) then,
  ) = _$SpecialOfferViewModelCopyWithImpl<$Res, SpecialOfferViewModel>;
  @useResult
  $Res call({
    PublicInfoModel publicInfoModel,
    String? loadingError,
    bool isLoading,
  });

  $PublicInfoModelCopyWith<$Res> get publicInfoModel;
}

/// @nodoc
class _$SpecialOfferViewModelCopyWithImpl<
  $Res,
  $Val extends SpecialOfferViewModel
>
    implements $SpecialOfferViewModelCopyWith<$Res> {
  _$SpecialOfferViewModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SpecialOfferViewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? publicInfoModel = null,
    Object? loadingError = freezed,
    Object? isLoading = null,
  }) {
    return _then(
      _value.copyWith(
            publicInfoModel:
                null == publicInfoModel
                    ? _value.publicInfoModel
                    : publicInfoModel // ignore: cast_nullable_to_non_nullable
                        as PublicInfoModel,
            loadingError:
                freezed == loadingError
                    ? _value.loadingError
                    : loadingError // ignore: cast_nullable_to_non_nullable
                        as String?,
            isLoading:
                null == isLoading
                    ? _value.isLoading
                    : isLoading // ignore: cast_nullable_to_non_nullable
                        as bool,
          )
          as $Val,
    );
  }

  /// Create a copy of SpecialOfferViewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PublicInfoModelCopyWith<$Res> get publicInfoModel {
    return $PublicInfoModelCopyWith<$Res>(_value.publicInfoModel, (value) {
      return _then(_value.copyWith(publicInfoModel: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SpecialOfferViewModelImplCopyWith<$Res>
    implements $SpecialOfferViewModelCopyWith<$Res> {
  factory _$$SpecialOfferViewModelImplCopyWith(
    _$SpecialOfferViewModelImpl value,
    $Res Function(_$SpecialOfferViewModelImpl) then,
  ) = __$$SpecialOfferViewModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    PublicInfoModel publicInfoModel,
    String? loadingError,
    bool isLoading,
  });

  @override
  $PublicInfoModelCopyWith<$Res> get publicInfoModel;
}

/// @nodoc
class __$$SpecialOfferViewModelImplCopyWithImpl<$Res>
    extends
        _$SpecialOfferViewModelCopyWithImpl<$Res, _$SpecialOfferViewModelImpl>
    implements _$$SpecialOfferViewModelImplCopyWith<$Res> {
  __$$SpecialOfferViewModelImplCopyWithImpl(
    _$SpecialOfferViewModelImpl _value,
    $Res Function(_$SpecialOfferViewModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SpecialOfferViewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? publicInfoModel = null,
    Object? loadingError = freezed,
    Object? isLoading = null,
  }) {
    return _then(
      _$SpecialOfferViewModelImpl(
        publicInfoModel:
            null == publicInfoModel
                ? _value.publicInfoModel
                : publicInfoModel // ignore: cast_nullable_to_non_nullable
                    as PublicInfoModel,
        loadingError:
            freezed == loadingError
                ? _value.loadingError
                : loadingError // ignore: cast_nullable_to_non_nullable
                    as String?,
        isLoading:
            null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                    as bool,
      ),
    );
  }
}

/// @nodoc

class _$SpecialOfferViewModelImpl implements _SpecialOfferViewModel {
  const _$SpecialOfferViewModelImpl({
    required this.publicInfoModel,
    this.loadingError,
    this.isLoading = true,
  });

  @override
  final PublicInfoModel publicInfoModel;
  @override
  final String? loadingError;
  @override
  @JsonKey()
  final bool isLoading;

  @override
  String toString() {
    return 'SpecialOfferViewModel(publicInfoModel: $publicInfoModel, loadingError: $loadingError, isLoading: $isLoading)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpecialOfferViewModelImpl &&
            (identical(other.publicInfoModel, publicInfoModel) ||
                other.publicInfoModel == publicInfoModel) &&
            (identical(other.loadingError, loadingError) ||
                other.loadingError == loadingError) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, publicInfoModel, loadingError, isLoading);

  /// Create a copy of SpecialOfferViewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpecialOfferViewModelImplCopyWith<_$SpecialOfferViewModelImpl>
  get copyWith =>
      __$$SpecialOfferViewModelImplCopyWithImpl<_$SpecialOfferViewModelImpl>(
        this,
        _$identity,
      );
}

abstract class _SpecialOfferViewModel implements SpecialOfferViewModel {
  const factory _SpecialOfferViewModel({
    required final PublicInfoModel publicInfoModel,
    final String? loadingError,
    final bool isLoading,
  }) = _$SpecialOfferViewModelImpl;

  @override
  PublicInfoModel get publicInfoModel;
  @override
  String? get loadingError;
  @override
  bool get isLoading;

  /// Create a copy of SpecialOfferViewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpecialOfferViewModelImplCopyWith<_$SpecialOfferViewModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
