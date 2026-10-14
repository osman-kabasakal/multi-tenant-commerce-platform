// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'discount_info_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DiscountInfoModel _$DiscountInfoModelFromJson(Map<String, dynamic> json) {
  return _DiscountInfoModel.fromJson(json);
}

/// @nodoc
mixin _$DiscountInfoModel {
  @JsonKey(name: 'CouponCode', includeIfNull: false)
  String? get couponCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this DiscountInfoModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DiscountInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DiscountInfoModelCopyWith<DiscountInfoModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DiscountInfoModelCopyWith<$Res> {
  factory $DiscountInfoModelCopyWith(
    DiscountInfoModel value,
    $Res Function(DiscountInfoModel) then,
  ) = _$DiscountInfoModelCopyWithImpl<$Res, DiscountInfoModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'CouponCode', includeIfNull: false) String? couponCode,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$DiscountInfoModelCopyWithImpl<$Res, $Val extends DiscountInfoModel>
    implements $DiscountInfoModelCopyWith<$Res> {
  _$DiscountInfoModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DiscountInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? couponCode = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            couponCode:
                freezed == couponCode
                    ? _value.couponCode
                    : couponCode // ignore: cast_nullable_to_non_nullable
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
abstract class _$$DiscountInfoModelImplCopyWith<$Res>
    implements $DiscountInfoModelCopyWith<$Res> {
  factory _$$DiscountInfoModelImplCopyWith(
    _$DiscountInfoModelImpl value,
    $Res Function(_$DiscountInfoModelImpl) then,
  ) = __$$DiscountInfoModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'CouponCode', includeIfNull: false) String? couponCode,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$DiscountInfoModelImplCopyWithImpl<$Res>
    extends _$DiscountInfoModelCopyWithImpl<$Res, _$DiscountInfoModelImpl>
    implements _$$DiscountInfoModelImplCopyWith<$Res> {
  __$$DiscountInfoModelImplCopyWithImpl(
    _$DiscountInfoModelImpl _value,
    $Res Function(_$DiscountInfoModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DiscountInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? couponCode = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$DiscountInfoModelImpl(
        couponCode:
            freezed == couponCode
                ? _value.couponCode
                : couponCode // ignore: cast_nullable_to_non_nullable
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
class _$DiscountInfoModelImpl implements _DiscountInfoModel {
  _$DiscountInfoModelImpl({
    @JsonKey(name: 'CouponCode', includeIfNull: false) this.couponCode,
    @JsonKey(name: 'Id', includeIfNull: false) this.id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _userFields = userFields;

  factory _$DiscountInfoModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DiscountInfoModelImplFromJson(json);

  @override
  @JsonKey(name: 'CouponCode', includeIfNull: false)
  final String? couponCode;
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
    return 'DiscountInfoModel(couponCode: $couponCode, id: $id, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DiscountInfoModelImpl &&
            (identical(other.couponCode, couponCode) ||
                other.couponCode == couponCode) &&
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
    couponCode,
    id,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of DiscountInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DiscountInfoModelImplCopyWith<_$DiscountInfoModelImpl> get copyWith =>
      __$$DiscountInfoModelImplCopyWithImpl<_$DiscountInfoModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DiscountInfoModelImplToJson(this);
  }
}

abstract class _DiscountInfoModel implements DiscountInfoModel {
  factory _DiscountInfoModel({
    @JsonKey(name: 'CouponCode', includeIfNull: false) final String? couponCode,
    @JsonKey(name: 'Id', includeIfNull: false) final String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$DiscountInfoModelImpl;

  factory _DiscountInfoModel.fromJson(Map<String, dynamic> json) =
      _$DiscountInfoModelImpl.fromJson;

  @override
  @JsonKey(name: 'CouponCode', includeIfNull: false)
  String? get couponCode;
  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of DiscountInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DiscountInfoModelImplCopyWith<_$DiscountInfoModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
