// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_notes_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CustomerNotesModel _$CustomerNotesModelFromJson(Map<String, dynamic> json) {
  return _CustomerNotesModel.fromJson(json);
}

/// @nodoc
mixin _$CustomerNotesModel {
  @JsonKey(name: 'CustomerNoteList', includeIfNull: false)
  List<CustomerNote>? get customerNoteList =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'CustomerId', includeIfNull: false)
  String? get customerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this CustomerNotesModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CustomerNotesModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CustomerNotesModelCopyWith<CustomerNotesModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomerNotesModelCopyWith<$Res> {
  factory $CustomerNotesModelCopyWith(
    CustomerNotesModel value,
    $Res Function(CustomerNotesModel) then,
  ) = _$CustomerNotesModelCopyWithImpl<$Res, CustomerNotesModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'CustomerNoteList', includeIfNull: false)
    List<CustomerNote>? customerNoteList,
    @JsonKey(name: 'CustomerId', includeIfNull: false) String? customerId,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$CustomerNotesModelCopyWithImpl<$Res, $Val extends CustomerNotesModel>
    implements $CustomerNotesModelCopyWith<$Res> {
  _$CustomerNotesModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CustomerNotesModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? customerNoteList = freezed,
    Object? customerId = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            customerNoteList:
                freezed == customerNoteList
                    ? _value.customerNoteList
                    : customerNoteList // ignore: cast_nullable_to_non_nullable
                        as List<CustomerNote>?,
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
abstract class _$$CustomerNotesModelImplCopyWith<$Res>
    implements $CustomerNotesModelCopyWith<$Res> {
  factory _$$CustomerNotesModelImplCopyWith(
    _$CustomerNotesModelImpl value,
    $Res Function(_$CustomerNotesModelImpl) then,
  ) = __$$CustomerNotesModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'CustomerNoteList', includeIfNull: false)
    List<CustomerNote>? customerNoteList,
    @JsonKey(name: 'CustomerId', includeIfNull: false) String? customerId,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$CustomerNotesModelImplCopyWithImpl<$Res>
    extends _$CustomerNotesModelCopyWithImpl<$Res, _$CustomerNotesModelImpl>
    implements _$$CustomerNotesModelImplCopyWith<$Res> {
  __$$CustomerNotesModelImplCopyWithImpl(
    _$CustomerNotesModelImpl _value,
    $Res Function(_$CustomerNotesModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CustomerNotesModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? customerNoteList = freezed,
    Object? customerId = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$CustomerNotesModelImpl(
        customerNoteList:
            freezed == customerNoteList
                ? _value._customerNoteList
                : customerNoteList // ignore: cast_nullable_to_non_nullable
                    as List<CustomerNote>?,
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
class _$CustomerNotesModelImpl implements _CustomerNotesModel {
  _$CustomerNotesModelImpl({
    @JsonKey(name: 'CustomerNoteList', includeIfNull: false)
    final List<CustomerNote>? customerNoteList = const [],
    @JsonKey(name: 'CustomerId', includeIfNull: false) this.customerId,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _customerNoteList = customerNoteList,
       _userFields = userFields;

  factory _$CustomerNotesModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CustomerNotesModelImplFromJson(json);

  final List<CustomerNote>? _customerNoteList;
  @override
  @JsonKey(name: 'CustomerNoteList', includeIfNull: false)
  List<CustomerNote>? get customerNoteList {
    final value = _customerNoteList;
    if (value == null) return null;
    if (_customerNoteList is EqualUnmodifiableListView)
      return _customerNoteList;
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
    return 'CustomerNotesModel(customerNoteList: $customerNoteList, customerId: $customerId, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerNotesModelImpl &&
            const DeepCollectionEquality().equals(
              other._customerNoteList,
              _customerNoteList,
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
    const DeepCollectionEquality().hash(_customerNoteList),
    customerId,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of CustomerNotesModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomerNotesModelImplCopyWith<_$CustomerNotesModelImpl> get copyWith =>
      __$$CustomerNotesModelImplCopyWithImpl<_$CustomerNotesModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomerNotesModelImplToJson(this);
  }
}

abstract class _CustomerNotesModel implements CustomerNotesModel {
  factory _CustomerNotesModel({
    @JsonKey(name: 'CustomerNoteList', includeIfNull: false)
    final List<CustomerNote>? customerNoteList,
    @JsonKey(name: 'CustomerId', includeIfNull: false) final String? customerId,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$CustomerNotesModelImpl;

  factory _CustomerNotesModel.fromJson(Map<String, dynamic> json) =
      _$CustomerNotesModelImpl.fromJson;

  @override
  @JsonKey(name: 'CustomerNoteList', includeIfNull: false)
  List<CustomerNote>? get customerNoteList;
  @override
  @JsonKey(name: 'CustomerId', includeIfNull: false)
  String? get customerId;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of CustomerNotesModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomerNotesModelImplCopyWith<_$CustomerNotesModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
