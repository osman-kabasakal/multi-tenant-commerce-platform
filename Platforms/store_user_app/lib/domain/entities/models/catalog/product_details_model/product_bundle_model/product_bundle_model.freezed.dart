// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_bundle_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ProductBundleModel _$ProductBundleModelFromJson(Map<String, dynamic> json) {
  return _ProductBundleModel.fromJson(json);
}

/// @nodoc
mixin _$ProductBundleModel {
  @JsonKey(name: 'ProductId', includeIfNull: false)
  String? get productId => throw _privateConstructorUsedError;
  @JsonKey(name: 'Name', includeIfNull: false)
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'SeName', includeIfNull: false)
  String? get seName => throw _privateConstructorUsedError;
  @JsonKey(name: 'ShortDescription', includeIfNull: false)
  String? get shortDescription => throw _privateConstructorUsedError;
  @JsonKey(name: 'Sku', includeIfNull: false)
  String? get sku => throw _privateConstructorUsedError;
  @JsonKey(name: 'Mpn', includeIfNull: false)
  String? get mpn => throw _privateConstructorUsedError;
  @JsonKey(name: 'Gtin', includeIfNull: false)
  String? get gtin => throw _privateConstructorUsedError;
  @JsonKey(name: 'Quantity', includeIfNull: false)
  int? get quantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'Price', includeIfNull: false)
  String? get price => throw _privateConstructorUsedError;
  @JsonKey(name: 'PriceValue', includeIfNull: false)
  double? get priceValue => throw _privateConstructorUsedError;
  @JsonKey(name: 'DefaultPictureModel', includeIfNull: false)
  PictureModel? get defaultPictureModel => throw _privateConstructorUsedError;
  @JsonKey(name: 'ProductAttributes', includeIfNull: false)
  List<ProductAttributeModel>? get productAttributes =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this ProductBundleModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProductBundleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductBundleModelCopyWith<ProductBundleModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductBundleModelCopyWith<$Res> {
  factory $ProductBundleModelCopyWith(
    ProductBundleModel value,
    $Res Function(ProductBundleModel) then,
  ) = _$ProductBundleModelCopyWithImpl<$Res, ProductBundleModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'ProductId', includeIfNull: false) String? productId,
    @JsonKey(name: 'Name', includeIfNull: false) String? name,
    @JsonKey(name: 'SeName', includeIfNull: false) String? seName,
    @JsonKey(name: 'ShortDescription', includeIfNull: false)
    String? shortDescription,
    @JsonKey(name: 'Sku', includeIfNull: false) String? sku,
    @JsonKey(name: 'Mpn', includeIfNull: false) String? mpn,
    @JsonKey(name: 'Gtin', includeIfNull: false) String? gtin,
    @JsonKey(name: 'Quantity', includeIfNull: false) int? quantity,
    @JsonKey(name: 'Price', includeIfNull: false) String? price,
    @JsonKey(name: 'PriceValue', includeIfNull: false) double? priceValue,
    @JsonKey(name: 'DefaultPictureModel', includeIfNull: false)
    PictureModel? defaultPictureModel,
    @JsonKey(name: 'ProductAttributes', includeIfNull: false)
    List<ProductAttributeModel>? productAttributes,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  $PictureModelCopyWith<$Res>? get defaultPictureModel;
}

/// @nodoc
class _$ProductBundleModelCopyWithImpl<$Res, $Val extends ProductBundleModel>
    implements $ProductBundleModelCopyWith<$Res> {
  _$ProductBundleModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductBundleModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = freezed,
    Object? name = freezed,
    Object? seName = freezed,
    Object? shortDescription = freezed,
    Object? sku = freezed,
    Object? mpn = freezed,
    Object? gtin = freezed,
    Object? quantity = freezed,
    Object? price = freezed,
    Object? priceValue = freezed,
    Object? defaultPictureModel = freezed,
    Object? productAttributes = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            productId:
                freezed == productId
                    ? _value.productId
                    : productId // ignore: cast_nullable_to_non_nullable
                        as String?,
            name:
                freezed == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String?,
            seName:
                freezed == seName
                    ? _value.seName
                    : seName // ignore: cast_nullable_to_non_nullable
                        as String?,
            shortDescription:
                freezed == shortDescription
                    ? _value.shortDescription
                    : shortDescription // ignore: cast_nullable_to_non_nullable
                        as String?,
            sku:
                freezed == sku
                    ? _value.sku
                    : sku // ignore: cast_nullable_to_non_nullable
                        as String?,
            mpn:
                freezed == mpn
                    ? _value.mpn
                    : mpn // ignore: cast_nullable_to_non_nullable
                        as String?,
            gtin:
                freezed == gtin
                    ? _value.gtin
                    : gtin // ignore: cast_nullable_to_non_nullable
                        as String?,
            quantity:
                freezed == quantity
                    ? _value.quantity
                    : quantity // ignore: cast_nullable_to_non_nullable
                        as int?,
            price:
                freezed == price
                    ? _value.price
                    : price // ignore: cast_nullable_to_non_nullable
                        as String?,
            priceValue:
                freezed == priceValue
                    ? _value.priceValue
                    : priceValue // ignore: cast_nullable_to_non_nullable
                        as double?,
            defaultPictureModel:
                freezed == defaultPictureModel
                    ? _value.defaultPictureModel
                    : defaultPictureModel // ignore: cast_nullable_to_non_nullable
                        as PictureModel?,
            productAttributes:
                freezed == productAttributes
                    ? _value.productAttributes
                    : productAttributes // ignore: cast_nullable_to_non_nullable
                        as List<ProductAttributeModel>?,
            userFields:
                freezed == userFields
                    ? _value.userFields
                    : userFields // ignore: cast_nullable_to_non_nullable
                        as List<UserField>?,
          )
          as $Val,
    );
  }

  /// Create a copy of ProductBundleModel
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
}

/// @nodoc
abstract class _$$ProductBundleModelImplCopyWith<$Res>
    implements $ProductBundleModelCopyWith<$Res> {
  factory _$$ProductBundleModelImplCopyWith(
    _$ProductBundleModelImpl value,
    $Res Function(_$ProductBundleModelImpl) then,
  ) = __$$ProductBundleModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'ProductId', includeIfNull: false) String? productId,
    @JsonKey(name: 'Name', includeIfNull: false) String? name,
    @JsonKey(name: 'SeName', includeIfNull: false) String? seName,
    @JsonKey(name: 'ShortDescription', includeIfNull: false)
    String? shortDescription,
    @JsonKey(name: 'Sku', includeIfNull: false) String? sku,
    @JsonKey(name: 'Mpn', includeIfNull: false) String? mpn,
    @JsonKey(name: 'Gtin', includeIfNull: false) String? gtin,
    @JsonKey(name: 'Quantity', includeIfNull: false) int? quantity,
    @JsonKey(name: 'Price', includeIfNull: false) String? price,
    @JsonKey(name: 'PriceValue', includeIfNull: false) double? priceValue,
    @JsonKey(name: 'DefaultPictureModel', includeIfNull: false)
    PictureModel? defaultPictureModel,
    @JsonKey(name: 'ProductAttributes', includeIfNull: false)
    List<ProductAttributeModel>? productAttributes,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  @override
  $PictureModelCopyWith<$Res>? get defaultPictureModel;
}

/// @nodoc
class __$$ProductBundleModelImplCopyWithImpl<$Res>
    extends _$ProductBundleModelCopyWithImpl<$Res, _$ProductBundleModelImpl>
    implements _$$ProductBundleModelImplCopyWith<$Res> {
  __$$ProductBundleModelImplCopyWithImpl(
    _$ProductBundleModelImpl _value,
    $Res Function(_$ProductBundleModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductBundleModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = freezed,
    Object? name = freezed,
    Object? seName = freezed,
    Object? shortDescription = freezed,
    Object? sku = freezed,
    Object? mpn = freezed,
    Object? gtin = freezed,
    Object? quantity = freezed,
    Object? price = freezed,
    Object? priceValue = freezed,
    Object? defaultPictureModel = freezed,
    Object? productAttributes = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$ProductBundleModelImpl(
        productId:
            freezed == productId
                ? _value.productId
                : productId // ignore: cast_nullable_to_non_nullable
                    as String?,
        name:
            freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String?,
        seName:
            freezed == seName
                ? _value.seName
                : seName // ignore: cast_nullable_to_non_nullable
                    as String?,
        shortDescription:
            freezed == shortDescription
                ? _value.shortDescription
                : shortDescription // ignore: cast_nullable_to_non_nullable
                    as String?,
        sku:
            freezed == sku
                ? _value.sku
                : sku // ignore: cast_nullable_to_non_nullable
                    as String?,
        mpn:
            freezed == mpn
                ? _value.mpn
                : mpn // ignore: cast_nullable_to_non_nullable
                    as String?,
        gtin:
            freezed == gtin
                ? _value.gtin
                : gtin // ignore: cast_nullable_to_non_nullable
                    as String?,
        quantity:
            freezed == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                    as int?,
        price:
            freezed == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                    as String?,
        priceValue:
            freezed == priceValue
                ? _value.priceValue
                : priceValue // ignore: cast_nullable_to_non_nullable
                    as double?,
        defaultPictureModel:
            freezed == defaultPictureModel
                ? _value.defaultPictureModel
                : defaultPictureModel // ignore: cast_nullable_to_non_nullable
                    as PictureModel?,
        productAttributes:
            freezed == productAttributes
                ? _value._productAttributes
                : productAttributes // ignore: cast_nullable_to_non_nullable
                    as List<ProductAttributeModel>?,
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
class _$ProductBundleModelImpl implements _ProductBundleModel {
  _$ProductBundleModelImpl({
    @JsonKey(name: 'ProductId', includeIfNull: false) this.productId,
    @JsonKey(name: 'Name', includeIfNull: false) this.name,
    @JsonKey(name: 'SeName', includeIfNull: false) this.seName,
    @JsonKey(name: 'ShortDescription', includeIfNull: false)
    this.shortDescription,
    @JsonKey(name: 'Sku', includeIfNull: false) this.sku,
    @JsonKey(name: 'Mpn', includeIfNull: false) this.mpn,
    @JsonKey(name: 'Gtin', includeIfNull: false) this.gtin,
    @JsonKey(name: 'Quantity', includeIfNull: false) this.quantity,
    @JsonKey(name: 'Price', includeIfNull: false) this.price,
    @JsonKey(name: 'PriceValue', includeIfNull: false) this.priceValue,
    @JsonKey(name: 'DefaultPictureModel', includeIfNull: false)
    this.defaultPictureModel,
    @JsonKey(name: 'ProductAttributes', includeIfNull: false)
    final List<ProductAttributeModel>? productAttributes = const [],
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _productAttributes = productAttributes,
       _userFields = userFields;

  factory _$ProductBundleModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductBundleModelImplFromJson(json);

  @override
  @JsonKey(name: 'ProductId', includeIfNull: false)
  final String? productId;
  @override
  @JsonKey(name: 'Name', includeIfNull: false)
  final String? name;
  @override
  @JsonKey(name: 'SeName', includeIfNull: false)
  final String? seName;
  @override
  @JsonKey(name: 'ShortDescription', includeIfNull: false)
  final String? shortDescription;
  @override
  @JsonKey(name: 'Sku', includeIfNull: false)
  final String? sku;
  @override
  @JsonKey(name: 'Mpn', includeIfNull: false)
  final String? mpn;
  @override
  @JsonKey(name: 'Gtin', includeIfNull: false)
  final String? gtin;
  @override
  @JsonKey(name: 'Quantity', includeIfNull: false)
  final int? quantity;
  @override
  @JsonKey(name: 'Price', includeIfNull: false)
  final String? price;
  @override
  @JsonKey(name: 'PriceValue', includeIfNull: false)
  final double? priceValue;
  @override
  @JsonKey(name: 'DefaultPictureModel', includeIfNull: false)
  final PictureModel? defaultPictureModel;
  final List<ProductAttributeModel>? _productAttributes;
  @override
  @JsonKey(name: 'ProductAttributes', includeIfNull: false)
  List<ProductAttributeModel>? get productAttributes {
    final value = _productAttributes;
    if (value == null) return null;
    if (_productAttributes is EqualUnmodifiableListView)
      return _productAttributes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

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
    return 'ProductBundleModel(productId: $productId, name: $name, seName: $seName, shortDescription: $shortDescription, sku: $sku, mpn: $mpn, gtin: $gtin, quantity: $quantity, price: $price, priceValue: $priceValue, defaultPictureModel: $defaultPictureModel, productAttributes: $productAttributes, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductBundleModelImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.seName, seName) || other.seName == seName) &&
            (identical(other.shortDescription, shortDescription) ||
                other.shortDescription == shortDescription) &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.mpn, mpn) || other.mpn == mpn) &&
            (identical(other.gtin, gtin) || other.gtin == gtin) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.priceValue, priceValue) ||
                other.priceValue == priceValue) &&
            (identical(other.defaultPictureModel, defaultPictureModel) ||
                other.defaultPictureModel == defaultPictureModel) &&
            const DeepCollectionEquality().equals(
              other._productAttributes,
              _productAttributes,
            ) &&
            const DeepCollectionEquality().equals(
              other._userFields,
              _userFields,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    productId,
    name,
    seName,
    shortDescription,
    sku,
    mpn,
    gtin,
    quantity,
    price,
    priceValue,
    defaultPictureModel,
    const DeepCollectionEquality().hash(_productAttributes),
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of ProductBundleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductBundleModelImplCopyWith<_$ProductBundleModelImpl> get copyWith =>
      __$$ProductBundleModelImplCopyWithImpl<_$ProductBundleModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductBundleModelImplToJson(this);
  }
}

abstract class _ProductBundleModel implements ProductBundleModel {
  factory _ProductBundleModel({
    @JsonKey(name: 'ProductId', includeIfNull: false) final String? productId,
    @JsonKey(name: 'Name', includeIfNull: false) final String? name,
    @JsonKey(name: 'SeName', includeIfNull: false) final String? seName,
    @JsonKey(name: 'ShortDescription', includeIfNull: false)
    final String? shortDescription,
    @JsonKey(name: 'Sku', includeIfNull: false) final String? sku,
    @JsonKey(name: 'Mpn', includeIfNull: false) final String? mpn,
    @JsonKey(name: 'Gtin', includeIfNull: false) final String? gtin,
    @JsonKey(name: 'Quantity', includeIfNull: false) final int? quantity,
    @JsonKey(name: 'Price', includeIfNull: false) final String? price,
    @JsonKey(name: 'PriceValue', includeIfNull: false) final double? priceValue,
    @JsonKey(name: 'DefaultPictureModel', includeIfNull: false)
    final PictureModel? defaultPictureModel,
    @JsonKey(name: 'ProductAttributes', includeIfNull: false)
    final List<ProductAttributeModel>? productAttributes,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$ProductBundleModelImpl;

  factory _ProductBundleModel.fromJson(Map<String, dynamic> json) =
      _$ProductBundleModelImpl.fromJson;

  @override
  @JsonKey(name: 'ProductId', includeIfNull: false)
  String? get productId;
  @override
  @JsonKey(name: 'Name', includeIfNull: false)
  String? get name;
  @override
  @JsonKey(name: 'SeName', includeIfNull: false)
  String? get seName;
  @override
  @JsonKey(name: 'ShortDescription', includeIfNull: false)
  String? get shortDescription;
  @override
  @JsonKey(name: 'Sku', includeIfNull: false)
  String? get sku;
  @override
  @JsonKey(name: 'Mpn', includeIfNull: false)
  String? get mpn;
  @override
  @JsonKey(name: 'Gtin', includeIfNull: false)
  String? get gtin;
  @override
  @JsonKey(name: 'Quantity', includeIfNull: false)
  int? get quantity;
  @override
  @JsonKey(name: 'Price', includeIfNull: false)
  String? get price;
  @override
  @JsonKey(name: 'PriceValue', includeIfNull: false)
  double? get priceValue;
  @override
  @JsonKey(name: 'DefaultPictureModel', includeIfNull: false)
  PictureModel? get defaultPictureModel;
  @override
  @JsonKey(name: 'ProductAttributes', includeIfNull: false)
  List<ProductAttributeModel>? get productAttributes;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of ProductBundleModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductBundleModelImplCopyWith<_$ProductBundleModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
