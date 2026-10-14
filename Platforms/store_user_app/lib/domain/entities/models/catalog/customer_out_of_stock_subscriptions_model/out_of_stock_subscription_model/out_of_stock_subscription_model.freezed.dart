// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'out_of_stock_subscription_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

OutOfStockSubscriptionModel _$OutOfStockSubscriptionModelFromJson(
  Map<String, dynamic> json,
) {
  return _OutOfStockSubscriptionModel.fromJson(json);
}

/// @nodoc
mixin _$OutOfStockSubscriptionModel {
  @JsonKey(name: 'ProductId', includeIfNull: false)
  String? get productId => throw _privateConstructorUsedError;
  @JsonKey(name: 'ProductName', includeIfNull: false)
  String? get productName => throw _privateConstructorUsedError;
  @JsonKey(name: 'AttributeDescription', includeIfNull: false)
  String? get attributeDescription => throw _privateConstructorUsedError;
  @JsonKey(name: 'SeName', includeIfNull: false)
  String? get seName => throw _privateConstructorUsedError;
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this OutOfStockSubscriptionModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OutOfStockSubscriptionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OutOfStockSubscriptionModelCopyWith<OutOfStockSubscriptionModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OutOfStockSubscriptionModelCopyWith<$Res> {
  factory $OutOfStockSubscriptionModelCopyWith(
    OutOfStockSubscriptionModel value,
    $Res Function(OutOfStockSubscriptionModel) then,
  ) =
      _$OutOfStockSubscriptionModelCopyWithImpl<
        $Res,
        OutOfStockSubscriptionModel
      >;
  @useResult
  $Res call({
    @JsonKey(name: 'ProductId', includeIfNull: false) String? productId,
    @JsonKey(name: 'ProductName', includeIfNull: false) String? productName,
    @JsonKey(name: 'AttributeDescription', includeIfNull: false)
    String? attributeDescription,
    @JsonKey(name: 'SeName', includeIfNull: false) String? seName,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$OutOfStockSubscriptionModelCopyWithImpl<
  $Res,
  $Val extends OutOfStockSubscriptionModel
>
    implements $OutOfStockSubscriptionModelCopyWith<$Res> {
  _$OutOfStockSubscriptionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OutOfStockSubscriptionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = freezed,
    Object? productName = freezed,
    Object? attributeDescription = freezed,
    Object? seName = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
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
            attributeDescription:
                freezed == attributeDescription
                    ? _value.attributeDescription
                    : attributeDescription // ignore: cast_nullable_to_non_nullable
                        as String?,
            seName:
                freezed == seName
                    ? _value.seName
                    : seName // ignore: cast_nullable_to_non_nullable
                        as String?,
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
}

/// @nodoc
abstract class _$$OutOfStockSubscriptionModelImplCopyWith<$Res>
    implements $OutOfStockSubscriptionModelCopyWith<$Res> {
  factory _$$OutOfStockSubscriptionModelImplCopyWith(
    _$OutOfStockSubscriptionModelImpl value,
    $Res Function(_$OutOfStockSubscriptionModelImpl) then,
  ) = __$$OutOfStockSubscriptionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'ProductId', includeIfNull: false) String? productId,
    @JsonKey(name: 'ProductName', includeIfNull: false) String? productName,
    @JsonKey(name: 'AttributeDescription', includeIfNull: false)
    String? attributeDescription,
    @JsonKey(name: 'SeName', includeIfNull: false) String? seName,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$OutOfStockSubscriptionModelImplCopyWithImpl<$Res>
    extends
        _$OutOfStockSubscriptionModelCopyWithImpl<
          $Res,
          _$OutOfStockSubscriptionModelImpl
        >
    implements _$$OutOfStockSubscriptionModelImplCopyWith<$Res> {
  __$$OutOfStockSubscriptionModelImplCopyWithImpl(
    _$OutOfStockSubscriptionModelImpl _value,
    $Res Function(_$OutOfStockSubscriptionModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OutOfStockSubscriptionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = freezed,
    Object? productName = freezed,
    Object? attributeDescription = freezed,
    Object? seName = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$OutOfStockSubscriptionModelImpl(
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
        attributeDescription:
            freezed == attributeDescription
                ? _value.attributeDescription
                : attributeDescription // ignore: cast_nullable_to_non_nullable
                    as String?,
        seName:
            freezed == seName
                ? _value.seName
                : seName // ignore: cast_nullable_to_non_nullable
                    as String?,
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
class _$OutOfStockSubscriptionModelImpl
    implements _OutOfStockSubscriptionModel {
  _$OutOfStockSubscriptionModelImpl({
    @JsonKey(name: 'ProductId', includeIfNull: false) this.productId,
    @JsonKey(name: 'ProductName', includeIfNull: false) this.productName,
    @JsonKey(name: 'AttributeDescription', includeIfNull: false)
    this.attributeDescription,
    @JsonKey(name: 'SeName', includeIfNull: false) this.seName,
    @JsonKey(name: 'Id', includeIfNull: false) this.id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _userFields = userFields;

  factory _$OutOfStockSubscriptionModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$OutOfStockSubscriptionModelImplFromJson(json);

  @override
  @JsonKey(name: 'ProductId', includeIfNull: false)
  final String? productId;
  @override
  @JsonKey(name: 'ProductName', includeIfNull: false)
  final String? productName;
  @override
  @JsonKey(name: 'AttributeDescription', includeIfNull: false)
  final String? attributeDescription;
  @override
  @JsonKey(name: 'SeName', includeIfNull: false)
  final String? seName;
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
    return 'OutOfStockSubscriptionModel(productId: $productId, productName: $productName, attributeDescription: $attributeDescription, seName: $seName, id: $id, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OutOfStockSubscriptionModelImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.attributeDescription, attributeDescription) ||
                other.attributeDescription == attributeDescription) &&
            (identical(other.seName, seName) || other.seName == seName) &&
            (identical(other.id, id) || other.id == id) &&
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
    productName,
    attributeDescription,
    seName,
    id,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of OutOfStockSubscriptionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OutOfStockSubscriptionModelImplCopyWith<_$OutOfStockSubscriptionModelImpl>
  get copyWith => __$$OutOfStockSubscriptionModelImplCopyWithImpl<
    _$OutOfStockSubscriptionModelImpl
  >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OutOfStockSubscriptionModelImplToJson(this);
  }
}

abstract class _OutOfStockSubscriptionModel
    implements OutOfStockSubscriptionModel {
  factory _OutOfStockSubscriptionModel({
    @JsonKey(name: 'ProductId', includeIfNull: false) final String? productId,
    @JsonKey(name: 'ProductName', includeIfNull: false)
    final String? productName,
    @JsonKey(name: 'AttributeDescription', includeIfNull: false)
    final String? attributeDescription,
    @JsonKey(name: 'SeName', includeIfNull: false) final String? seName,
    @JsonKey(name: 'Id', includeIfNull: false) final String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$OutOfStockSubscriptionModelImpl;

  factory _OutOfStockSubscriptionModel.fromJson(Map<String, dynamic> json) =
      _$OutOfStockSubscriptionModelImpl.fromJson;

  @override
  @JsonKey(name: 'ProductId', includeIfNull: false)
  String? get productId;
  @override
  @JsonKey(name: 'ProductName', includeIfNull: false)
  String? get productName;
  @override
  @JsonKey(name: 'AttributeDescription', includeIfNull: false)
  String? get attributeDescription;
  @override
  @JsonKey(name: 'SeName', includeIfNull: false)
  String? get seName;
  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of OutOfStockSubscriptionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OutOfStockSubscriptionModelImplCopyWith<_$OutOfStockSubscriptionModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
