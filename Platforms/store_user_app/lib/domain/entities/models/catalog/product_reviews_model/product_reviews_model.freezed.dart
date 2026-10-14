// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_reviews_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ProductReviewsModel _$ProductReviewsModelFromJson(Map<String, dynamic> json) {
  return _ProductReviewsModel.fromJson(json);
}

/// @nodoc
mixin _$ProductReviewsModel {
  @JsonKey(name: 'ProductId', includeIfNull: false)
  String? get productId => throw _privateConstructorUsedError;
  @JsonKey(name: 'CaptchaValid', includeIfNull: false)
  bool? get captchaValid => throw _privateConstructorUsedError;
  @JsonKey(name: 'Captcha', includeIfNull: false)
  ICaptchaValidModel? get captcha => throw _privateConstructorUsedError;
  @JsonKey(name: 'ProductName', includeIfNull: false)
  String? get productName => throw _privateConstructorUsedError;
  @JsonKey(name: 'ProductSeName', includeIfNull: false)
  String? get productSeName => throw _privateConstructorUsedError;
  @JsonKey(name: 'Items', includeIfNull: false)
  List<ProductReviewModel>? get items => throw _privateConstructorUsedError;
  @JsonKey(name: 'AddProductReview', includeIfNull: false)
  AddProductReviewModel? get addProductReview =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'ProductReviewOverviewModel', includeIfNull: false)
  ProductReviewOverviewModel? get productReviewOverviewModel =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this ProductReviewsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProductReviewsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductReviewsModelCopyWith<ProductReviewsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductReviewsModelCopyWith<$Res> {
  factory $ProductReviewsModelCopyWith(
    ProductReviewsModel value,
    $Res Function(ProductReviewsModel) then,
  ) = _$ProductReviewsModelCopyWithImpl<$Res, ProductReviewsModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'ProductId', includeIfNull: false) String? productId,
    @JsonKey(name: 'CaptchaValid', includeIfNull: false) bool? captchaValid,
    @JsonKey(name: 'Captcha', includeIfNull: false) ICaptchaValidModel? captcha,
    @JsonKey(name: 'ProductName', includeIfNull: false) String? productName,
    @JsonKey(name: 'ProductSeName', includeIfNull: false) String? productSeName,
    @JsonKey(name: 'Items', includeIfNull: false)
    List<ProductReviewModel>? items,
    @JsonKey(name: 'AddProductReview', includeIfNull: false)
    AddProductReviewModel? addProductReview,
    @JsonKey(name: 'ProductReviewOverviewModel', includeIfNull: false)
    ProductReviewOverviewModel? productReviewOverviewModel,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  $ICaptchaValidModelCopyWith<$Res>? get captcha;
  $AddProductReviewModelCopyWith<$Res>? get addProductReview;
  $ProductReviewOverviewModelCopyWith<$Res>? get productReviewOverviewModel;
}

/// @nodoc
class _$ProductReviewsModelCopyWithImpl<$Res, $Val extends ProductReviewsModel>
    implements $ProductReviewsModelCopyWith<$Res> {
  _$ProductReviewsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductReviewsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = freezed,
    Object? captchaValid = freezed,
    Object? captcha = freezed,
    Object? productName = freezed,
    Object? productSeName = freezed,
    Object? items = freezed,
    Object? addProductReview = freezed,
    Object? productReviewOverviewModel = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            productId:
                freezed == productId
                    ? _value.productId
                    : productId // ignore: cast_nullable_to_non_nullable
                        as String?,
            captchaValid:
                freezed == captchaValid
                    ? _value.captchaValid
                    : captchaValid // ignore: cast_nullable_to_non_nullable
                        as bool?,
            captcha:
                freezed == captcha
                    ? _value.captcha
                    : captcha // ignore: cast_nullable_to_non_nullable
                        as ICaptchaValidModel?,
            productName:
                freezed == productName
                    ? _value.productName
                    : productName // ignore: cast_nullable_to_non_nullable
                        as String?,
            productSeName:
                freezed == productSeName
                    ? _value.productSeName
                    : productSeName // ignore: cast_nullable_to_non_nullable
                        as String?,
            items:
                freezed == items
                    ? _value.items
                    : items // ignore: cast_nullable_to_non_nullable
                        as List<ProductReviewModel>?,
            addProductReview:
                freezed == addProductReview
                    ? _value.addProductReview
                    : addProductReview // ignore: cast_nullable_to_non_nullable
                        as AddProductReviewModel?,
            productReviewOverviewModel:
                freezed == productReviewOverviewModel
                    ? _value.productReviewOverviewModel
                    : productReviewOverviewModel // ignore: cast_nullable_to_non_nullable
                        as ProductReviewOverviewModel?,
            userFields:
                freezed == userFields
                    ? _value.userFields
                    : userFields // ignore: cast_nullable_to_non_nullable
                        as List<UserField>?,
          )
          as $Val,
    );
  }

  /// Create a copy of ProductReviewsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ICaptchaValidModelCopyWith<$Res>? get captcha {
    if (_value.captcha == null) {
      return null;
    }

    return $ICaptchaValidModelCopyWith<$Res>(_value.captcha!, (value) {
      return _then(_value.copyWith(captcha: value) as $Val);
    });
  }

  /// Create a copy of ProductReviewsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AddProductReviewModelCopyWith<$Res>? get addProductReview {
    if (_value.addProductReview == null) {
      return null;
    }

    return $AddProductReviewModelCopyWith<$Res>(_value.addProductReview!, (
      value,
    ) {
      return _then(_value.copyWith(addProductReview: value) as $Val);
    });
  }

  /// Create a copy of ProductReviewsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProductReviewOverviewModelCopyWith<$Res>? get productReviewOverviewModel {
    if (_value.productReviewOverviewModel == null) {
      return null;
    }

    return $ProductReviewOverviewModelCopyWith<$Res>(
      _value.productReviewOverviewModel!,
      (value) {
        return _then(
          _value.copyWith(productReviewOverviewModel: value) as $Val,
        );
      },
    );
  }
}

/// @nodoc
abstract class _$$ProductReviewsModelImplCopyWith<$Res>
    implements $ProductReviewsModelCopyWith<$Res> {
  factory _$$ProductReviewsModelImplCopyWith(
    _$ProductReviewsModelImpl value,
    $Res Function(_$ProductReviewsModelImpl) then,
  ) = __$$ProductReviewsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'ProductId', includeIfNull: false) String? productId,
    @JsonKey(name: 'CaptchaValid', includeIfNull: false) bool? captchaValid,
    @JsonKey(name: 'Captcha', includeIfNull: false) ICaptchaValidModel? captcha,
    @JsonKey(name: 'ProductName', includeIfNull: false) String? productName,
    @JsonKey(name: 'ProductSeName', includeIfNull: false) String? productSeName,
    @JsonKey(name: 'Items', includeIfNull: false)
    List<ProductReviewModel>? items,
    @JsonKey(name: 'AddProductReview', includeIfNull: false)
    AddProductReviewModel? addProductReview,
    @JsonKey(name: 'ProductReviewOverviewModel', includeIfNull: false)
    ProductReviewOverviewModel? productReviewOverviewModel,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  @override
  $ICaptchaValidModelCopyWith<$Res>? get captcha;
  @override
  $AddProductReviewModelCopyWith<$Res>? get addProductReview;
  @override
  $ProductReviewOverviewModelCopyWith<$Res>? get productReviewOverviewModel;
}

/// @nodoc
class __$$ProductReviewsModelImplCopyWithImpl<$Res>
    extends _$ProductReviewsModelCopyWithImpl<$Res, _$ProductReviewsModelImpl>
    implements _$$ProductReviewsModelImplCopyWith<$Res> {
  __$$ProductReviewsModelImplCopyWithImpl(
    _$ProductReviewsModelImpl _value,
    $Res Function(_$ProductReviewsModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductReviewsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = freezed,
    Object? captchaValid = freezed,
    Object? captcha = freezed,
    Object? productName = freezed,
    Object? productSeName = freezed,
    Object? items = freezed,
    Object? addProductReview = freezed,
    Object? productReviewOverviewModel = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$ProductReviewsModelImpl(
        productId:
            freezed == productId
                ? _value.productId
                : productId // ignore: cast_nullable_to_non_nullable
                    as String?,
        captchaValid:
            freezed == captchaValid
                ? _value.captchaValid
                : captchaValid // ignore: cast_nullable_to_non_nullable
                    as bool?,
        captcha:
            freezed == captcha
                ? _value.captcha
                : captcha // ignore: cast_nullable_to_non_nullable
                    as ICaptchaValidModel?,
        productName:
            freezed == productName
                ? _value.productName
                : productName // ignore: cast_nullable_to_non_nullable
                    as String?,
        productSeName:
            freezed == productSeName
                ? _value.productSeName
                : productSeName // ignore: cast_nullable_to_non_nullable
                    as String?,
        items:
            freezed == items
                ? _value._items
                : items // ignore: cast_nullable_to_non_nullable
                    as List<ProductReviewModel>?,
        addProductReview:
            freezed == addProductReview
                ? _value.addProductReview
                : addProductReview // ignore: cast_nullable_to_non_nullable
                    as AddProductReviewModel?,
        productReviewOverviewModel:
            freezed == productReviewOverviewModel
                ? _value.productReviewOverviewModel
                : productReviewOverviewModel // ignore: cast_nullable_to_non_nullable
                    as ProductReviewOverviewModel?,
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
class _$ProductReviewsModelImpl implements _ProductReviewsModel {
  _$ProductReviewsModelImpl({
    @JsonKey(name: 'ProductId', includeIfNull: false) this.productId,
    @JsonKey(name: 'CaptchaValid', includeIfNull: false)
    this.captchaValid = false,
    @JsonKey(name: 'Captcha', includeIfNull: false) this.captcha,
    @JsonKey(name: 'ProductName', includeIfNull: false) this.productName,
    @JsonKey(name: 'ProductSeName', includeIfNull: false) this.productSeName,
    @JsonKey(name: 'Items', includeIfNull: false)
    final List<ProductReviewModel>? items = const [],
    @JsonKey(name: 'AddProductReview', includeIfNull: false)
    this.addProductReview,
    @JsonKey(name: 'ProductReviewOverviewModel', includeIfNull: false)
    this.productReviewOverviewModel,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _items = items,
       _userFields = userFields;

  factory _$ProductReviewsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductReviewsModelImplFromJson(json);

  @override
  @JsonKey(name: 'ProductId', includeIfNull: false)
  final String? productId;
  @override
  @JsonKey(name: 'CaptchaValid', includeIfNull: false)
  final bool? captchaValid;
  @override
  @JsonKey(name: 'Captcha', includeIfNull: false)
  final ICaptchaValidModel? captcha;
  @override
  @JsonKey(name: 'ProductName', includeIfNull: false)
  final String? productName;
  @override
  @JsonKey(name: 'ProductSeName', includeIfNull: false)
  final String? productSeName;
  final List<ProductReviewModel>? _items;
  @override
  @JsonKey(name: 'Items', includeIfNull: false)
  List<ProductReviewModel>? get items {
    final value = _items;
    if (value == null) return null;
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'AddProductReview', includeIfNull: false)
  final AddProductReviewModel? addProductReview;
  @override
  @JsonKey(name: 'ProductReviewOverviewModel', includeIfNull: false)
  final ProductReviewOverviewModel? productReviewOverviewModel;
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
    return 'ProductReviewsModel(productId: $productId, captchaValid: $captchaValid, captcha: $captcha, productName: $productName, productSeName: $productSeName, items: $items, addProductReview: $addProductReview, productReviewOverviewModel: $productReviewOverviewModel, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductReviewsModelImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.captchaValid, captchaValid) ||
                other.captchaValid == captchaValid) &&
            (identical(other.captcha, captcha) || other.captcha == captcha) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.productSeName, productSeName) ||
                other.productSeName == productSeName) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.addProductReview, addProductReview) ||
                other.addProductReview == addProductReview) &&
            (identical(
                  other.productReviewOverviewModel,
                  productReviewOverviewModel,
                ) ||
                other.productReviewOverviewModel ==
                    productReviewOverviewModel) &&
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
    captchaValid,
    captcha,
    productName,
    productSeName,
    const DeepCollectionEquality().hash(_items),
    addProductReview,
    productReviewOverviewModel,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of ProductReviewsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductReviewsModelImplCopyWith<_$ProductReviewsModelImpl> get copyWith =>
      __$$ProductReviewsModelImplCopyWithImpl<_$ProductReviewsModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductReviewsModelImplToJson(this);
  }
}

abstract class _ProductReviewsModel implements ProductReviewsModel {
  factory _ProductReviewsModel({
    @JsonKey(name: 'ProductId', includeIfNull: false) final String? productId,
    @JsonKey(name: 'CaptchaValid', includeIfNull: false)
    final bool? captchaValid,
    @JsonKey(name: 'Captcha', includeIfNull: false)
    final ICaptchaValidModel? captcha,
    @JsonKey(name: 'ProductName', includeIfNull: false)
    final String? productName,
    @JsonKey(name: 'ProductSeName', includeIfNull: false)
    final String? productSeName,
    @JsonKey(name: 'Items', includeIfNull: false)
    final List<ProductReviewModel>? items,
    @JsonKey(name: 'AddProductReview', includeIfNull: false)
    final AddProductReviewModel? addProductReview,
    @JsonKey(name: 'ProductReviewOverviewModel', includeIfNull: false)
    final ProductReviewOverviewModel? productReviewOverviewModel,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$ProductReviewsModelImpl;

  factory _ProductReviewsModel.fromJson(Map<String, dynamic> json) =
      _$ProductReviewsModelImpl.fromJson;

  @override
  @JsonKey(name: 'ProductId', includeIfNull: false)
  String? get productId;
  @override
  @JsonKey(name: 'CaptchaValid', includeIfNull: false)
  bool? get captchaValid;
  @override
  @JsonKey(name: 'Captcha', includeIfNull: false)
  ICaptchaValidModel? get captcha;
  @override
  @JsonKey(name: 'ProductName', includeIfNull: false)
  String? get productName;
  @override
  @JsonKey(name: 'ProductSeName', includeIfNull: false)
  String? get productSeName;
  @override
  @JsonKey(name: 'Items', includeIfNull: false)
  List<ProductReviewModel>? get items;
  @override
  @JsonKey(name: 'AddProductReview', includeIfNull: false)
  AddProductReviewModel? get addProductReview;
  @override
  @JsonKey(name: 'ProductReviewOverviewModel', includeIfNull: false)
  ProductReviewOverviewModel? get productReviewOverviewModel;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of ProductReviewsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductReviewsModelImplCopyWith<_$ProductReviewsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
