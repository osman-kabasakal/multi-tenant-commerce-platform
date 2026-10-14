// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_detail_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ProductDetailViewModel {
  ProductDetailsModel? get productDetailsModel =>
      throw _privateConstructorUsedError;
  List<ProductAttributeModel> get activeAttributes =>
      throw _privateConstructorUsedError;
  List<ProductOverviewModel>? get relatedProducts =>
      throw _privateConstructorUsedError;
  List<ProductOverviewModel>? get alsoPurchasedProducts =>
      throw _privateConstructorUsedError;
  List<ProductOverviewModel>? get similarProducts =>
      throw _privateConstructorUsedError;
  List<ProductOverviewModel>? get recentlyViewedProducts =>
      throw _privateConstructorUsedError;
  String get outOfStockButtonText => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isFailure => throw _privateConstructorUsedError;
  bool get isProcessingAttribute => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of ProductDetailViewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductDetailViewModelCopyWith<ProductDetailViewModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductDetailViewModelCopyWith<$Res> {
  factory $ProductDetailViewModelCopyWith(
    ProductDetailViewModel value,
    $Res Function(ProductDetailViewModel) then,
  ) = _$ProductDetailViewModelCopyWithImpl<$Res, ProductDetailViewModel>;
  @useResult
  $Res call({
    ProductDetailsModel? productDetailsModel,
    List<ProductAttributeModel> activeAttributes,
    List<ProductOverviewModel>? relatedProducts,
    List<ProductOverviewModel>? alsoPurchasedProducts,
    List<ProductOverviewModel>? similarProducts,
    List<ProductOverviewModel>? recentlyViewedProducts,
    String outOfStockButtonText,
    bool isLoading,
    bool isFailure,
    bool isProcessingAttribute,
    String? errorMessage,
  });

  $ProductDetailsModelCopyWith<$Res>? get productDetailsModel;
}

/// @nodoc
class _$ProductDetailViewModelCopyWithImpl<
  $Res,
  $Val extends ProductDetailViewModel
>
    implements $ProductDetailViewModelCopyWith<$Res> {
  _$ProductDetailViewModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductDetailViewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productDetailsModel = freezed,
    Object? activeAttributes = null,
    Object? relatedProducts = freezed,
    Object? alsoPurchasedProducts = freezed,
    Object? similarProducts = freezed,
    Object? recentlyViewedProducts = freezed,
    Object? outOfStockButtonText = null,
    Object? isLoading = null,
    Object? isFailure = null,
    Object? isProcessingAttribute = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            productDetailsModel:
                freezed == productDetailsModel
                    ? _value.productDetailsModel
                    : productDetailsModel // ignore: cast_nullable_to_non_nullable
                        as ProductDetailsModel?,
            activeAttributes:
                null == activeAttributes
                    ? _value.activeAttributes
                    : activeAttributes // ignore: cast_nullable_to_non_nullable
                        as List<ProductAttributeModel>,
            relatedProducts:
                freezed == relatedProducts
                    ? _value.relatedProducts
                    : relatedProducts // ignore: cast_nullable_to_non_nullable
                        as List<ProductOverviewModel>?,
            alsoPurchasedProducts:
                freezed == alsoPurchasedProducts
                    ? _value.alsoPurchasedProducts
                    : alsoPurchasedProducts // ignore: cast_nullable_to_non_nullable
                        as List<ProductOverviewModel>?,
            similarProducts:
                freezed == similarProducts
                    ? _value.similarProducts
                    : similarProducts // ignore: cast_nullable_to_non_nullable
                        as List<ProductOverviewModel>?,
            recentlyViewedProducts:
                freezed == recentlyViewedProducts
                    ? _value.recentlyViewedProducts
                    : recentlyViewedProducts // ignore: cast_nullable_to_non_nullable
                        as List<ProductOverviewModel>?,
            outOfStockButtonText:
                null == outOfStockButtonText
                    ? _value.outOfStockButtonText
                    : outOfStockButtonText // ignore: cast_nullable_to_non_nullable
                        as String,
            isLoading:
                null == isLoading
                    ? _value.isLoading
                    : isLoading // ignore: cast_nullable_to_non_nullable
                        as bool,
            isFailure:
                null == isFailure
                    ? _value.isFailure
                    : isFailure // ignore: cast_nullable_to_non_nullable
                        as bool,
            isProcessingAttribute:
                null == isProcessingAttribute
                    ? _value.isProcessingAttribute
                    : isProcessingAttribute // ignore: cast_nullable_to_non_nullable
                        as bool,
            errorMessage:
                freezed == errorMessage
                    ? _value.errorMessage
                    : errorMessage // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of ProductDetailViewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProductDetailsModelCopyWith<$Res>? get productDetailsModel {
    if (_value.productDetailsModel == null) {
      return null;
    }

    return $ProductDetailsModelCopyWith<$Res>(_value.productDetailsModel!, (
      value,
    ) {
      return _then(_value.copyWith(productDetailsModel: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ProductDetailViewModelImplCopyWith<$Res>
    implements $ProductDetailViewModelCopyWith<$Res> {
  factory _$$ProductDetailViewModelImplCopyWith(
    _$ProductDetailViewModelImpl value,
    $Res Function(_$ProductDetailViewModelImpl) then,
  ) = __$$ProductDetailViewModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    ProductDetailsModel? productDetailsModel,
    List<ProductAttributeModel> activeAttributes,
    List<ProductOverviewModel>? relatedProducts,
    List<ProductOverviewModel>? alsoPurchasedProducts,
    List<ProductOverviewModel>? similarProducts,
    List<ProductOverviewModel>? recentlyViewedProducts,
    String outOfStockButtonText,
    bool isLoading,
    bool isFailure,
    bool isProcessingAttribute,
    String? errorMessage,
  });

  @override
  $ProductDetailsModelCopyWith<$Res>? get productDetailsModel;
}

/// @nodoc
class __$$ProductDetailViewModelImplCopyWithImpl<$Res>
    extends
        _$ProductDetailViewModelCopyWithImpl<$Res, _$ProductDetailViewModelImpl>
    implements _$$ProductDetailViewModelImplCopyWith<$Res> {
  __$$ProductDetailViewModelImplCopyWithImpl(
    _$ProductDetailViewModelImpl _value,
    $Res Function(_$ProductDetailViewModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductDetailViewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productDetailsModel = freezed,
    Object? activeAttributes = null,
    Object? relatedProducts = freezed,
    Object? alsoPurchasedProducts = freezed,
    Object? similarProducts = freezed,
    Object? recentlyViewedProducts = freezed,
    Object? outOfStockButtonText = null,
    Object? isLoading = null,
    Object? isFailure = null,
    Object? isProcessingAttribute = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _$ProductDetailViewModelImpl(
        productDetailsModel:
            freezed == productDetailsModel
                ? _value.productDetailsModel
                : productDetailsModel // ignore: cast_nullable_to_non_nullable
                    as ProductDetailsModel?,
        activeAttributes:
            null == activeAttributes
                ? _value._activeAttributes
                : activeAttributes // ignore: cast_nullable_to_non_nullable
                    as List<ProductAttributeModel>,
        relatedProducts:
            freezed == relatedProducts
                ? _value._relatedProducts
                : relatedProducts // ignore: cast_nullable_to_non_nullable
                    as List<ProductOverviewModel>?,
        alsoPurchasedProducts:
            freezed == alsoPurchasedProducts
                ? _value._alsoPurchasedProducts
                : alsoPurchasedProducts // ignore: cast_nullable_to_non_nullable
                    as List<ProductOverviewModel>?,
        similarProducts:
            freezed == similarProducts
                ? _value._similarProducts
                : similarProducts // ignore: cast_nullable_to_non_nullable
                    as List<ProductOverviewModel>?,
        recentlyViewedProducts:
            freezed == recentlyViewedProducts
                ? _value._recentlyViewedProducts
                : recentlyViewedProducts // ignore: cast_nullable_to_non_nullable
                    as List<ProductOverviewModel>?,
        outOfStockButtonText:
            null == outOfStockButtonText
                ? _value.outOfStockButtonText
                : outOfStockButtonText // ignore: cast_nullable_to_non_nullable
                    as String,
        isLoading:
            null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                    as bool,
        isFailure:
            null == isFailure
                ? _value.isFailure
                : isFailure // ignore: cast_nullable_to_non_nullable
                    as bool,
        isProcessingAttribute:
            null == isProcessingAttribute
                ? _value.isProcessingAttribute
                : isProcessingAttribute // ignore: cast_nullable_to_non_nullable
                    as bool,
        errorMessage:
            freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc

class _$ProductDetailViewModelImpl implements _ProductDetailViewModel {
  const _$ProductDetailViewModelImpl({
    this.productDetailsModel,
    final List<ProductAttributeModel> activeAttributes = const [],
    final List<ProductOverviewModel>? relatedProducts,
    final List<ProductOverviewModel>? alsoPurchasedProducts,
    final List<ProductOverviewModel>? similarProducts,
    final List<ProductOverviewModel>? recentlyViewedProducts,
    required this.outOfStockButtonText,
    this.isLoading = true,
    this.isFailure = false,
    this.isProcessingAttribute = false,
    this.errorMessage,
  }) : _activeAttributes = activeAttributes,
       _relatedProducts = relatedProducts,
       _alsoPurchasedProducts = alsoPurchasedProducts,
       _similarProducts = similarProducts,
       _recentlyViewedProducts = recentlyViewedProducts;

  @override
  final ProductDetailsModel? productDetailsModel;
  final List<ProductAttributeModel> _activeAttributes;
  @override
  @JsonKey()
  List<ProductAttributeModel> get activeAttributes {
    if (_activeAttributes is EqualUnmodifiableListView)
      return _activeAttributes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_activeAttributes);
  }

  final List<ProductOverviewModel>? _relatedProducts;
  @override
  List<ProductOverviewModel>? get relatedProducts {
    final value = _relatedProducts;
    if (value == null) return null;
    if (_relatedProducts is EqualUnmodifiableListView) return _relatedProducts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<ProductOverviewModel>? _alsoPurchasedProducts;
  @override
  List<ProductOverviewModel>? get alsoPurchasedProducts {
    final value = _alsoPurchasedProducts;
    if (value == null) return null;
    if (_alsoPurchasedProducts is EqualUnmodifiableListView)
      return _alsoPurchasedProducts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<ProductOverviewModel>? _similarProducts;
  @override
  List<ProductOverviewModel>? get similarProducts {
    final value = _similarProducts;
    if (value == null) return null;
    if (_similarProducts is EqualUnmodifiableListView) return _similarProducts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<ProductOverviewModel>? _recentlyViewedProducts;
  @override
  List<ProductOverviewModel>? get recentlyViewedProducts {
    final value = _recentlyViewedProducts;
    if (value == null) return null;
    if (_recentlyViewedProducts is EqualUnmodifiableListView)
      return _recentlyViewedProducts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String outOfStockButtonText;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isFailure;
  @override
  @JsonKey()
  final bool isProcessingAttribute;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'ProductDetailViewModel(productDetailsModel: $productDetailsModel, activeAttributes: $activeAttributes, relatedProducts: $relatedProducts, alsoPurchasedProducts: $alsoPurchasedProducts, similarProducts: $similarProducts, recentlyViewedProducts: $recentlyViewedProducts, outOfStockButtonText: $outOfStockButtonText, isLoading: $isLoading, isFailure: $isFailure, isProcessingAttribute: $isProcessingAttribute, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductDetailViewModelImpl &&
            (identical(other.productDetailsModel, productDetailsModel) ||
                other.productDetailsModel == productDetailsModel) &&
            const DeepCollectionEquality().equals(
              other._activeAttributes,
              _activeAttributes,
            ) &&
            const DeepCollectionEquality().equals(
              other._relatedProducts,
              _relatedProducts,
            ) &&
            const DeepCollectionEquality().equals(
              other._alsoPurchasedProducts,
              _alsoPurchasedProducts,
            ) &&
            const DeepCollectionEquality().equals(
              other._similarProducts,
              _similarProducts,
            ) &&
            const DeepCollectionEquality().equals(
              other._recentlyViewedProducts,
              _recentlyViewedProducts,
            ) &&
            (identical(other.outOfStockButtonText, outOfStockButtonText) ||
                other.outOfStockButtonText == outOfStockButtonText) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isFailure, isFailure) ||
                other.isFailure == isFailure) &&
            (identical(other.isProcessingAttribute, isProcessingAttribute) ||
                other.isProcessingAttribute == isProcessingAttribute) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    productDetailsModel,
    const DeepCollectionEquality().hash(_activeAttributes),
    const DeepCollectionEquality().hash(_relatedProducts),
    const DeepCollectionEquality().hash(_alsoPurchasedProducts),
    const DeepCollectionEquality().hash(_similarProducts),
    const DeepCollectionEquality().hash(_recentlyViewedProducts),
    outOfStockButtonText,
    isLoading,
    isFailure,
    isProcessingAttribute,
    errorMessage,
  );

  /// Create a copy of ProductDetailViewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductDetailViewModelImplCopyWith<_$ProductDetailViewModelImpl>
  get copyWith =>
      __$$ProductDetailViewModelImplCopyWithImpl<_$ProductDetailViewModelImpl>(
        this,
        _$identity,
      );
}

abstract class _ProductDetailViewModel implements ProductDetailViewModel {
  const factory _ProductDetailViewModel({
    final ProductDetailsModel? productDetailsModel,
    final List<ProductAttributeModel> activeAttributes,
    final List<ProductOverviewModel>? relatedProducts,
    final List<ProductOverviewModel>? alsoPurchasedProducts,
    final List<ProductOverviewModel>? similarProducts,
    final List<ProductOverviewModel>? recentlyViewedProducts,
    required final String outOfStockButtonText,
    final bool isLoading,
    final bool isFailure,
    final bool isProcessingAttribute,
    final String? errorMessage,
  }) = _$ProductDetailViewModelImpl;

  @override
  ProductDetailsModel? get productDetailsModel;
  @override
  List<ProductAttributeModel> get activeAttributes;
  @override
  List<ProductOverviewModel>? get relatedProducts;
  @override
  List<ProductOverviewModel>? get alsoPurchasedProducts;
  @override
  List<ProductOverviewModel>? get similarProducts;
  @override
  List<ProductOverviewModel>? get recentlyViewedProducts;
  @override
  String get outOfStockButtonText;
  @override
  bool get isLoading;
  @override
  bool get isFailure;
  @override
  bool get isProcessingAttribute;
  @override
  String? get errorMessage;

  /// Create a copy of ProductDetailViewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductDetailViewModelImplCopyWith<_$ProductDetailViewModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
