// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'merchandise_return_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MerchandiseReturnModel _$MerchandiseReturnModelFromJson(
  Map<String, dynamic> json,
) {
  return _MerchandiseReturnModel.fromJson(json);
}

/// @nodoc
mixin _$MerchandiseReturnModel {
  @JsonKey(name: 'ReturnNumber', includeIfNull: false)
  int? get returnNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'MerchandiseReturnStatus', includeIfNull: false)
  String? get merchandiseReturnStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'CreatedOn', includeIfNull: false)
  DateTime? get createdOn => throw _privateConstructorUsedError;
  @JsonKey(name: 'ProductsCount', includeIfNull: false)
  int? get productsCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'ReturnTotal', includeIfNull: false)
  String? get returnTotal => throw _privateConstructorUsedError;
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this MerchandiseReturnModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MerchandiseReturnModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MerchandiseReturnModelCopyWith<MerchandiseReturnModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MerchandiseReturnModelCopyWith<$Res> {
  factory $MerchandiseReturnModelCopyWith(
    MerchandiseReturnModel value,
    $Res Function(MerchandiseReturnModel) then,
  ) = _$MerchandiseReturnModelCopyWithImpl<$Res, MerchandiseReturnModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'ReturnNumber', includeIfNull: false) int? returnNumber,
    @JsonKey(name: 'MerchandiseReturnStatus', includeIfNull: false)
    String? merchandiseReturnStatus,
    @JsonKey(name: 'CreatedOn', includeIfNull: false) DateTime? createdOn,
    @JsonKey(name: 'ProductsCount', includeIfNull: false) int? productsCount,
    @JsonKey(name: 'ReturnTotal', includeIfNull: false) String? returnTotal,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$MerchandiseReturnModelCopyWithImpl<
  $Res,
  $Val extends MerchandiseReturnModel
>
    implements $MerchandiseReturnModelCopyWith<$Res> {
  _$MerchandiseReturnModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MerchandiseReturnModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? returnNumber = freezed,
    Object? merchandiseReturnStatus = freezed,
    Object? createdOn = freezed,
    Object? productsCount = freezed,
    Object? returnTotal = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            returnNumber:
                freezed == returnNumber
                    ? _value.returnNumber
                    : returnNumber // ignore: cast_nullable_to_non_nullable
                        as int?,
            merchandiseReturnStatus:
                freezed == merchandiseReturnStatus
                    ? _value.merchandiseReturnStatus
                    : merchandiseReturnStatus // ignore: cast_nullable_to_non_nullable
                        as String?,
            createdOn:
                freezed == createdOn
                    ? _value.createdOn
                    : createdOn // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            productsCount:
                freezed == productsCount
                    ? _value.productsCount
                    : productsCount // ignore: cast_nullable_to_non_nullable
                        as int?,
            returnTotal:
                freezed == returnTotal
                    ? _value.returnTotal
                    : returnTotal // ignore: cast_nullable_to_non_nullable
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
abstract class _$$MerchandiseReturnModelImplCopyWith<$Res>
    implements $MerchandiseReturnModelCopyWith<$Res> {
  factory _$$MerchandiseReturnModelImplCopyWith(
    _$MerchandiseReturnModelImpl value,
    $Res Function(_$MerchandiseReturnModelImpl) then,
  ) = __$$MerchandiseReturnModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'ReturnNumber', includeIfNull: false) int? returnNumber,
    @JsonKey(name: 'MerchandiseReturnStatus', includeIfNull: false)
    String? merchandiseReturnStatus,
    @JsonKey(name: 'CreatedOn', includeIfNull: false) DateTime? createdOn,
    @JsonKey(name: 'ProductsCount', includeIfNull: false) int? productsCount,
    @JsonKey(name: 'ReturnTotal', includeIfNull: false) String? returnTotal,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$MerchandiseReturnModelImplCopyWithImpl<$Res>
    extends
        _$MerchandiseReturnModelCopyWithImpl<$Res, _$MerchandiseReturnModelImpl>
    implements _$$MerchandiseReturnModelImplCopyWith<$Res> {
  __$$MerchandiseReturnModelImplCopyWithImpl(
    _$MerchandiseReturnModelImpl _value,
    $Res Function(_$MerchandiseReturnModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MerchandiseReturnModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? returnNumber = freezed,
    Object? merchandiseReturnStatus = freezed,
    Object? createdOn = freezed,
    Object? productsCount = freezed,
    Object? returnTotal = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$MerchandiseReturnModelImpl(
        returnNumber:
            freezed == returnNumber
                ? _value.returnNumber
                : returnNumber // ignore: cast_nullable_to_non_nullable
                    as int?,
        merchandiseReturnStatus:
            freezed == merchandiseReturnStatus
                ? _value.merchandiseReturnStatus
                : merchandiseReturnStatus // ignore: cast_nullable_to_non_nullable
                    as String?,
        createdOn:
            freezed == createdOn
                ? _value.createdOn
                : createdOn // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        productsCount:
            freezed == productsCount
                ? _value.productsCount
                : productsCount // ignore: cast_nullable_to_non_nullable
                    as int?,
        returnTotal:
            freezed == returnTotal
                ? _value.returnTotal
                : returnTotal // ignore: cast_nullable_to_non_nullable
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
class _$MerchandiseReturnModelImpl implements _MerchandiseReturnModel {
  _$MerchandiseReturnModelImpl({
    @JsonKey(name: 'ReturnNumber', includeIfNull: false) this.returnNumber,
    @JsonKey(name: 'MerchandiseReturnStatus', includeIfNull: false)
    this.merchandiseReturnStatus,
    @JsonKey(name: 'CreatedOn', includeIfNull: false) this.createdOn,
    @JsonKey(name: 'ProductsCount', includeIfNull: false) this.productsCount,
    @JsonKey(name: 'ReturnTotal', includeIfNull: false) this.returnTotal,
    @JsonKey(name: 'Id', includeIfNull: false) this.id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _userFields = userFields;

  factory _$MerchandiseReturnModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MerchandiseReturnModelImplFromJson(json);

  @override
  @JsonKey(name: 'ReturnNumber', includeIfNull: false)
  final int? returnNumber;
  @override
  @JsonKey(name: 'MerchandiseReturnStatus', includeIfNull: false)
  final String? merchandiseReturnStatus;
  @override
  @JsonKey(name: 'CreatedOn', includeIfNull: false)
  final DateTime? createdOn;
  @override
  @JsonKey(name: 'ProductsCount', includeIfNull: false)
  final int? productsCount;
  @override
  @JsonKey(name: 'ReturnTotal', includeIfNull: false)
  final String? returnTotal;
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
    return 'MerchandiseReturnModel(returnNumber: $returnNumber, merchandiseReturnStatus: $merchandiseReturnStatus, createdOn: $createdOn, productsCount: $productsCount, returnTotal: $returnTotal, id: $id, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MerchandiseReturnModelImpl &&
            (identical(other.returnNumber, returnNumber) ||
                other.returnNumber == returnNumber) &&
            (identical(
                  other.merchandiseReturnStatus,
                  merchandiseReturnStatus,
                ) ||
                other.merchandiseReturnStatus == merchandiseReturnStatus) &&
            (identical(other.createdOn, createdOn) ||
                other.createdOn == createdOn) &&
            (identical(other.productsCount, productsCount) ||
                other.productsCount == productsCount) &&
            (identical(other.returnTotal, returnTotal) ||
                other.returnTotal == returnTotal) &&
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
    returnNumber,
    merchandiseReturnStatus,
    createdOn,
    productsCount,
    returnTotal,
    id,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of MerchandiseReturnModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MerchandiseReturnModelImplCopyWith<_$MerchandiseReturnModelImpl>
  get copyWith =>
      __$$MerchandiseReturnModelImplCopyWithImpl<_$MerchandiseReturnModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MerchandiseReturnModelImplToJson(this);
  }
}

abstract class _MerchandiseReturnModel implements MerchandiseReturnModel {
  factory _MerchandiseReturnModel({
    @JsonKey(name: 'ReturnNumber', includeIfNull: false)
    final int? returnNumber,
    @JsonKey(name: 'MerchandiseReturnStatus', includeIfNull: false)
    final String? merchandiseReturnStatus,
    @JsonKey(name: 'CreatedOn', includeIfNull: false) final DateTime? createdOn,
    @JsonKey(name: 'ProductsCount', includeIfNull: false)
    final int? productsCount,
    @JsonKey(name: 'ReturnTotal', includeIfNull: false)
    final String? returnTotal,
    @JsonKey(name: 'Id', includeIfNull: false) final String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$MerchandiseReturnModelImpl;

  factory _MerchandiseReturnModel.fromJson(Map<String, dynamic> json) =
      _$MerchandiseReturnModelImpl.fromJson;

  @override
  @JsonKey(name: 'ReturnNumber', includeIfNull: false)
  int? get returnNumber;
  @override
  @JsonKey(name: 'MerchandiseReturnStatus', includeIfNull: false)
  String? get merchandiseReturnStatus;
  @override
  @JsonKey(name: 'CreatedOn', includeIfNull: false)
  DateTime? get createdOn;
  @override
  @JsonKey(name: 'ProductsCount', includeIfNull: false)
  int? get productsCount;
  @override
  @JsonKey(name: 'ReturnTotal', includeIfNull: false)
  String? get returnTotal;
  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of MerchandiseReturnModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MerchandiseReturnModelImplCopyWith<_$MerchandiseReturnModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
