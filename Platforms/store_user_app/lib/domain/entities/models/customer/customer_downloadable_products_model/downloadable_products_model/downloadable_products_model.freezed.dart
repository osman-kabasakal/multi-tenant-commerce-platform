// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'downloadable_products_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DownloadableProductsModel _$DownloadableProductsModelFromJson(
  Map<String, dynamic> json,
) {
  return _DownloadableProductsModel.fromJson(json);
}

/// @nodoc
mixin _$DownloadableProductsModel {
  @JsonKey(name: 'OrderItemGuid', includeIfNull: false)
  String? get orderItemGuid => throw _privateConstructorUsedError;
  @JsonKey(name: 'OrderId', includeIfNull: false)
  String? get orderId => throw _privateConstructorUsedError;
  @JsonKey(name: 'OrderNumber', includeIfNull: false)
  int? get orderNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'ProductId', includeIfNull: false)
  String? get productId => throw _privateConstructorUsedError;
  @JsonKey(name: 'ProductName', includeIfNull: false)
  String? get productName => throw _privateConstructorUsedError;
  @JsonKey(name: 'ProductSeName', includeIfNull: false)
  String? get productSeName => throw _privateConstructorUsedError;
  @JsonKey(name: 'ProductAttributes', includeIfNull: false)
  String? get productAttributes => throw _privateConstructorUsedError;
  @JsonKey(name: 'DownloadId', includeIfNull: false)
  String? get downloadId => throw _privateConstructorUsedError;
  @JsonKey(name: 'LicenseId', includeIfNull: false)
  String? get licenseId => throw _privateConstructorUsedError;
  @JsonKey(name: 'CreatedOn', includeIfNull: false)
  DateTime? get createdOn => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this DownloadableProductsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DownloadableProductsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DownloadableProductsModelCopyWith<DownloadableProductsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DownloadableProductsModelCopyWith<$Res> {
  factory $DownloadableProductsModelCopyWith(
    DownloadableProductsModel value,
    $Res Function(DownloadableProductsModel) then,
  ) = _$DownloadableProductsModelCopyWithImpl<$Res, DownloadableProductsModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'OrderItemGuid', includeIfNull: false) String? orderItemGuid,
    @JsonKey(name: 'OrderId', includeIfNull: false) String? orderId,
    @JsonKey(name: 'OrderNumber', includeIfNull: false) int? orderNumber,
    @JsonKey(name: 'ProductId', includeIfNull: false) String? productId,
    @JsonKey(name: 'ProductName', includeIfNull: false) String? productName,
    @JsonKey(name: 'ProductSeName', includeIfNull: false) String? productSeName,
    @JsonKey(name: 'ProductAttributes', includeIfNull: false)
    String? productAttributes,
    @JsonKey(name: 'DownloadId', includeIfNull: false) String? downloadId,
    @JsonKey(name: 'LicenseId', includeIfNull: false) String? licenseId,
    @JsonKey(name: 'CreatedOn', includeIfNull: false) DateTime? createdOn,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$DownloadableProductsModelCopyWithImpl<
  $Res,
  $Val extends DownloadableProductsModel
>
    implements $DownloadableProductsModelCopyWith<$Res> {
  _$DownloadableProductsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DownloadableProductsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderItemGuid = freezed,
    Object? orderId = freezed,
    Object? orderNumber = freezed,
    Object? productId = freezed,
    Object? productName = freezed,
    Object? productSeName = freezed,
    Object? productAttributes = freezed,
    Object? downloadId = freezed,
    Object? licenseId = freezed,
    Object? createdOn = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            orderItemGuid:
                freezed == orderItemGuid
                    ? _value.orderItemGuid
                    : orderItemGuid // ignore: cast_nullable_to_non_nullable
                        as String?,
            orderId:
                freezed == orderId
                    ? _value.orderId
                    : orderId // ignore: cast_nullable_to_non_nullable
                        as String?,
            orderNumber:
                freezed == orderNumber
                    ? _value.orderNumber
                    : orderNumber // ignore: cast_nullable_to_non_nullable
                        as int?,
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
            productAttributes:
                freezed == productAttributes
                    ? _value.productAttributes
                    : productAttributes // ignore: cast_nullable_to_non_nullable
                        as String?,
            downloadId:
                freezed == downloadId
                    ? _value.downloadId
                    : downloadId // ignore: cast_nullable_to_non_nullable
                        as String?,
            licenseId:
                freezed == licenseId
                    ? _value.licenseId
                    : licenseId // ignore: cast_nullable_to_non_nullable
                        as String?,
            createdOn:
                freezed == createdOn
                    ? _value.createdOn
                    : createdOn // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
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
abstract class _$$DownloadableProductsModelImplCopyWith<$Res>
    implements $DownloadableProductsModelCopyWith<$Res> {
  factory _$$DownloadableProductsModelImplCopyWith(
    _$DownloadableProductsModelImpl value,
    $Res Function(_$DownloadableProductsModelImpl) then,
  ) = __$$DownloadableProductsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'OrderItemGuid', includeIfNull: false) String? orderItemGuid,
    @JsonKey(name: 'OrderId', includeIfNull: false) String? orderId,
    @JsonKey(name: 'OrderNumber', includeIfNull: false) int? orderNumber,
    @JsonKey(name: 'ProductId', includeIfNull: false) String? productId,
    @JsonKey(name: 'ProductName', includeIfNull: false) String? productName,
    @JsonKey(name: 'ProductSeName', includeIfNull: false) String? productSeName,
    @JsonKey(name: 'ProductAttributes', includeIfNull: false)
    String? productAttributes,
    @JsonKey(name: 'DownloadId', includeIfNull: false) String? downloadId,
    @JsonKey(name: 'LicenseId', includeIfNull: false) String? licenseId,
    @JsonKey(name: 'CreatedOn', includeIfNull: false) DateTime? createdOn,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$DownloadableProductsModelImplCopyWithImpl<$Res>
    extends
        _$DownloadableProductsModelCopyWithImpl<
          $Res,
          _$DownloadableProductsModelImpl
        >
    implements _$$DownloadableProductsModelImplCopyWith<$Res> {
  __$$DownloadableProductsModelImplCopyWithImpl(
    _$DownloadableProductsModelImpl _value,
    $Res Function(_$DownloadableProductsModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DownloadableProductsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderItemGuid = freezed,
    Object? orderId = freezed,
    Object? orderNumber = freezed,
    Object? productId = freezed,
    Object? productName = freezed,
    Object? productSeName = freezed,
    Object? productAttributes = freezed,
    Object? downloadId = freezed,
    Object? licenseId = freezed,
    Object? createdOn = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$DownloadableProductsModelImpl(
        orderItemGuid:
            freezed == orderItemGuid
                ? _value.orderItemGuid
                : orderItemGuid // ignore: cast_nullable_to_non_nullable
                    as String?,
        orderId:
            freezed == orderId
                ? _value.orderId
                : orderId // ignore: cast_nullable_to_non_nullable
                    as String?,
        orderNumber:
            freezed == orderNumber
                ? _value.orderNumber
                : orderNumber // ignore: cast_nullable_to_non_nullable
                    as int?,
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
        productAttributes:
            freezed == productAttributes
                ? _value.productAttributes
                : productAttributes // ignore: cast_nullable_to_non_nullable
                    as String?,
        downloadId:
            freezed == downloadId
                ? _value.downloadId
                : downloadId // ignore: cast_nullable_to_non_nullable
                    as String?,
        licenseId:
            freezed == licenseId
                ? _value.licenseId
                : licenseId // ignore: cast_nullable_to_non_nullable
                    as String?,
        createdOn:
            freezed == createdOn
                ? _value.createdOn
                : createdOn // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
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
class _$DownloadableProductsModelImpl implements _DownloadableProductsModel {
  _$DownloadableProductsModelImpl({
    @JsonKey(name: 'OrderItemGuid', includeIfNull: false) this.orderItemGuid,
    @JsonKey(name: 'OrderId', includeIfNull: false) this.orderId,
    @JsonKey(name: 'OrderNumber', includeIfNull: false) this.orderNumber,
    @JsonKey(name: 'ProductId', includeIfNull: false) this.productId,
    @JsonKey(name: 'ProductName', includeIfNull: false) this.productName,
    @JsonKey(name: 'ProductSeName', includeIfNull: false) this.productSeName,
    @JsonKey(name: 'ProductAttributes', includeIfNull: false)
    this.productAttributes,
    @JsonKey(name: 'DownloadId', includeIfNull: false) this.downloadId,
    @JsonKey(name: 'LicenseId', includeIfNull: false) this.licenseId,
    @JsonKey(name: 'CreatedOn', includeIfNull: false) this.createdOn,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _userFields = userFields;

  factory _$DownloadableProductsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DownloadableProductsModelImplFromJson(json);

  @override
  @JsonKey(name: 'OrderItemGuid', includeIfNull: false)
  final String? orderItemGuid;
  @override
  @JsonKey(name: 'OrderId', includeIfNull: false)
  final String? orderId;
  @override
  @JsonKey(name: 'OrderNumber', includeIfNull: false)
  final int? orderNumber;
  @override
  @JsonKey(name: 'ProductId', includeIfNull: false)
  final String? productId;
  @override
  @JsonKey(name: 'ProductName', includeIfNull: false)
  final String? productName;
  @override
  @JsonKey(name: 'ProductSeName', includeIfNull: false)
  final String? productSeName;
  @override
  @JsonKey(name: 'ProductAttributes', includeIfNull: false)
  final String? productAttributes;
  @override
  @JsonKey(name: 'DownloadId', includeIfNull: false)
  final String? downloadId;
  @override
  @JsonKey(name: 'LicenseId', includeIfNull: false)
  final String? licenseId;
  @override
  @JsonKey(name: 'CreatedOn', includeIfNull: false)
  final DateTime? createdOn;
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
    return 'DownloadableProductsModel(orderItemGuid: $orderItemGuid, orderId: $orderId, orderNumber: $orderNumber, productId: $productId, productName: $productName, productSeName: $productSeName, productAttributes: $productAttributes, downloadId: $downloadId, licenseId: $licenseId, createdOn: $createdOn, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DownloadableProductsModelImpl &&
            (identical(other.orderItemGuid, orderItemGuid) ||
                other.orderItemGuid == orderItemGuid) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.orderNumber, orderNumber) ||
                other.orderNumber == orderNumber) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.productSeName, productSeName) ||
                other.productSeName == productSeName) &&
            (identical(other.productAttributes, productAttributes) ||
                other.productAttributes == productAttributes) &&
            (identical(other.downloadId, downloadId) ||
                other.downloadId == downloadId) &&
            (identical(other.licenseId, licenseId) ||
                other.licenseId == licenseId) &&
            (identical(other.createdOn, createdOn) ||
                other.createdOn == createdOn) &&
            const DeepCollectionEquality().equals(
              other._userFields,
              _userFields,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    orderItemGuid,
    orderId,
    orderNumber,
    productId,
    productName,
    productSeName,
    productAttributes,
    downloadId,
    licenseId,
    createdOn,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of DownloadableProductsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DownloadableProductsModelImplCopyWith<_$DownloadableProductsModelImpl>
  get copyWith => __$$DownloadableProductsModelImplCopyWithImpl<
    _$DownloadableProductsModelImpl
  >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DownloadableProductsModelImplToJson(this);
  }
}

abstract class _DownloadableProductsModel implements DownloadableProductsModel {
  factory _DownloadableProductsModel({
    @JsonKey(name: 'OrderItemGuid', includeIfNull: false)
    final String? orderItemGuid,
    @JsonKey(name: 'OrderId', includeIfNull: false) final String? orderId,
    @JsonKey(name: 'OrderNumber', includeIfNull: false) final int? orderNumber,
    @JsonKey(name: 'ProductId', includeIfNull: false) final String? productId,
    @JsonKey(name: 'ProductName', includeIfNull: false)
    final String? productName,
    @JsonKey(name: 'ProductSeName', includeIfNull: false)
    final String? productSeName,
    @JsonKey(name: 'ProductAttributes', includeIfNull: false)
    final String? productAttributes,
    @JsonKey(name: 'DownloadId', includeIfNull: false) final String? downloadId,
    @JsonKey(name: 'LicenseId', includeIfNull: false) final String? licenseId,
    @JsonKey(name: 'CreatedOn', includeIfNull: false) final DateTime? createdOn,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$DownloadableProductsModelImpl;

  factory _DownloadableProductsModel.fromJson(Map<String, dynamic> json) =
      _$DownloadableProductsModelImpl.fromJson;

  @override
  @JsonKey(name: 'OrderItemGuid', includeIfNull: false)
  String? get orderItemGuid;
  @override
  @JsonKey(name: 'OrderId', includeIfNull: false)
  String? get orderId;
  @override
  @JsonKey(name: 'OrderNumber', includeIfNull: false)
  int? get orderNumber;
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
  @JsonKey(name: 'ProductAttributes', includeIfNull: false)
  String? get productAttributes;
  @override
  @JsonKey(name: 'DownloadId', includeIfNull: false)
  String? get downloadId;
  @override
  @JsonKey(name: 'LicenseId', includeIfNull: false)
  String? get licenseId;
  @override
  @JsonKey(name: 'CreatedOn', includeIfNull: false)
  DateTime? get createdOn;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of DownloadableProductsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DownloadableProductsModelImplCopyWith<_$DownloadableProductsModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
