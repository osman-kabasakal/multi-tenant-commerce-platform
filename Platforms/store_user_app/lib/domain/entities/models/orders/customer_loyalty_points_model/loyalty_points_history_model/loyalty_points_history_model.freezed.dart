// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'loyalty_points_history_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LoyaltyPointsHistoryModel _$LoyaltyPointsHistoryModelFromJson(
  Map<String, dynamic> json,
) {
  return _LoyaltyPointsHistoryModel.fromJson(json);
}

/// @nodoc
mixin _$LoyaltyPointsHistoryModel {
  @JsonKey(name: 'Points', includeIfNull: false)
  int? get points => throw _privateConstructorUsedError;
  @JsonKey(name: 'PointsBalance', includeIfNull: false)
  int? get pointsBalance => throw _privateConstructorUsedError;
  @JsonKey(name: 'Message', includeIfNull: false)
  String? get message => throw _privateConstructorUsedError;
  @JsonKey(name: 'CreatedOn', includeIfNull: false)
  DateTime? get createdOn => throw _privateConstructorUsedError;
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this LoyaltyPointsHistoryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LoyaltyPointsHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LoyaltyPointsHistoryModelCopyWith<LoyaltyPointsHistoryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoyaltyPointsHistoryModelCopyWith<$Res> {
  factory $LoyaltyPointsHistoryModelCopyWith(
    LoyaltyPointsHistoryModel value,
    $Res Function(LoyaltyPointsHistoryModel) then,
  ) = _$LoyaltyPointsHistoryModelCopyWithImpl<$Res, LoyaltyPointsHistoryModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'Points', includeIfNull: false) int? points,
    @JsonKey(name: 'PointsBalance', includeIfNull: false) int? pointsBalance,
    @JsonKey(name: 'Message', includeIfNull: false) String? message,
    @JsonKey(name: 'CreatedOn', includeIfNull: false) DateTime? createdOn,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$LoyaltyPointsHistoryModelCopyWithImpl<
  $Res,
  $Val extends LoyaltyPointsHistoryModel
>
    implements $LoyaltyPointsHistoryModelCopyWith<$Res> {
  _$LoyaltyPointsHistoryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LoyaltyPointsHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? points = freezed,
    Object? pointsBalance = freezed,
    Object? message = freezed,
    Object? createdOn = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            points:
                freezed == points
                    ? _value.points
                    : points // ignore: cast_nullable_to_non_nullable
                        as int?,
            pointsBalance:
                freezed == pointsBalance
                    ? _value.pointsBalance
                    : pointsBalance // ignore: cast_nullable_to_non_nullable
                        as int?,
            message:
                freezed == message
                    ? _value.message
                    : message // ignore: cast_nullable_to_non_nullable
                        as String?,
            createdOn:
                freezed == createdOn
                    ? _value.createdOn
                    : createdOn // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
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
abstract class _$$LoyaltyPointsHistoryModelImplCopyWith<$Res>
    implements $LoyaltyPointsHistoryModelCopyWith<$Res> {
  factory _$$LoyaltyPointsHistoryModelImplCopyWith(
    _$LoyaltyPointsHistoryModelImpl value,
    $Res Function(_$LoyaltyPointsHistoryModelImpl) then,
  ) = __$$LoyaltyPointsHistoryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'Points', includeIfNull: false) int? points,
    @JsonKey(name: 'PointsBalance', includeIfNull: false) int? pointsBalance,
    @JsonKey(name: 'Message', includeIfNull: false) String? message,
    @JsonKey(name: 'CreatedOn', includeIfNull: false) DateTime? createdOn,
    @JsonKey(name: 'Id', includeIfNull: false) String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$LoyaltyPointsHistoryModelImplCopyWithImpl<$Res>
    extends
        _$LoyaltyPointsHistoryModelCopyWithImpl<
          $Res,
          _$LoyaltyPointsHistoryModelImpl
        >
    implements _$$LoyaltyPointsHistoryModelImplCopyWith<$Res> {
  __$$LoyaltyPointsHistoryModelImplCopyWithImpl(
    _$LoyaltyPointsHistoryModelImpl _value,
    $Res Function(_$LoyaltyPointsHistoryModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LoyaltyPointsHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? points = freezed,
    Object? pointsBalance = freezed,
    Object? message = freezed,
    Object? createdOn = freezed,
    Object? id = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$LoyaltyPointsHistoryModelImpl(
        points:
            freezed == points
                ? _value.points
                : points // ignore: cast_nullable_to_non_nullable
                    as int?,
        pointsBalance:
            freezed == pointsBalance
                ? _value.pointsBalance
                : pointsBalance // ignore: cast_nullable_to_non_nullable
                    as int?,
        message:
            freezed == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                    as String?,
        createdOn:
            freezed == createdOn
                ? _value.createdOn
                : createdOn // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
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
class _$LoyaltyPointsHistoryModelImpl implements _LoyaltyPointsHistoryModel {
  _$LoyaltyPointsHistoryModelImpl({
    @JsonKey(name: 'Points', includeIfNull: false) this.points,
    @JsonKey(name: 'PointsBalance', includeIfNull: false) this.pointsBalance,
    @JsonKey(name: 'Message', includeIfNull: false) this.message,
    @JsonKey(name: 'CreatedOn', includeIfNull: false) this.createdOn,
    @JsonKey(name: 'Id', includeIfNull: false) this.id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _userFields = userFields;

  factory _$LoyaltyPointsHistoryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoyaltyPointsHistoryModelImplFromJson(json);

  @override
  @JsonKey(name: 'Points', includeIfNull: false)
  final int? points;
  @override
  @JsonKey(name: 'PointsBalance', includeIfNull: false)
  final int? pointsBalance;
  @override
  @JsonKey(name: 'Message', includeIfNull: false)
  final String? message;
  @override
  @JsonKey(name: 'CreatedOn', includeIfNull: false)
  final DateTime? createdOn;
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
    return 'LoyaltyPointsHistoryModel(points: $points, pointsBalance: $pointsBalance, message: $message, createdOn: $createdOn, id: $id, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoyaltyPointsHistoryModelImpl &&
            (identical(other.points, points) || other.points == points) &&
            (identical(other.pointsBalance, pointsBalance) ||
                other.pointsBalance == pointsBalance) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.createdOn, createdOn) ||
                other.createdOn == createdOn) &&
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
    points,
    pointsBalance,
    message,
    createdOn,
    id,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of LoyaltyPointsHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoyaltyPointsHistoryModelImplCopyWith<_$LoyaltyPointsHistoryModelImpl>
  get copyWith => __$$LoyaltyPointsHistoryModelImplCopyWithImpl<
    _$LoyaltyPointsHistoryModelImpl
  >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LoyaltyPointsHistoryModelImplToJson(this);
  }
}

abstract class _LoyaltyPointsHistoryModel implements LoyaltyPointsHistoryModel {
  factory _LoyaltyPointsHistoryModel({
    @JsonKey(name: 'Points', includeIfNull: false) final int? points,
    @JsonKey(name: 'PointsBalance', includeIfNull: false)
    final int? pointsBalance,
    @JsonKey(name: 'Message', includeIfNull: false) final String? message,
    @JsonKey(name: 'CreatedOn', includeIfNull: false) final DateTime? createdOn,
    @JsonKey(name: 'Id', includeIfNull: false) final String? id,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$LoyaltyPointsHistoryModelImpl;

  factory _LoyaltyPointsHistoryModel.fromJson(Map<String, dynamic> json) =
      _$LoyaltyPointsHistoryModelImpl.fromJson;

  @override
  @JsonKey(name: 'Points', includeIfNull: false)
  int? get points;
  @override
  @JsonKey(name: 'PointsBalance', includeIfNull: false)
  int? get pointsBalance;
  @override
  @JsonKey(name: 'Message', includeIfNull: false)
  String? get message;
  @override
  @JsonKey(name: 'CreatedOn', includeIfNull: false)
  DateTime? get createdOn;
  @override
  @JsonKey(name: 'Id', includeIfNull: false)
  String? get id;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of LoyaltyPointsHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoyaltyPointsHistoryModelImplCopyWith<_$LoyaltyPointsHistoryModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
