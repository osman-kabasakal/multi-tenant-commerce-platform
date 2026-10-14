// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shipment_status_event_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ShipmentStatusEventModel _$ShipmentStatusEventModelFromJson(
  Map<String, dynamic> json,
) {
  return _ShipmentStatusEventModel.fromJson(json);
}

/// @nodoc
mixin _$ShipmentStatusEventModel {
  @JsonKey(name: 'EventName', includeIfNull: false)
  String? get eventName => throw _privateConstructorUsedError;
  @JsonKey(name: 'Location', includeIfNull: false)
  String? get location => throw _privateConstructorUsedError;
  @JsonKey(name: 'Country', includeIfNull: false)
  String? get country => throw _privateConstructorUsedError;
  @JsonKey(name: 'Date', includeIfNull: false)
  DateTime? get date => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this ShipmentStatusEventModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ShipmentStatusEventModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShipmentStatusEventModelCopyWith<ShipmentStatusEventModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShipmentStatusEventModelCopyWith<$Res> {
  factory $ShipmentStatusEventModelCopyWith(
    ShipmentStatusEventModel value,
    $Res Function(ShipmentStatusEventModel) then,
  ) = _$ShipmentStatusEventModelCopyWithImpl<$Res, ShipmentStatusEventModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'EventName', includeIfNull: false) String? eventName,
    @JsonKey(name: 'Location', includeIfNull: false) String? location,
    @JsonKey(name: 'Country', includeIfNull: false) String? country,
    @JsonKey(name: 'Date', includeIfNull: false) DateTime? date,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$ShipmentStatusEventModelCopyWithImpl<
  $Res,
  $Val extends ShipmentStatusEventModel
>
    implements $ShipmentStatusEventModelCopyWith<$Res> {
  _$ShipmentStatusEventModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShipmentStatusEventModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventName = freezed,
    Object? location = freezed,
    Object? country = freezed,
    Object? date = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            eventName:
                freezed == eventName
                    ? _value.eventName
                    : eventName // ignore: cast_nullable_to_non_nullable
                        as String?,
            location:
                freezed == location
                    ? _value.location
                    : location // ignore: cast_nullable_to_non_nullable
                        as String?,
            country:
                freezed == country
                    ? _value.country
                    : country // ignore: cast_nullable_to_non_nullable
                        as String?,
            date:
                freezed == date
                    ? _value.date
                    : date // ignore: cast_nullable_to_non_nullable
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
abstract class _$$ShipmentStatusEventModelImplCopyWith<$Res>
    implements $ShipmentStatusEventModelCopyWith<$Res> {
  factory _$$ShipmentStatusEventModelImplCopyWith(
    _$ShipmentStatusEventModelImpl value,
    $Res Function(_$ShipmentStatusEventModelImpl) then,
  ) = __$$ShipmentStatusEventModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'EventName', includeIfNull: false) String? eventName,
    @JsonKey(name: 'Location', includeIfNull: false) String? location,
    @JsonKey(name: 'Country', includeIfNull: false) String? country,
    @JsonKey(name: 'Date', includeIfNull: false) DateTime? date,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$ShipmentStatusEventModelImplCopyWithImpl<$Res>
    extends
        _$ShipmentStatusEventModelCopyWithImpl<
          $Res,
          _$ShipmentStatusEventModelImpl
        >
    implements _$$ShipmentStatusEventModelImplCopyWith<$Res> {
  __$$ShipmentStatusEventModelImplCopyWithImpl(
    _$ShipmentStatusEventModelImpl _value,
    $Res Function(_$ShipmentStatusEventModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ShipmentStatusEventModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventName = freezed,
    Object? location = freezed,
    Object? country = freezed,
    Object? date = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$ShipmentStatusEventModelImpl(
        eventName:
            freezed == eventName
                ? _value.eventName
                : eventName // ignore: cast_nullable_to_non_nullable
                    as String?,
        location:
            freezed == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                    as String?,
        country:
            freezed == country
                ? _value.country
                : country // ignore: cast_nullable_to_non_nullable
                    as String?,
        date:
            freezed == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
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
class _$ShipmentStatusEventModelImpl implements _ShipmentStatusEventModel {
  _$ShipmentStatusEventModelImpl({
    @JsonKey(name: 'EventName', includeIfNull: false) this.eventName,
    @JsonKey(name: 'Location', includeIfNull: false) this.location,
    @JsonKey(name: 'Country', includeIfNull: false) this.country,
    @JsonKey(name: 'Date', includeIfNull: false) this.date = null,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _userFields = userFields;

  factory _$ShipmentStatusEventModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShipmentStatusEventModelImplFromJson(json);

  @override
  @JsonKey(name: 'EventName', includeIfNull: false)
  final String? eventName;
  @override
  @JsonKey(name: 'Location', includeIfNull: false)
  final String? location;
  @override
  @JsonKey(name: 'Country', includeIfNull: false)
  final String? country;
  @override
  @JsonKey(name: 'Date', includeIfNull: false)
  final DateTime? date;
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
    return 'ShipmentStatusEventModel(eventName: $eventName, location: $location, country: $country, date: $date, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShipmentStatusEventModelImpl &&
            (identical(other.eventName, eventName) ||
                other.eventName == eventName) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.date, date) || other.date == date) &&
            const DeepCollectionEquality().equals(
              other._userFields,
              _userFields,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    eventName,
    location,
    country,
    date,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of ShipmentStatusEventModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShipmentStatusEventModelImplCopyWith<_$ShipmentStatusEventModelImpl>
  get copyWith => __$$ShipmentStatusEventModelImplCopyWithImpl<
    _$ShipmentStatusEventModelImpl
  >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ShipmentStatusEventModelImplToJson(this);
  }
}

abstract class _ShipmentStatusEventModel implements ShipmentStatusEventModel {
  factory _ShipmentStatusEventModel({
    @JsonKey(name: 'EventName', includeIfNull: false) final String? eventName,
    @JsonKey(name: 'Location', includeIfNull: false) final String? location,
    @JsonKey(name: 'Country', includeIfNull: false) final String? country,
    @JsonKey(name: 'Date', includeIfNull: false) final DateTime? date,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$ShipmentStatusEventModelImpl;

  factory _ShipmentStatusEventModel.fromJson(Map<String, dynamic> json) =
      _$ShipmentStatusEventModelImpl.fromJson;

  @override
  @JsonKey(name: 'EventName', includeIfNull: false)
  String? get eventName;
  @override
  @JsonKey(name: 'Location', includeIfNull: false)
  String? get location;
  @override
  @JsonKey(name: 'Country', includeIfNull: false)
  String? get country;
  @override
  @JsonKey(name: 'Date', includeIfNull: false)
  DateTime? get date;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of ShipmentStatusEventModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShipmentStatusEventModelImplCopyWith<_$ShipmentStatusEventModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
