// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_reviews_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ProductReviewsViewModel {
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isSubmitting => throw _privateConstructorUsedError;
  bool get isUpdatingHelpfulness => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  ProductReviewsModel? get reviewsModel => throw _privateConstructorUsedError;

  /// Create a copy of ProductReviewsViewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductReviewsViewModelCopyWith<ProductReviewsViewModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductReviewsViewModelCopyWith<$Res> {
  factory $ProductReviewsViewModelCopyWith(
    ProductReviewsViewModel value,
    $Res Function(ProductReviewsViewModel) then,
  ) = _$ProductReviewsViewModelCopyWithImpl<$Res, ProductReviewsViewModel>;
  @useResult
  $Res call({
    bool isLoading,
    bool isSubmitting,
    bool isUpdatingHelpfulness,
    String? error,
    ProductReviewsModel? reviewsModel,
  });

  $ProductReviewsModelCopyWith<$Res>? get reviewsModel;
}

/// @nodoc
class _$ProductReviewsViewModelCopyWithImpl<
  $Res,
  $Val extends ProductReviewsViewModel
>
    implements $ProductReviewsViewModelCopyWith<$Res> {
  _$ProductReviewsViewModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductReviewsViewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isSubmitting = null,
    Object? isUpdatingHelpfulness = null,
    Object? error = freezed,
    Object? reviewsModel = freezed,
  }) {
    return _then(
      _value.copyWith(
            isLoading:
                null == isLoading
                    ? _value.isLoading
                    : isLoading // ignore: cast_nullable_to_non_nullable
                        as bool,
            isSubmitting:
                null == isSubmitting
                    ? _value.isSubmitting
                    : isSubmitting // ignore: cast_nullable_to_non_nullable
                        as bool,
            isUpdatingHelpfulness:
                null == isUpdatingHelpfulness
                    ? _value.isUpdatingHelpfulness
                    : isUpdatingHelpfulness // ignore: cast_nullable_to_non_nullable
                        as bool,
            error:
                freezed == error
                    ? _value.error
                    : error // ignore: cast_nullable_to_non_nullable
                        as String?,
            reviewsModel:
                freezed == reviewsModel
                    ? _value.reviewsModel
                    : reviewsModel // ignore: cast_nullable_to_non_nullable
                        as ProductReviewsModel?,
          )
          as $Val,
    );
  }

  /// Create a copy of ProductReviewsViewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProductReviewsModelCopyWith<$Res>? get reviewsModel {
    if (_value.reviewsModel == null) {
      return null;
    }

    return $ProductReviewsModelCopyWith<$Res>(_value.reviewsModel!, (value) {
      return _then(_value.copyWith(reviewsModel: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ProductReviewsViewModelImplCopyWith<$Res>
    implements $ProductReviewsViewModelCopyWith<$Res> {
  factory _$$ProductReviewsViewModelImplCopyWith(
    _$ProductReviewsViewModelImpl value,
    $Res Function(_$ProductReviewsViewModelImpl) then,
  ) = __$$ProductReviewsViewModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool isLoading,
    bool isSubmitting,
    bool isUpdatingHelpfulness,
    String? error,
    ProductReviewsModel? reviewsModel,
  });

  @override
  $ProductReviewsModelCopyWith<$Res>? get reviewsModel;
}

/// @nodoc
class __$$ProductReviewsViewModelImplCopyWithImpl<$Res>
    extends
        _$ProductReviewsViewModelCopyWithImpl<
          $Res,
          _$ProductReviewsViewModelImpl
        >
    implements _$$ProductReviewsViewModelImplCopyWith<$Res> {
  __$$ProductReviewsViewModelImplCopyWithImpl(
    _$ProductReviewsViewModelImpl _value,
    $Res Function(_$ProductReviewsViewModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductReviewsViewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isSubmitting = null,
    Object? isUpdatingHelpfulness = null,
    Object? error = freezed,
    Object? reviewsModel = freezed,
  }) {
    return _then(
      _$ProductReviewsViewModelImpl(
        isLoading:
            null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                    as bool,
        isSubmitting:
            null == isSubmitting
                ? _value.isSubmitting
                : isSubmitting // ignore: cast_nullable_to_non_nullable
                    as bool,
        isUpdatingHelpfulness:
            null == isUpdatingHelpfulness
                ? _value.isUpdatingHelpfulness
                : isUpdatingHelpfulness // ignore: cast_nullable_to_non_nullable
                    as bool,
        error:
            freezed == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                    as String?,
        reviewsModel:
            freezed == reviewsModel
                ? _value.reviewsModel
                : reviewsModel // ignore: cast_nullable_to_non_nullable
                    as ProductReviewsModel?,
      ),
    );
  }
}

/// @nodoc

class _$ProductReviewsViewModelImpl implements _ProductReviewsViewModel {
  const _$ProductReviewsViewModelImpl({
    this.isLoading = false,
    this.isSubmitting = false,
    this.isUpdatingHelpfulness = false,
    this.error = null,
    this.reviewsModel = null,
  });

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isSubmitting;
  @override
  @JsonKey()
  final bool isUpdatingHelpfulness;
  @override
  @JsonKey()
  final String? error;
  @override
  @JsonKey()
  final ProductReviewsModel? reviewsModel;

  @override
  String toString() {
    return 'ProductReviewsViewModel(isLoading: $isLoading, isSubmitting: $isSubmitting, isUpdatingHelpfulness: $isUpdatingHelpfulness, error: $error, reviewsModel: $reviewsModel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductReviewsViewModelImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isSubmitting, isSubmitting) ||
                other.isSubmitting == isSubmitting) &&
            (identical(other.isUpdatingHelpfulness, isUpdatingHelpfulness) ||
                other.isUpdatingHelpfulness == isUpdatingHelpfulness) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.reviewsModel, reviewsModel) ||
                other.reviewsModel == reviewsModel));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    isLoading,
    isSubmitting,
    isUpdatingHelpfulness,
    error,
    reviewsModel,
  );

  /// Create a copy of ProductReviewsViewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductReviewsViewModelImplCopyWith<_$ProductReviewsViewModelImpl>
  get copyWith => __$$ProductReviewsViewModelImplCopyWithImpl<
    _$ProductReviewsViewModelImpl
  >(this, _$identity);
}

abstract class _ProductReviewsViewModel implements ProductReviewsViewModel {
  const factory _ProductReviewsViewModel({
    final bool isLoading,
    final bool isSubmitting,
    final bool isUpdatingHelpfulness,
    final String? error,
    final ProductReviewsModel? reviewsModel,
  }) = _$ProductReviewsViewModelImpl;

  @override
  bool get isLoading;
  @override
  bool get isSubmitting;
  @override
  bool get isUpdatingHelpfulness;
  @override
  String? get error;
  @override
  ProductReviewsModel? get reviewsModel;

  /// Create a copy of ProductReviewsViewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductReviewsViewModelImplCopyWith<_$ProductReviewsViewModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
