// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_breadcrumb_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ProductBreadcrumbModel _$ProductBreadcrumbModelFromJson(
  Map<String, dynamic> json,
) {
  return _ProductBreadcrumbModel.fromJson(json);
}

/// @nodoc
mixin _$ProductBreadcrumbModel {
  @JsonKey(name: 'Id', includeIfNull: false)
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'Enabled', includeIfNull: false)
  bool? get enabled => throw _privateConstructorUsedError;
  @JsonKey(name: 'ProductId', includeIfNull: false)
  String? get productId => throw _privateConstructorUsedError;
  @JsonKey(name: 'ProductName', includeIfNull: false)
  String? get productName => throw _privateConstructorUsedError;
  @JsonKey(name: 'ProductSeName', includeIfNull: false)
  String? get productSeName => throw _privateConstructorUsedError;
  @JsonKey(name: 'CategoryBreadcrumb', includeIfNull: false)
  List<CategorySimpleModel>? get categoryBreadcrumb =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this ProductBreadcrumbModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProductBreadcrumbModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductBreadcrumbModelCopyWith<ProductBreadcrumbModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductBreadcrumbModelCopyWith<$Res> {
  factory $ProductBreadcrumbModelCopyWith(
    ProductBreadcrumbModel value,
    $Res Function(ProductBreadcrumbModel) then,
  ) = _$ProductBreadcrumbModelCopyWithImpl<$Res, ProductBreadcrumbModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'Id', includeIfNull: false) int? id,
    @JsonKey(name: 'Enabled', includeIfNull: false) bool? enabled,
    @JsonKey(name: 'ProductId', includeIfNull: false) String? productId,
    @JsonKey(name: 'ProductName', includeIfNull: false) String? productName,
    @JsonKey(name: 'ProductSeName', includeIfNull: false) String? productSeName,
    @JsonKey(name: 'CategoryBreadcrumb', includeIfNull: false)
    List<CategorySimpleModel>? categoryBreadcrumb,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$ProductBreadcrumbModelCopyWithImpl<
  $Res,
  $Val extends ProductBreadcrumbModel
>
    implements $ProductBreadcrumbModelCopyWith<$Res> {
  _$ProductBreadcrumbModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductBreadcrumbModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? enabled = freezed,
    Object? productId = freezed,
    Object? productName = freezed,
    Object? productSeName = freezed,
    Object? categoryBreadcrumb = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            id:
                freezed == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as int?,
            enabled:
                freezed == enabled
                    ? _value.enabled
                    : enabled // ignore: cast_nullable_to_non_nullable
                        as bool?,
            productId:
                freezed == productId
                    ? _value.productId
                    : productId // ignore: cast_nullable_to_non_nullable
                        as String?,
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
            categoryBreadcrumb:
                freezed == categoryBreadcrumb
                    ? _value.categoryBreadcrumb
                    : categoryBreadcrumb // ignore: cast_nullable_to_non_nullable
                        as List<CategorySimpleModel>?,
            userFields:
                freezed == userFields
                    ? _value.userFields
                    : userFields // ignore: cast_nullable_to_non_nullable
                        as List<UserField>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProductBreadcrumbModelImplCopyWith<$Res>
    implements $ProductBreadcrumbModelCopyWith<$Res> {
  factory _$$ProductBreadcrumbModelImplCopyWith(
    _$ProductBreadcrumbModelImpl value,
    $Res Function(_$ProductBreadcrumbModelImpl) then,
  ) = __$$ProductBreadcrumbModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'Id', includeIfNull: false) int? id,
    @JsonKey(name: 'Enabled', includeIfNull: false) bool? enabled,
    @JsonKey(name: 'ProductId', includeIfNull: false) String? productId,
    @JsonKey(name: 'ProductName', includeIfNull: false) String? productName,
    @JsonKey(name: 'ProductSeName', includeIfNull: false) String? productSeName,
    @JsonKey(name: 'CategoryBreadcrumb', includeIfNull: false)
    List<CategorySimpleModel>? categoryBreadcrumb,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$ProductBreadcrumbModelImplCopyWithImpl<$Res>
    extends
        _$ProductBreadcrumbModelCopyWithImpl<$Res, _$ProductBreadcrumbModelImpl>
    implements _$$ProductBreadcrumbModelImplCopyWith<$Res> {
  __$$ProductBreadcrumbModelImplCopyWithImpl(
    _$ProductBreadcrumbModelImpl _value,
    $Res Function(_$ProductBreadcrumbModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductBreadcrumbModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? enabled = freezed,
    Object? productId = freezed,
    Object? productName = freezed,
    Object? productSeName = freezed,
    Object? categoryBreadcrumb = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$ProductBreadcrumbModelImpl(
        id:
            freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as int?,
        enabled:
            freezed == enabled
                ? _value.enabled
                : enabled // ignore: cast_nullable_to_non_nullable
                    as bool?,
        productId:
            freezed == productId
                ? _value.productId
                : productId // ignore: cast_nullable_to_non_nullable
                    as String?,
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
        categoryBreadcrumb:
            freezed == categoryBreadcrumb
                ? _value._categoryBreadcrumb
                : categoryBreadcrumb // ignore: cast_nullable_to_non_nullable
                    as List<CategorySimpleModel>?,
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
class _$ProductBreadcrumbModelImpl implements _ProductBreadcrumbModel {
  _$ProductBreadcrumbModelImpl({
    @JsonKey(name: 'Id', includeIfNull: false) this.id,
    @JsonKey(name: 'Enabled', includeIfNull: false) this.enabled = false,
    @JsonKey(name: 'ProductId', includeIfNull: false) this.productId,
    @JsonKey(name: 'ProductName', includeIfNull: false) this.productName,
    @JsonKey(name: 'ProductSeName', includeIfNull: false) this.productSeName,
    @JsonKey(name: 'CategoryBreadcrumb', includeIfNull: false)
    final List<CategorySimpleModel>? categoryBreadcrumb = const [],
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _categoryBreadcrumb = categoryBreadcrumb,
       _userFields = userFields;

  factory _$ProductBreadcrumbModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductBreadcrumbModelImplFromJson(json);

  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  final int? id;
  @override
  @JsonKey(name: 'Enabled', includeIfNull: false)
  final bool? enabled;
  @override
  @JsonKey(name: 'ProductId', includeIfNull: false)
  final String? productId;
  @override
  @JsonKey(name: 'ProductName', includeIfNull: false)
  final String? productName;
  @override
  @JsonKey(name: 'ProductSeName', includeIfNull: false)
  final String? productSeName;
  final List<CategorySimpleModel>? _categoryBreadcrumb;
  @override
  @JsonKey(name: 'CategoryBreadcrumb', includeIfNull: false)
  List<CategorySimpleModel>? get categoryBreadcrumb {
    final value = _categoryBreadcrumb;
    if (value == null) return null;
    if (_categoryBreadcrumb is EqualUnmodifiableListView)
      return _categoryBreadcrumb;
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
    return 'ProductBreadcrumbModel(id: $id, enabled: $enabled, productId: $productId, productName: $productName, productSeName: $productSeName, categoryBreadcrumb: $categoryBreadcrumb, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductBreadcrumbModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.productSeName, productSeName) ||
                other.productSeName == productSeName) &&
            const DeepCollectionEquality().equals(
              other._categoryBreadcrumb,
              _categoryBreadcrumb,
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
    id,
    enabled,
    productId,
    productName,
    productSeName,
    const DeepCollectionEquality().hash(_categoryBreadcrumb),
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of ProductBreadcrumbModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductBreadcrumbModelImplCopyWith<_$ProductBreadcrumbModelImpl>
  get copyWith =>
      __$$ProductBreadcrumbModelImplCopyWithImpl<_$ProductBreadcrumbModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductBreadcrumbModelImplToJson(this);
  }
}

abstract class _ProductBreadcrumbModel implements ProductBreadcrumbModel {
  factory _ProductBreadcrumbModel({
    @JsonKey(name: 'Id', includeIfNull: false) final int? id,
    @JsonKey(name: 'Enabled', includeIfNull: false) final bool? enabled,
    @JsonKey(name: 'ProductId', includeIfNull: false) final String? productId,
    @JsonKey(name: 'ProductName', includeIfNull: false)
    final String? productName,
    @JsonKey(name: 'ProductSeName', includeIfNull: false)
    final String? productSeName,
    @JsonKey(name: 'CategoryBreadcrumb', includeIfNull: false)
    final List<CategorySimpleModel>? categoryBreadcrumb,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$ProductBreadcrumbModelImpl;

  factory _ProductBreadcrumbModel.fromJson(Map<String, dynamic> json) =
      _$ProductBreadcrumbModelImpl.fromJson;

  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  int? get id;
  @override
  @JsonKey(name: 'Enabled', includeIfNull: false)
  bool? get enabled;
  @override
  @JsonKey(name: 'ProductId', includeIfNull: false)
  String? get productId;
  @override
  @JsonKey(name: 'ProductName', includeIfNull: false)
  String? get productName;
  @override
  @JsonKey(name: 'ProductSeName', includeIfNull: false)
  String? get productSeName;
  @override
  @JsonKey(name: 'CategoryBreadcrumb', includeIfNull: false)
  List<CategorySimpleModel>? get categoryBreadcrumb;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of ProductBreadcrumbModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductBreadcrumbModelImplCopyWith<_$ProductBreadcrumbModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
