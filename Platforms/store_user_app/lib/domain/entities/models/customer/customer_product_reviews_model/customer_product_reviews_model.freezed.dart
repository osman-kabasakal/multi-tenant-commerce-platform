// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_product_reviews_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CustomerProductReviewsModel _$CustomerProductReviewsModelFromJson(
  Map<String, dynamic> json,
) {
  return _CustomerProductReviewsModel.fromJson(json);
}

/// @nodoc
mixin _$CustomerProductReviewsModel {
  @JsonKey(name: 'CustomerId', includeIfNull: false)
  String? get customerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'CustomerInfo', includeIfNull: false)
  String? get customerInfo => throw _privateConstructorUsedError;
  @JsonKey(name: 'Reviews', includeIfNull: false)
  List<CustomerProductReviewModel>? get reviews =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this CustomerProductReviewsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CustomerProductReviewsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CustomerProductReviewsModelCopyWith<CustomerProductReviewsModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomerProductReviewsModelCopyWith<$Res> {
  factory $CustomerProductReviewsModelCopyWith(
    CustomerProductReviewsModel value,
    $Res Function(CustomerProductReviewsModel) then,
  ) =
      _$CustomerProductReviewsModelCopyWithImpl<
        $Res,
        CustomerProductReviewsModel
      >;
  @useResult
  $Res call({
    @JsonKey(name: 'CustomerId', includeIfNull: false) String? customerId,
    @JsonKey(name: 'CustomerInfo', includeIfNull: false) String? customerInfo,
    @JsonKey(name: 'Reviews', includeIfNull: false)
    List<CustomerProductReviewModel>? reviews,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$CustomerProductReviewsModelCopyWithImpl<
  $Res,
  $Val extends CustomerProductReviewsModel
>
    implements $CustomerProductReviewsModelCopyWith<$Res> {
  _$CustomerProductReviewsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CustomerProductReviewsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? customerId = freezed,
    Object? customerInfo = freezed,
    Object? reviews = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            customerId:
                freezed == customerId
                    ? _value.customerId
                    : customerId // ignore: cast_nullable_to_non_nullable
                        as String?,
            customerInfo:
                freezed == customerInfo
                    ? _value.customerInfo
                    : customerInfo // ignore: cast_nullable_to_non_nullable
                        as String?,
            reviews:
                freezed == reviews
                    ? _value.reviews
                    : reviews // ignore: cast_nullable_to_non_nullable
                        as List<CustomerProductReviewModel>?,
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
abstract class _$$CustomerProductReviewsModelImplCopyWith<$Res>
    implements $CustomerProductReviewsModelCopyWith<$Res> {
  factory _$$CustomerProductReviewsModelImplCopyWith(
    _$CustomerProductReviewsModelImpl value,
    $Res Function(_$CustomerProductReviewsModelImpl) then,
  ) = __$$CustomerProductReviewsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'CustomerId', includeIfNull: false) String? customerId,
    @JsonKey(name: 'CustomerInfo', includeIfNull: false) String? customerInfo,
    @JsonKey(name: 'Reviews', includeIfNull: false)
    List<CustomerProductReviewModel>? reviews,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$CustomerProductReviewsModelImplCopyWithImpl<$Res>
    extends
        _$CustomerProductReviewsModelCopyWithImpl<
          $Res,
          _$CustomerProductReviewsModelImpl
        >
    implements _$$CustomerProductReviewsModelImplCopyWith<$Res> {
  __$$CustomerProductReviewsModelImplCopyWithImpl(
    _$CustomerProductReviewsModelImpl _value,
    $Res Function(_$CustomerProductReviewsModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CustomerProductReviewsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? customerId = freezed,
    Object? customerInfo = freezed,
    Object? reviews = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$CustomerProductReviewsModelImpl(
        customerId:
            freezed == customerId
                ? _value.customerId
                : customerId // ignore: cast_nullable_to_non_nullable
                    as String?,
        customerInfo:
            freezed == customerInfo
                ? _value.customerInfo
                : customerInfo // ignore: cast_nullable_to_non_nullable
                    as String?,
        reviews:
            freezed == reviews
                ? _value._reviews
                : reviews // ignore: cast_nullable_to_non_nullable
                    as List<CustomerProductReviewModel>?,
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
class _$CustomerProductReviewsModelImpl
    implements _CustomerProductReviewsModel {
  _$CustomerProductReviewsModelImpl({
    @JsonKey(name: 'CustomerId', includeIfNull: false) this.customerId,
    @JsonKey(name: 'CustomerInfo', includeIfNull: false) this.customerInfo,
    @JsonKey(name: 'Reviews', includeIfNull: false)
    final List<CustomerProductReviewModel>? reviews = const [],
    @JsonKey(name: 'Id', includeIfNull: false) this.id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _reviews = reviews,
       _userFields = userFields;

  factory _$CustomerProductReviewsModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$CustomerProductReviewsModelImplFromJson(json);

  @override
  @JsonKey(name: 'CustomerId', includeIfNull: false)
  final String? customerId;
  @override
  @JsonKey(name: 'CustomerInfo', includeIfNull: false)
  final String? customerInfo;
  final List<CustomerProductReviewModel>? _reviews;
  @override
  @JsonKey(name: 'Reviews', includeIfNull: false)
  List<CustomerProductReviewModel>? get reviews {
    final value = _reviews;
    if (value == null) return null;
    if (_reviews is EqualUnmodifiableListView) return _reviews;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

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
    return 'CustomerProductReviewsModel(customerId: $customerId, customerInfo: $customerInfo, reviews: $reviews, id: $id, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerProductReviewsModelImpl &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.customerInfo, customerInfo) ||
                other.customerInfo == customerInfo) &&
            const DeepCollectionEquality().equals(other._reviews, _reviews) &&
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
    customerId,
    customerInfo,
    const DeepCollectionEquality().hash(_reviews),
    id,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of CustomerProductReviewsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomerProductReviewsModelImplCopyWith<_$CustomerProductReviewsModelImpl>
  get copyWith => __$$CustomerProductReviewsModelImplCopyWithImpl<
    _$CustomerProductReviewsModelImpl
  >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomerProductReviewsModelImplToJson(this);
  }
}

abstract class _CustomerProductReviewsModel
    implements CustomerProductReviewsModel {
  factory _CustomerProductReviewsModel({
    @JsonKey(name: 'CustomerId', includeIfNull: false) final String? customerId,
    @JsonKey(name: 'CustomerInfo', includeIfNull: false)
    final String? customerInfo,
    @JsonKey(name: 'Reviews', includeIfNull: false)
    final List<CustomerProductReviewModel>? reviews,
    @JsonKey(name: 'Id', includeIfNull: false) final String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$CustomerProductReviewsModelImpl;

  factory _CustomerProductReviewsModel.fromJson(Map<String, dynamic> json) =
      _$CustomerProductReviewsModelImpl.fromJson;

  @override
  @JsonKey(name: 'CustomerId', includeIfNull: false)
  String? get customerId;
  @override
  @JsonKey(name: 'CustomerInfo', includeIfNull: false)
  String? get customerInfo;
  @override
  @JsonKey(name: 'Reviews', includeIfNull: false)
  List<CustomerProductReviewModel>? get reviews;
  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of CustomerProductReviewsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomerProductReviewsModelImplCopyWith<_$CustomerProductReviewsModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
