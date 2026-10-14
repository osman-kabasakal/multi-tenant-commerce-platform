// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_overview_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ProductOverviewModel _$ProductOverviewModelFromJson(Map<String, dynamic> json) {
  return _ProductOverviewModel.fromJson(json);
}

/// @nodoc
mixin _$ProductOverviewModel {
  @JsonKey(name: 'Name', includeIfNull: false)
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'ShortDescription', includeIfNull: false)
  String? get shortDescription => throw _privateConstructorUsedError;
  @JsonKey(name: 'FullDescription', includeIfNull: false)
  String? get fullDescription => throw _privateConstructorUsedError;
  @JsonKey(name: 'SeName', includeIfNull: false)
  String? get seName => throw _privateConstructorUsedError;
  @JsonKey(name: 'Url', includeIfNull: false)
  String? get url => throw _privateConstructorUsedError;
  @JsonKey(name: 'ProductType', includeIfNull: false)
  ProductType? get productType => throw _privateConstructorUsedError;
  @JsonKey(name: 'MarkAsNew', includeIfNull: false)
  bool? get markAsNew => throw _privateConstructorUsedError;
  @JsonKey(name: 'Sku', includeIfNull: false)
  String? get sku => throw _privateConstructorUsedError;
  @JsonKey(name: 'Flag', includeIfNull: false)
  String? get flag => throw _privateConstructorUsedError;
  @JsonKey(name: 'Gtin', includeIfNull: false)
  String? get gtin => throw _privateConstructorUsedError;
  @JsonKey(name: 'Mpn', includeIfNull: false)
  String? get mpn => throw _privateConstructorUsedError;
  @JsonKey(name: 'BrandName', includeIfNull: false)
  String? get brandName => throw _privateConstructorUsedError;
  @JsonKey(name: 'IsFreeShipping', includeIfNull: false)
  bool? get isFreeShipping => throw _privateConstructorUsedError;
  @JsonKey(name: 'ShowSku', includeIfNull: false)
  bool? get showSku => throw _privateConstructorUsedError;
  @JsonKey(name: 'ShowQty', includeIfNull: false)
  bool? get showQty => throw _privateConstructorUsedError;
  @JsonKey(name: 'LowStock', includeIfNull: false)
  bool? get lowStock => throw _privateConstructorUsedError;
  @JsonKey(name: 'EndTime', includeIfNull: false)
  DateTime? get endTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'EndTimeLocalTime', includeIfNull: false)
  DateTime? get endTimeLocalTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'TaxDisplayType', includeIfNull: false)
  TaxDisplayType? get taxDisplayType => throw _privateConstructorUsedError;
  @JsonKey(name: 'Interval', includeIfNull: false)
  int? get interval => throw _privateConstructorUsedError;
  @JsonKey(name: 'IntervalUnitId', includeIfNull: false)
  IntervalUnit? get intervalUnitId => throw _privateConstructorUsedError;
  @JsonKey(name: 'ProductPrice', includeIfNull: false)
  ProductPriceModel? get productPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'DefaultPictureModel', includeIfNull: false)
  PictureModel? get defaultPictureModel => throw _privateConstructorUsedError;
  @JsonKey(name: 'SecondPictureModel', includeIfNull: false)
  PictureModel? get secondPictureModel => throw _privateConstructorUsedError;
  @JsonKey(name: 'SpecificationAttributeModels', includeIfNull: false)
  List<ProductSpecificationModel>? get specificationAttributeModels =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'ProductAttributeModels', includeIfNull: false)
  List<ProductAttributeModel>? get productAttributeModels =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'ReviewOverviewModel', includeIfNull: false)
  ProductReviewOverviewModel? get reviewOverviewModel =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this ProductOverviewModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProductOverviewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductOverviewModelCopyWith<ProductOverviewModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductOverviewModelCopyWith<$Res> {
  factory $ProductOverviewModelCopyWith(
    ProductOverviewModel value,
    $Res Function(ProductOverviewModel) then,
  ) = _$ProductOverviewModelCopyWithImpl<$Res, ProductOverviewModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'Name', includeIfNull: false) String? name,
    @JsonKey(name: 'ShortDescription', includeIfNull: false)
    String? shortDescription,
    @JsonKey(name: 'FullDescription', includeIfNull: false)
    String? fullDescription,
    @JsonKey(name: 'SeName', includeIfNull: false) String? seName,
    @JsonKey(name: 'Url', includeIfNull: false) String? url,
    @JsonKey(name: 'ProductType', includeIfNull: false)
    ProductType? productType,
    @JsonKey(name: 'MarkAsNew', includeIfNull: false) bool? markAsNew,
    @JsonKey(name: 'Sku', includeIfNull: false) String? sku,
    @JsonKey(name: 'Flag', includeIfNull: false) String? flag,
    @JsonKey(name: 'Gtin', includeIfNull: false) String? gtin,
    @JsonKey(name: 'Mpn', includeIfNull: false) String? mpn,
    @JsonKey(name: 'BrandName', includeIfNull: false) String? brandName,
    @JsonKey(name: 'IsFreeShipping', includeIfNull: false) bool? isFreeShipping,
    @JsonKey(name: 'ShowSku', includeIfNull: false) bool? showSku,
    @JsonKey(name: 'ShowQty', includeIfNull: false) bool? showQty,
    @JsonKey(name: 'LowStock', includeIfNull: false) bool? lowStock,
    @JsonKey(name: 'EndTime', includeIfNull: false) DateTime? endTime,
    @JsonKey(name: 'EndTimeLocalTime', includeIfNull: false)
    DateTime? endTimeLocalTime,
    @JsonKey(name: 'TaxDisplayType', includeIfNull: false)
    TaxDisplayType? taxDisplayType,
    @JsonKey(name: 'Interval', includeIfNull: false) int? interval,
    @JsonKey(name: 'IntervalUnitId', includeIfNull: false)
    IntervalUnit? intervalUnitId,
    @JsonKey(name: 'ProductPrice', includeIfNull: false)
    ProductPriceModel? productPrice,
    @JsonKey(name: 'DefaultPictureModel', includeIfNull: false)
    PictureModel? defaultPictureModel,
    @JsonKey(name: 'SecondPictureModel', includeIfNull: false)
    PictureModel? secondPictureModel,
    @JsonKey(name: 'SpecificationAttributeModels', includeIfNull: false)
    List<ProductSpecificationModel>? specificationAttributeModels,
    @JsonKey(name: 'ProductAttributeModels', includeIfNull: false)
    List<ProductAttributeModel>? productAttributeModels,
    @JsonKey(name: 'ReviewOverviewModel', includeIfNull: false)
    ProductReviewOverviewModel? reviewOverviewModel,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  $ProductPriceModelCopyWith<$Res>? get productPrice;
  $PictureModelCopyWith<$Res>? get defaultPictureModel;
  $PictureModelCopyWith<$Res>? get secondPictureModel;
  $ProductReviewOverviewModelCopyWith<$Res>? get reviewOverviewModel;
}

/// @nodoc
class _$ProductOverviewModelCopyWithImpl<
  $Res,
  $Val extends ProductOverviewModel
>
    implements $ProductOverviewModelCopyWith<$Res> {
  _$ProductOverviewModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductOverviewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? shortDescription = freezed,
    Object? fullDescription = freezed,
    Object? seName = freezed,
    Object? url = freezed,
    Object? productType = freezed,
    Object? markAsNew = freezed,
    Object? sku = freezed,
    Object? flag = freezed,
    Object? gtin = freezed,
    Object? mpn = freezed,
    Object? brandName = freezed,
    Object? isFreeShipping = freezed,
    Object? showSku = freezed,
    Object? showQty = freezed,
    Object? lowStock = freezed,
    Object? endTime = freezed,
    Object? endTimeLocalTime = freezed,
    Object? taxDisplayType = freezed,
    Object? interval = freezed,
    Object? intervalUnitId = freezed,
    Object? productPrice = freezed,
    Object? defaultPictureModel = freezed,
    Object? secondPictureModel = freezed,
    Object? specificationAttributeModels = freezed,
    Object? productAttributeModels = freezed,
    Object? reviewOverviewModel = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            name:
                freezed == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String?,
            shortDescription:
                freezed == shortDescription
                    ? _value.shortDescription
                    : shortDescription // ignore: cast_nullable_to_non_nullable
                        as String?,
            fullDescription:
                freezed == fullDescription
                    ? _value.fullDescription
                    : fullDescription // ignore: cast_nullable_to_non_nullable
                        as String?,
            seName:
                freezed == seName
                    ? _value.seName
                    : seName // ignore: cast_nullable_to_non_nullable
                        as String?,
            url:
                freezed == url
                    ? _value.url
                    : url // ignore: cast_nullable_to_non_nullable
                        as String?,
            productType:
                freezed == productType
                    ? _value.productType
                    : productType // ignore: cast_nullable_to_non_nullable
                        as ProductType?,
            markAsNew:
                freezed == markAsNew
                    ? _value.markAsNew
                    : markAsNew // ignore: cast_nullable_to_non_nullable
                        as bool?,
            sku:
                freezed == sku
                    ? _value.sku
                    : sku // ignore: cast_nullable_to_non_nullable
                        as String?,
            flag:
                freezed == flag
                    ? _value.flag
                    : flag // ignore: cast_nullable_to_non_nullable
                        as String?,
            gtin:
                freezed == gtin
                    ? _value.gtin
                    : gtin // ignore: cast_nullable_to_non_nullable
                        as String?,
            mpn:
                freezed == mpn
                    ? _value.mpn
                    : mpn // ignore: cast_nullable_to_non_nullable
                        as String?,
            brandName:
                freezed == brandName
                    ? _value.brandName
                    : brandName // ignore: cast_nullable_to_non_nullable
                        as String?,
            isFreeShipping:
                freezed == isFreeShipping
                    ? _value.isFreeShipping
                    : isFreeShipping // ignore: cast_nullable_to_non_nullable
                        as bool?,
            showSku:
                freezed == showSku
                    ? _value.showSku
                    : showSku // ignore: cast_nullable_to_non_nullable
                        as bool?,
            showQty:
                freezed == showQty
                    ? _value.showQty
                    : showQty // ignore: cast_nullable_to_non_nullable
                        as bool?,
            lowStock:
                freezed == lowStock
                    ? _value.lowStock
                    : lowStock // ignore: cast_nullable_to_non_nullable
                        as bool?,
            endTime:
                freezed == endTime
                    ? _value.endTime
                    : endTime // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            endTimeLocalTime:
                freezed == endTimeLocalTime
                    ? _value.endTimeLocalTime
                    : endTimeLocalTime // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            taxDisplayType:
                freezed == taxDisplayType
                    ? _value.taxDisplayType
                    : taxDisplayType // ignore: cast_nullable_to_non_nullable
                        as TaxDisplayType?,
            interval:
                freezed == interval
                    ? _value.interval
                    : interval // ignore: cast_nullable_to_non_nullable
                        as int?,
            intervalUnitId:
                freezed == intervalUnitId
                    ? _value.intervalUnitId
                    : intervalUnitId // ignore: cast_nullable_to_non_nullable
                        as IntervalUnit?,
            productPrice:
                freezed == productPrice
                    ? _value.productPrice
                    : productPrice // ignore: cast_nullable_to_non_nullable
                        as ProductPriceModel?,
            defaultPictureModel:
                freezed == defaultPictureModel
                    ? _value.defaultPictureModel
                    : defaultPictureModel // ignore: cast_nullable_to_non_nullable
                        as PictureModel?,
            secondPictureModel:
                freezed == secondPictureModel
                    ? _value.secondPictureModel
                    : secondPictureModel // ignore: cast_nullable_to_non_nullable
                        as PictureModel?,
            specificationAttributeModels:
                freezed == specificationAttributeModels
                    ? _value.specificationAttributeModels
                    : specificationAttributeModels // ignore: cast_nullable_to_non_nullable
                        as List<ProductSpecificationModel>?,
            productAttributeModels:
                freezed == productAttributeModels
                    ? _value.productAttributeModels
                    : productAttributeModels // ignore: cast_nullable_to_non_nullable
                        as List<ProductAttributeModel>?,
            reviewOverviewModel:
                freezed == reviewOverviewModel
                    ? _value.reviewOverviewModel
                    : reviewOverviewModel // ignore: cast_nullable_to_non_nullable
                        as ProductReviewOverviewModel?,
            id:
                freezed == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String?,
            userFields:
                freezed == userFields
                    ? _value.userFields
                    : userFields // ignore: cast_nullable_to_non_nullable
                        as List<UserField>?,
          )
          as $Val,
    );
  }

  /// Create a copy of ProductOverviewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProductPriceModelCopyWith<$Res>? get productPrice {
    if (_value.productPrice == null) {
      return null;
    }

    return $ProductPriceModelCopyWith<$Res>(_value.productPrice!, (value) {
      return _then(_value.copyWith(productPrice: value) as $Val);
    });
  }

  /// Create a copy of ProductOverviewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PictureModelCopyWith<$Res>? get defaultPictureModel {
    if (_value.defaultPictureModel == null) {
      return null;
    }

    return $PictureModelCopyWith<$Res>(_value.defaultPictureModel!, (value) {
      return _then(_value.copyWith(defaultPictureModel: value) as $Val);
    });
  }

  /// Create a copy of ProductOverviewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PictureModelCopyWith<$Res>? get secondPictureModel {
    if (_value.secondPictureModel == null) {
      return null;
    }

    return $PictureModelCopyWith<$Res>(_value.secondPictureModel!, (value) {
      return _then(_value.copyWith(secondPictureModel: value) as $Val);
    });
  }

  /// Create a copy of ProductOverviewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProductReviewOverviewModelCopyWith<$Res>? get reviewOverviewModel {
    if (_value.reviewOverviewModel == null) {
      return null;
    }

    return $ProductReviewOverviewModelCopyWith<$Res>(
      _value.reviewOverviewModel!,
      (value) {
        return _then(_value.copyWith(reviewOverviewModel: value) as $Val);
      },
    );
  }
}

/// @nodoc
abstract class _$$ProductOverviewModelImplCopyWith<$Res>
    implements $ProductOverviewModelCopyWith<$Res> {
  factory _$$ProductOverviewModelImplCopyWith(
    _$ProductOverviewModelImpl value,
    $Res Function(_$ProductOverviewModelImpl) then,
  ) = __$$ProductOverviewModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'Name', includeIfNull: false) String? name,
    @JsonKey(name: 'ShortDescription', includeIfNull: false)
    String? shortDescription,
    @JsonKey(name: 'FullDescription', includeIfNull: false)
    String? fullDescription,
    @JsonKey(name: 'SeName', includeIfNull: false) String? seName,
    @JsonKey(name: 'Url', includeIfNull: false) String? url,
    @JsonKey(name: 'ProductType', includeIfNull: false)
    ProductType? productType,
    @JsonKey(name: 'MarkAsNew', includeIfNull: false) bool? markAsNew,
    @JsonKey(name: 'Sku', includeIfNull: false) String? sku,
    @JsonKey(name: 'Flag', includeIfNull: false) String? flag,
    @JsonKey(name: 'Gtin', includeIfNull: false) String? gtin,
    @JsonKey(name: 'Mpn', includeIfNull: false) String? mpn,
    @JsonKey(name: 'BrandName', includeIfNull: false) String? brandName,
    @JsonKey(name: 'IsFreeShipping', includeIfNull: false) bool? isFreeShipping,
    @JsonKey(name: 'ShowSku', includeIfNull: false) bool? showSku,
    @JsonKey(name: 'ShowQty', includeIfNull: false) bool? showQty,
    @JsonKey(name: 'LowStock', includeIfNull: false) bool? lowStock,
    @JsonKey(name: 'EndTime', includeIfNull: false) DateTime? endTime,
    @JsonKey(name: 'EndTimeLocalTime', includeIfNull: false)
    DateTime? endTimeLocalTime,
    @JsonKey(name: 'TaxDisplayType', includeIfNull: false)
    TaxDisplayType? taxDisplayType,
    @JsonKey(name: 'Interval', includeIfNull: false) int? interval,
    @JsonKey(name: 'IntervalUnitId', includeIfNull: false)
    IntervalUnit? intervalUnitId,
    @JsonKey(name: 'ProductPrice', includeIfNull: false)
    ProductPriceModel? productPrice,
    @JsonKey(name: 'DefaultPictureModel', includeIfNull: false)
    PictureModel? defaultPictureModel,
    @JsonKey(name: 'SecondPictureModel', includeIfNull: false)
    PictureModel? secondPictureModel,
    @JsonKey(name: 'SpecificationAttributeModels', includeIfNull: false)
    List<ProductSpecificationModel>? specificationAttributeModels,
    @JsonKey(name: 'ProductAttributeModels', includeIfNull: false)
    List<ProductAttributeModel>? productAttributeModels,
    @JsonKey(name: 'ReviewOverviewModel', includeIfNull: false)
    ProductReviewOverviewModel? reviewOverviewModel,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  @override
  $ProductPriceModelCopyWith<$Res>? get productPrice;
  @override
  $PictureModelCopyWith<$Res>? get defaultPictureModel;
  @override
  $PictureModelCopyWith<$Res>? get secondPictureModel;
  @override
  $ProductReviewOverviewModelCopyWith<$Res>? get reviewOverviewModel;
}

/// @nodoc
class __$$ProductOverviewModelImplCopyWithImpl<$Res>
    extends _$ProductOverviewModelCopyWithImpl<$Res, _$ProductOverviewModelImpl>
    implements _$$ProductOverviewModelImplCopyWith<$Res> {
  __$$ProductOverviewModelImplCopyWithImpl(
    _$ProductOverviewModelImpl _value,
    $Res Function(_$ProductOverviewModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductOverviewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? shortDescription = freezed,
    Object? fullDescription = freezed,
    Object? seName = freezed,
    Object? url = freezed,
    Object? productType = freezed,
    Object? markAsNew = freezed,
    Object? sku = freezed,
    Object? flag = freezed,
    Object? gtin = freezed,
    Object? mpn = freezed,
    Object? brandName = freezed,
    Object? isFreeShipping = freezed,
    Object? showSku = freezed,
    Object? showQty = freezed,
    Object? lowStock = freezed,
    Object? endTime = freezed,
    Object? endTimeLocalTime = freezed,
    Object? taxDisplayType = freezed,
    Object? interval = freezed,
    Object? intervalUnitId = freezed,
    Object? productPrice = freezed,
    Object? defaultPictureModel = freezed,
    Object? secondPictureModel = freezed,
    Object? specificationAttributeModels = freezed,
    Object? productAttributeModels = freezed,
    Object? reviewOverviewModel = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$ProductOverviewModelImpl(
        name:
            freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String?,
        shortDescription:
            freezed == shortDescription
                ? _value.shortDescription
                : shortDescription // ignore: cast_nullable_to_non_nullable
                    as String?,
        fullDescription:
            freezed == fullDescription
                ? _value.fullDescription
                : fullDescription // ignore: cast_nullable_to_non_nullable
                    as String?,
        seName:
            freezed == seName
                ? _value.seName
                : seName // ignore: cast_nullable_to_non_nullable
                    as String?,
        url:
            freezed == url
                ? _value.url
                : url // ignore: cast_nullable_to_non_nullable
                    as String?,
        productType:
            freezed == productType
                ? _value.productType
                : productType // ignore: cast_nullable_to_non_nullable
                    as ProductType?,
        markAsNew:
            freezed == markAsNew
                ? _value.markAsNew
                : markAsNew // ignore: cast_nullable_to_non_nullable
                    as bool?,
        sku:
            freezed == sku
                ? _value.sku
                : sku // ignore: cast_nullable_to_non_nullable
                    as String?,
        flag:
            freezed == flag
                ? _value.flag
                : flag // ignore: cast_nullable_to_non_nullable
                    as String?,
        gtin:
            freezed == gtin
                ? _value.gtin
                : gtin // ignore: cast_nullable_to_non_nullable
                    as String?,
        mpn:
            freezed == mpn
                ? _value.mpn
                : mpn // ignore: cast_nullable_to_non_nullable
                    as String?,
        brandName:
            freezed == brandName
                ? _value.brandName
                : brandName // ignore: cast_nullable_to_non_nullable
                    as String?,
        isFreeShipping:
            freezed == isFreeShipping
                ? _value.isFreeShipping
                : isFreeShipping // ignore: cast_nullable_to_non_nullable
                    as bool?,
        showSku:
            freezed == showSku
                ? _value.showSku
                : showSku // ignore: cast_nullable_to_non_nullable
                    as bool?,
        showQty:
            freezed == showQty
                ? _value.showQty
                : showQty // ignore: cast_nullable_to_non_nullable
                    as bool?,
        lowStock:
            freezed == lowStock
                ? _value.lowStock
                : lowStock // ignore: cast_nullable_to_non_nullable
                    as bool?,
        endTime:
            freezed == endTime
                ? _value.endTime
                : endTime // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        endTimeLocalTime:
            freezed == endTimeLocalTime
                ? _value.endTimeLocalTime
                : endTimeLocalTime // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        taxDisplayType:
            freezed == taxDisplayType
                ? _value.taxDisplayType
                : taxDisplayType // ignore: cast_nullable_to_non_nullable
                    as TaxDisplayType?,
        interval:
            freezed == interval
                ? _value.interval
                : interval // ignore: cast_nullable_to_non_nullable
                    as int?,
        intervalUnitId:
            freezed == intervalUnitId
                ? _value.intervalUnitId
                : intervalUnitId // ignore: cast_nullable_to_non_nullable
                    as IntervalUnit?,
        productPrice:
            freezed == productPrice
                ? _value.productPrice
                : productPrice // ignore: cast_nullable_to_non_nullable
                    as ProductPriceModel?,
        defaultPictureModel:
            freezed == defaultPictureModel
                ? _value.defaultPictureModel
                : defaultPictureModel // ignore: cast_nullable_to_non_nullable
                    as PictureModel?,
        secondPictureModel:
            freezed == secondPictureModel
                ? _value.secondPictureModel
                : secondPictureModel // ignore: cast_nullable_to_non_nullable
                    as PictureModel?,
        specificationAttributeModels:
            freezed == specificationAttributeModels
                ? _value._specificationAttributeModels
                : specificationAttributeModels // ignore: cast_nullable_to_non_nullable
                    as List<ProductSpecificationModel>?,
        productAttributeModels:
            freezed == productAttributeModels
                ? _value._productAttributeModels
                : productAttributeModels // ignore: cast_nullable_to_non_nullable
                    as List<ProductAttributeModel>?,
        reviewOverviewModel:
            freezed == reviewOverviewModel
                ? _value.reviewOverviewModel
                : reviewOverviewModel // ignore: cast_nullable_to_non_nullable
                    as ProductReviewOverviewModel?,
        id:
            freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String?,
        userFields:
            freezed == userFields
                ? _value._userFields
                : userFields // ignore: cast_nullable_to_non_nullable
                    as List<UserField>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductOverviewModelImpl implements _ProductOverviewModel {
  _$ProductOverviewModelImpl({
    @JsonKey(name: 'Name', includeIfNull: false) this.name,
    @JsonKey(name: 'ShortDescription', includeIfNull: false)
    this.shortDescription,
    @JsonKey(name: 'FullDescription', includeIfNull: false)
    this.fullDescription,
    @JsonKey(name: 'SeName', includeIfNull: false) this.seName,
    @JsonKey(name: 'Url', includeIfNull: false) this.url,
    @JsonKey(name: 'ProductType', includeIfNull: false)
    this.productType = ProductType.simpleProduct,
    @JsonKey(name: 'MarkAsNew', includeIfNull: false) this.markAsNew = false,
    @JsonKey(name: 'Sku', includeIfNull: false) this.sku,
    @JsonKey(name: 'Flag', includeIfNull: false) this.flag,
    @JsonKey(name: 'Gtin', includeIfNull: false) this.gtin,
    @JsonKey(name: 'Mpn', includeIfNull: false) this.mpn,
    @JsonKey(name: 'BrandName', includeIfNull: false) this.brandName,
    @JsonKey(name: 'IsFreeShipping', includeIfNull: false)
    this.isFreeShipping = false,
    @JsonKey(name: 'ShowSku', includeIfNull: false) this.showSku = false,
    @JsonKey(name: 'ShowQty', includeIfNull: false) this.showQty = false,
    @JsonKey(name: 'LowStock', includeIfNull: false) this.lowStock = false,
    @JsonKey(name: 'EndTime', includeIfNull: false) this.endTime = null,
    @JsonKey(name: 'EndTimeLocalTime', includeIfNull: false)
    this.endTimeLocalTime = null,
    @JsonKey(name: 'TaxDisplayType', includeIfNull: false)
    this.taxDisplayType = TaxDisplayType.includingTax,
    @JsonKey(name: 'Interval', includeIfNull: false) this.interval,
    @JsonKey(name: 'IntervalUnitId', includeIfNull: false)
    this.intervalUnitId = IntervalUnit.minute,
    @JsonKey(name: 'ProductPrice', includeIfNull: false) this.productPrice,
    @JsonKey(name: 'DefaultPictureModel', includeIfNull: false)
    this.defaultPictureModel,
    @JsonKey(name: 'SecondPictureModel', includeIfNull: false)
    this.secondPictureModel,
    @JsonKey(name: 'SpecificationAttributeModels', includeIfNull: false)
    final List<ProductSpecificationModel>? specificationAttributeModels =
        const [],
    @JsonKey(name: 'ProductAttributeModels', includeIfNull: false)
    final List<ProductAttributeModel>? productAttributeModels = const [],
    @JsonKey(name: 'ReviewOverviewModel', includeIfNull: false)
    this.reviewOverviewModel,
    @JsonKey(name: 'Id', includeIfNull: false) this.id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _specificationAttributeModels = specificationAttributeModels,
       _productAttributeModels = productAttributeModels,
       _userFields = userFields;

  factory _$ProductOverviewModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductOverviewModelImplFromJson(json);

  @override
  @JsonKey(name: 'Name', includeIfNull: false)
  final String? name;
  @override
  @JsonKey(name: 'ShortDescription', includeIfNull: false)
  final String? shortDescription;
  @override
  @JsonKey(name: 'FullDescription', includeIfNull: false)
  final String? fullDescription;
  @override
  @JsonKey(name: 'SeName', includeIfNull: false)
  final String? seName;
  @override
  @JsonKey(name: 'Url', includeIfNull: false)
  final String? url;
  @override
  @JsonKey(name: 'ProductType', includeIfNull: false)
  final ProductType? productType;
  @override
  @JsonKey(name: 'MarkAsNew', includeIfNull: false)
  final bool? markAsNew;
  @override
  @JsonKey(name: 'Sku', includeIfNull: false)
  final String? sku;
  @override
  @JsonKey(name: 'Flag', includeIfNull: false)
  final String? flag;
  @override
  @JsonKey(name: 'Gtin', includeIfNull: false)
  final String? gtin;
  @override
  @JsonKey(name: 'Mpn', includeIfNull: false)
  final String? mpn;
  @override
  @JsonKey(name: 'BrandName', includeIfNull: false)
  final String? brandName;
  @override
  @JsonKey(name: 'IsFreeShipping', includeIfNull: false)
  final bool? isFreeShipping;
  @override
  @JsonKey(name: 'ShowSku', includeIfNull: false)
  final bool? showSku;
  @override
  @JsonKey(name: 'ShowQty', includeIfNull: false)
  final bool? showQty;
  @override
  @JsonKey(name: 'LowStock', includeIfNull: false)
  final bool? lowStock;
  @override
  @JsonKey(name: 'EndTime', includeIfNull: false)
  final DateTime? endTime;
  @override
  @JsonKey(name: 'EndTimeLocalTime', includeIfNull: false)
  final DateTime? endTimeLocalTime;
  @override
  @JsonKey(name: 'TaxDisplayType', includeIfNull: false)
  final TaxDisplayType? taxDisplayType;
  @override
  @JsonKey(name: 'Interval', includeIfNull: false)
  final int? interval;
  @override
  @JsonKey(name: 'IntervalUnitId', includeIfNull: false)
  final IntervalUnit? intervalUnitId;
  @override
  @JsonKey(name: 'ProductPrice', includeIfNull: false)
  final ProductPriceModel? productPrice;
  @override
  @JsonKey(name: 'DefaultPictureModel', includeIfNull: false)
  final PictureModel? defaultPictureModel;
  @override
  @JsonKey(name: 'SecondPictureModel', includeIfNull: false)
  final PictureModel? secondPictureModel;
  final List<ProductSpecificationModel>? _specificationAttributeModels;
  @override
  @JsonKey(name: 'SpecificationAttributeModels', includeIfNull: false)
  List<ProductSpecificationModel>? get specificationAttributeModels {
    final value = _specificationAttributeModels;
    if (value == null) return null;
    if (_specificationAttributeModels is EqualUnmodifiableListView)
      return _specificationAttributeModels;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<ProductAttributeModel>? _productAttributeModels;
  @override
  @JsonKey(name: 'ProductAttributeModels', includeIfNull: false)
  List<ProductAttributeModel>? get productAttributeModels {
    final value = _productAttributeModels;
    if (value == null) return null;
    if (_productAttributeModels is EqualUnmodifiableListView)
      return _productAttributeModels;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'ReviewOverviewModel', includeIfNull: false)
  final ProductReviewOverviewModel? reviewOverviewModel;
  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  final String? id;
  final List<UserField>? _userFields;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields {
    final value = _userFields;
    if (value == null) return null;
    if (_userFields is EqualUnmodifiableListView) return _userFields;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'ProductOverviewModel(name: $name, shortDescription: $shortDescription, fullDescription: $fullDescription, seName: $seName, url: $url, productType: $productType, markAsNew: $markAsNew, sku: $sku, flag: $flag, gtin: $gtin, mpn: $mpn, brandName: $brandName, isFreeShipping: $isFreeShipping, showSku: $showSku, showQty: $showQty, lowStock: $lowStock, endTime: $endTime, endTimeLocalTime: $endTimeLocalTime, taxDisplayType: $taxDisplayType, interval: $interval, intervalUnitId: $intervalUnitId, productPrice: $productPrice, defaultPictureModel: $defaultPictureModel, secondPictureModel: $secondPictureModel, specificationAttributeModels: $specificationAttributeModels, productAttributeModels: $productAttributeModels, reviewOverviewModel: $reviewOverviewModel, id: $id, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductOverviewModelImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.shortDescription, shortDescription) ||
                other.shortDescription == shortDescription) &&
            (identical(other.fullDescription, fullDescription) ||
                other.fullDescription == fullDescription) &&
            (identical(other.seName, seName) || other.seName == seName) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.productType, productType) ||
                other.productType == productType) &&
            (identical(other.markAsNew, markAsNew) ||
                other.markAsNew == markAsNew) &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.flag, flag) || other.flag == flag) &&
            (identical(other.gtin, gtin) || other.gtin == gtin) &&
            (identical(other.mpn, mpn) || other.mpn == mpn) &&
            (identical(other.brandName, brandName) ||
                other.brandName == brandName) &&
            (identical(other.isFreeShipping, isFreeShipping) ||
                other.isFreeShipping == isFreeShipping) &&
            (identical(other.showSku, showSku) || other.showSku == showSku) &&
            (identical(other.showQty, showQty) || other.showQty == showQty) &&
            (identical(other.lowStock, lowStock) ||
                other.lowStock == lowStock) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.endTimeLocalTime, endTimeLocalTime) ||
                other.endTimeLocalTime == endTimeLocalTime) &&
            (identical(other.taxDisplayType, taxDisplayType) ||
                other.taxDisplayType == taxDisplayType) &&
            (identical(other.interval, interval) ||
                other.interval == interval) &&
            (identical(other.intervalUnitId, intervalUnitId) ||
                other.intervalUnitId == intervalUnitId) &&
            (identical(other.productPrice, productPrice) ||
                other.productPrice == productPrice) &&
            (identical(other.defaultPictureModel, defaultPictureModel) ||
                other.defaultPictureModel == defaultPictureModel) &&
            (identical(other.secondPictureModel, secondPictureModel) ||
                other.secondPictureModel == secondPictureModel) &&
            const DeepCollectionEquality().equals(
              other._specificationAttributeModels,
              _specificationAttributeModels,
            ) &&
            const DeepCollectionEquality().equals(
              other._productAttributeModels,
              _productAttributeModels,
            ) &&
            (identical(other.reviewOverviewModel, reviewOverviewModel) ||
                other.reviewOverviewModel == reviewOverviewModel) &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality().equals(
              other._userFields,
              _userFields,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    name,
    shortDescription,
    fullDescription,
    seName,
    url,
    productType,
    markAsNew,
    sku,
    flag,
    gtin,
    mpn,
    brandName,
    isFreeShipping,
    showSku,
    showQty,
    lowStock,
    endTime,
    endTimeLocalTime,
    taxDisplayType,
    interval,
    intervalUnitId,
    productPrice,
    defaultPictureModel,
    secondPictureModel,
    const DeepCollectionEquality().hash(_specificationAttributeModels),
    const DeepCollectionEquality().hash(_productAttributeModels),
    reviewOverviewModel,
    id,
    const DeepCollectionEquality().hash(_userFields),
  ]);

  /// Create a copy of ProductOverviewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductOverviewModelImplCopyWith<_$ProductOverviewModelImpl>
  get copyWith =>
      __$$ProductOverviewModelImplCopyWithImpl<_$ProductOverviewModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductOverviewModelImplToJson(this);
  }
}

abstract class _ProductOverviewModel implements ProductOverviewModel {
  factory _ProductOverviewModel({
    @JsonKey(name: 'Name', includeIfNull: false) final String? name,
    @JsonKey(name: 'ShortDescription', includeIfNull: false)
    final String? shortDescription,
    @JsonKey(name: 'FullDescription', includeIfNull: false)
    final String? fullDescription,
    @JsonKey(name: 'SeName', includeIfNull: false) final String? seName,
    @JsonKey(name: 'Url', includeIfNull: false) final String? url,
    @JsonKey(name: 'ProductType', includeIfNull: false)
    final ProductType? productType,
    @JsonKey(name: 'MarkAsNew', includeIfNull: false) final bool? markAsNew,
    @JsonKey(name: 'Sku', includeIfNull: false) final String? sku,
    @JsonKey(name: 'Flag', includeIfNull: false) final String? flag,
    @JsonKey(name: 'Gtin', includeIfNull: false) final String? gtin,
    @JsonKey(name: 'Mpn', includeIfNull: false) final String? mpn,
    @JsonKey(name: 'BrandName', includeIfNull: false) final String? brandName,
    @JsonKey(name: 'IsFreeShipping', includeIfNull: false)
    final bool? isFreeShipping,
    @JsonKey(name: 'ShowSku', includeIfNull: false) final bool? showSku,
    @JsonKey(name: 'ShowQty', includeIfNull: false) final bool? showQty,
    @JsonKey(name: 'LowStock', includeIfNull: false) final bool? lowStock,
    @JsonKey(name: 'EndTime', includeIfNull: false) final DateTime? endTime,
    @JsonKey(name: 'EndTimeLocalTime', includeIfNull: false)
    final DateTime? endTimeLocalTime,
    @JsonKey(name: 'TaxDisplayType', includeIfNull: false)
    final TaxDisplayType? taxDisplayType,
    @JsonKey(name: 'Interval', includeIfNull: false) final int? interval,
    @JsonKey(name: 'IntervalUnitId', includeIfNull: false)
    final IntervalUnit? intervalUnitId,
    @JsonKey(name: 'ProductPrice', includeIfNull: false)
    final ProductPriceModel? productPrice,
    @JsonKey(name: 'DefaultPictureModel', includeIfNull: false)
    final PictureModel? defaultPictureModel,
    @JsonKey(name: 'SecondPictureModel', includeIfNull: false)
    final PictureModel? secondPictureModel,
    @JsonKey(name: 'SpecificationAttributeModels', includeIfNull: false)
    final List<ProductSpecificationModel>? specificationAttributeModels,
    @JsonKey(name: 'ProductAttributeModels', includeIfNull: false)
    final List<ProductAttributeModel>? productAttributeModels,
    @JsonKey(name: 'ReviewOverviewModel', includeIfNull: false)
    final ProductReviewOverviewModel? reviewOverviewModel,
    @JsonKey(name: 'Id', includeIfNull: false) final String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$ProductOverviewModelImpl;

  factory _ProductOverviewModel.fromJson(Map<String, dynamic> json) =
      _$ProductOverviewModelImpl.fromJson;

  @override
  @JsonKey(name: 'Name', includeIfNull: false)
  String? get name;
  @override
  @JsonKey(name: 'ShortDescription', includeIfNull: false)
  String? get shortDescription;
  @override
  @JsonKey(name: 'FullDescription', includeIfNull: false)
  String? get fullDescription;
  @override
  @JsonKey(name: 'SeName', includeIfNull: false)
  String? get seName;
  @override
  @JsonKey(name: 'Url', includeIfNull: false)
  String? get url;
  @override
  @JsonKey(name: 'ProductType', includeIfNull: false)
  ProductType? get productType;
  @override
  @JsonKey(name: 'MarkAsNew', includeIfNull: false)
  bool? get markAsNew;
  @override
  @JsonKey(name: 'Sku', includeIfNull: false)
  String? get sku;
  @override
  @JsonKey(name: 'Flag', includeIfNull: false)
  String? get flag;
  @override
  @JsonKey(name: 'Gtin', includeIfNull: false)
  String? get gtin;
  @override
  @JsonKey(name: 'Mpn', includeIfNull: false)
  String? get mpn;
  @override
  @JsonKey(name: 'BrandName', includeIfNull: false)
  String? get brandName;
  @override
  @JsonKey(name: 'IsFreeShipping', includeIfNull: false)
  bool? get isFreeShipping;
  @override
  @JsonKey(name: 'ShowSku', includeIfNull: false)
  bool? get showSku;
  @override
  @JsonKey(name: 'ShowQty', includeIfNull: false)
  bool? get showQty;
  @override
  @JsonKey(name: 'LowStock', includeIfNull: false)
  bool? get lowStock;
  @override
  @JsonKey(name: 'EndTime', includeIfNull: false)
  DateTime? get endTime;
  @override
  @JsonKey(name: 'EndTimeLocalTime', includeIfNull: false)
  DateTime? get endTimeLocalTime;
  @override
  @JsonKey(name: 'TaxDisplayType', includeIfNull: false)
  TaxDisplayType? get taxDisplayType;
  @override
  @JsonKey(name: 'Interval', includeIfNull: false)
  int? get interval;
  @override
  @JsonKey(name: 'IntervalUnitId', includeIfNull: false)
  IntervalUnit? get intervalUnitId;
  @override
  @JsonKey(name: 'ProductPrice', includeIfNull: false)
  ProductPriceModel? get productPrice;
  @override
  @JsonKey(name: 'DefaultPictureModel', includeIfNull: false)
  PictureModel? get defaultPictureModel;
  @override
  @JsonKey(name: 'SecondPictureModel', includeIfNull: false)
  PictureModel? get secondPictureModel;
  @override
  @JsonKey(name: 'SpecificationAttributeModels', includeIfNull: false)
  List<ProductSpecificationModel>? get specificationAttributeModels;
  @override
  @JsonKey(name: 'ProductAttributeModels', includeIfNull: false)
  List<ProductAttributeModel>? get productAttributeModels;
  @override
  @JsonKey(name: 'ReviewOverviewModel', includeIfNull: false)
  ProductReviewOverviewModel? get reviewOverviewModel;
  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of ProductOverviewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductOverviewModelImplCopyWith<_$ProductOverviewModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
