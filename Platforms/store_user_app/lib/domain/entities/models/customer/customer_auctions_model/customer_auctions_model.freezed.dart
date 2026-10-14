// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_auctions_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CustomerAuctionsModel _$CustomerAuctionsModelFromJson(
  Map<String, dynamic> json,
) {
  return _CustomerAuctionsModel.fromJson(json);
}

/// @nodoc
mixin _$CustomerAuctionsModel {
  @JsonKey(name: 'ProductBidList', includeIfNull: false)
  List<ProductBidTuple>? get productBidList =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'CustomerId', includeIfNull: false)
  String? get customerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this CustomerAuctionsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CustomerAuctionsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CustomerAuctionsModelCopyWith<CustomerAuctionsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomerAuctionsModelCopyWith<$Res> {
  factory $CustomerAuctionsModelCopyWith(
    CustomerAuctionsModel value,
    $Res Function(CustomerAuctionsModel) then,
  ) = _$CustomerAuctionsModelCopyWithImpl<$Res, CustomerAuctionsModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'ProductBidList', includeIfNull: false)
    List<ProductBidTuple>? productBidList,
    @JsonKey(name: 'CustomerId', includeIfNull: false) String? customerId,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$CustomerAuctionsModelCopyWithImpl<
  $Res,
  $Val extends CustomerAuctionsModel
>
    implements $CustomerAuctionsModelCopyWith<$Res> {
  _$CustomerAuctionsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CustomerAuctionsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productBidList = freezed,
    Object? customerId = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            productBidList:
                freezed == productBidList
                    ? _value.productBidList
                    : productBidList // ignore: cast_nullable_to_non_nullable
                        as List<ProductBidTuple>?,
            customerId:
                freezed == customerId
                    ? _value.customerId
                    : customerId // ignore: cast_nullable_to_non_nullable
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
abstract class _$$CustomerAuctionsModelImplCopyWith<$Res>
    implements $CustomerAuctionsModelCopyWith<$Res> {
  factory _$$CustomerAuctionsModelImplCopyWith(
    _$CustomerAuctionsModelImpl value,
    $Res Function(_$CustomerAuctionsModelImpl) then,
  ) = __$$CustomerAuctionsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'ProductBidList', includeIfNull: false)
    List<ProductBidTuple>? productBidList,
    @JsonKey(name: 'CustomerId', includeIfNull: false) String? customerId,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$CustomerAuctionsModelImplCopyWithImpl<$Res>
    extends
        _$CustomerAuctionsModelCopyWithImpl<$Res, _$CustomerAuctionsModelImpl>
    implements _$$CustomerAuctionsModelImplCopyWith<$Res> {
  __$$CustomerAuctionsModelImplCopyWithImpl(
    _$CustomerAuctionsModelImpl _value,
    $Res Function(_$CustomerAuctionsModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CustomerAuctionsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productBidList = freezed,
    Object? customerId = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$CustomerAuctionsModelImpl(
        productBidList:
            freezed == productBidList
                ? _value._productBidList
                : productBidList // ignore: cast_nullable_to_non_nullable
                    as List<ProductBidTuple>?,
        customerId:
            freezed == customerId
                ? _value.customerId
                : customerId // ignore: cast_nullable_to_non_nullable
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
class _$CustomerAuctionsModelImpl extends _CustomerAuctionsModel {
  _$CustomerAuctionsModelImpl({
    @JsonKey(name: 'ProductBidList', includeIfNull: false)
    final List<ProductBidTuple>? productBidList = const [],
    @JsonKey(name: 'CustomerId', includeIfNull: false) this.customerId,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _productBidList = productBidList,
       _userFields = userFields,
       super._();

  factory _$CustomerAuctionsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CustomerAuctionsModelImplFromJson(json);

  final List<ProductBidTuple>? _productBidList;
  @override
  @JsonKey(name: 'ProductBidList', includeIfNull: false)
  List<ProductBidTuple>? get productBidList {
    final value = _productBidList;
    if (value == null) return null;
    if (_productBidList is EqualUnmodifiableListView) return _productBidList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'CustomerId', includeIfNull: false)
  final String? customerId;
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
    return 'CustomerAuctionsModel(productBidList: $productBidList, customerId: $customerId, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerAuctionsModelImpl &&
            const DeepCollectionEquality().equals(
              other._productBidList,
              _productBidList,
            ) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            const DeepCollectionEquality().equals(
              other._userFields,
              _userFields,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_productBidList),
    customerId,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of CustomerAuctionsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomerAuctionsModelImplCopyWith<_$CustomerAuctionsModelImpl>
  get copyWith =>
      __$$CustomerAuctionsModelImplCopyWithImpl<_$CustomerAuctionsModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomerAuctionsModelImplToJson(this);
  }
}

abstract class _CustomerAuctionsModel extends CustomerAuctionsModel {
  factory _CustomerAuctionsModel({
    @JsonKey(name: 'ProductBidList', includeIfNull: false)
    final List<ProductBidTuple>? productBidList,
    @JsonKey(name: 'CustomerId', includeIfNull: false) final String? customerId,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$CustomerAuctionsModelImpl;
  _CustomerAuctionsModel._() : super._();

  factory _CustomerAuctionsModel.fromJson(Map<String, dynamic> json) =
      _$CustomerAuctionsModelImpl.fromJson;

  @override
  @JsonKey(name: 'ProductBidList', includeIfNull: false)
  List<ProductBidTuple>? get productBidList;
  @override
  @JsonKey(name: 'CustomerId', includeIfNull: false)
  String? get customerId;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of CustomerAuctionsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomerAuctionsModelImplCopyWith<_$CustomerAuctionsModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
