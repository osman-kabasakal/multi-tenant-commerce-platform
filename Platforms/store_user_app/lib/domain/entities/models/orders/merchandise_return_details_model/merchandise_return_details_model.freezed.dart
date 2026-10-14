// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'merchandise_return_details_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MerchandiseReturnDetailsModel _$MerchandiseReturnDetailsModelFromJson(
  Map<String, dynamic> json,
) {
  return _MerchandiseReturnDetailsModel.fromJson(json);
}

/// @nodoc
mixin _$MerchandiseReturnDetailsModel {
  @JsonKey(name: 'MerchandiseReturnItems', includeIfNull: false)
  List<MerchandiseReturnItemModel>? get merchandiseReturnItems =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'Comments', includeIfNull: false)
  String? get comments => throw _privateConstructorUsedError;
  @JsonKey(name: 'ReturnNumber', includeIfNull: false)
  int? get returnNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'ExternalId', includeIfNull: false)
  String? get externalId => throw _privateConstructorUsedError;
  @JsonKey(name: 'MerchandiseReturnStatus', includeIfNull: false)
  MerchandiseReturnStatus? get merchandiseReturnStatus =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'CreatedOnUtc', includeIfNull: false)
  DateTime? get createdOnUtc => throw _privateConstructorUsedError;
  @JsonKey(name: 'ShowPickupDate', includeIfNull: false)
  bool? get showPickupDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'ShowPickupAddress', includeIfNull: false)
  bool? get showPickupAddress => throw _privateConstructorUsedError;
  @JsonKey(name: 'PickupAddress', includeIfNull: false)
  AddressModel? get pickupAddress => throw _privateConstructorUsedError;
  @JsonKey(name: 'PickupDate', includeIfNull: false)
  DateTime? get pickupDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'MerchandiseReturnNotes', includeIfNull: false)
  List<MerchandiseReturnNote>? get merchandiseReturnNotes =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'ShowAddMerchandiseReturnNote', includeIfNull: false)
  bool? get showAddMerchandiseReturnNote => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this MerchandiseReturnDetailsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MerchandiseReturnDetailsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MerchandiseReturnDetailsModelCopyWith<MerchandiseReturnDetailsModel>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MerchandiseReturnDetailsModelCopyWith<$Res> {
  factory $MerchandiseReturnDetailsModelCopyWith(
    MerchandiseReturnDetailsModel value,
    $Res Function(MerchandiseReturnDetailsModel) then,
  ) =
      _$MerchandiseReturnDetailsModelCopyWithImpl<
        $Res,
        MerchandiseReturnDetailsModel
      >;
  @useResult
  $Res call({
    @JsonKey(name: 'MerchandiseReturnItems', includeIfNull: false)
    List<MerchandiseReturnItemModel>? merchandiseReturnItems,
    @JsonKey(name: 'Comments', includeIfNull: false) String? comments,
    @JsonKey(name: 'ReturnNumber', includeIfNull: false) int? returnNumber,
    @JsonKey(name: 'ExternalId', includeIfNull: false) String? externalId,
    @JsonKey(name: 'MerchandiseReturnStatus', includeIfNull: false)
    MerchandiseReturnStatus? merchandiseReturnStatus,
    @JsonKey(name: 'CreatedOnUtc', includeIfNull: false) DateTime? createdOnUtc,
    @JsonKey(name: 'ShowPickupDate', includeIfNull: false) bool? showPickupDate,
    @JsonKey(name: 'ShowPickupAddress', includeIfNull: false)
    bool? showPickupAddress,
    @JsonKey(name: 'PickupAddress', includeIfNull: false)
    AddressModel? pickupAddress,
    @JsonKey(name: 'PickupDate', includeIfNull: false) DateTime? pickupDate,
    @JsonKey(name: 'MerchandiseReturnNotes', includeIfNull: false)
    List<MerchandiseReturnNote>? merchandiseReturnNotes,
    @JsonKey(name: 'ShowAddMerchandiseReturnNote', includeIfNull: false)
    bool? showAddMerchandiseReturnNote,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  $AddressModelCopyWith<$Res>? get pickupAddress;
}

/// @nodoc
class _$MerchandiseReturnDetailsModelCopyWithImpl<
  $Res,
  $Val extends MerchandiseReturnDetailsModel
>
    implements $MerchandiseReturnDetailsModelCopyWith<$Res> {
  _$MerchandiseReturnDetailsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MerchandiseReturnDetailsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? merchandiseReturnItems = freezed,
    Object? comments = freezed,
    Object? returnNumber = freezed,
    Object? externalId = freezed,
    Object? merchandiseReturnStatus = freezed,
    Object? createdOnUtc = freezed,
    Object? showPickupDate = freezed,
    Object? showPickupAddress = freezed,
    Object? pickupAddress = freezed,
    Object? pickupDate = freezed,
    Object? merchandiseReturnNotes = freezed,
    Object? showAddMerchandiseReturnNote = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            merchandiseReturnItems:
                freezed == merchandiseReturnItems
                    ? _value.merchandiseReturnItems
                    : merchandiseReturnItems // ignore: cast_nullable_to_non_nullable
                        as List<MerchandiseReturnItemModel>?,
            comments:
                freezed == comments
                    ? _value.comments
                    : comments // ignore: cast_nullable_to_non_nullable
                        as String?,
            returnNumber:
                freezed == returnNumber
                    ? _value.returnNumber
                    : returnNumber // ignore: cast_nullable_to_non_nullable
                        as int?,
            externalId:
                freezed == externalId
                    ? _value.externalId
                    : externalId // ignore: cast_nullable_to_non_nullable
                        as String?,
            merchandiseReturnStatus:
                freezed == merchandiseReturnStatus
                    ? _value.merchandiseReturnStatus
                    : merchandiseReturnStatus // ignore: cast_nullable_to_non_nullable
                        as MerchandiseReturnStatus?,
            createdOnUtc:
                freezed == createdOnUtc
                    ? _value.createdOnUtc
                    : createdOnUtc // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            showPickupDate:
                freezed == showPickupDate
                    ? _value.showPickupDate
                    : showPickupDate // ignore: cast_nullable_to_non_nullable
                        as bool?,
            showPickupAddress:
                freezed == showPickupAddress
                    ? _value.showPickupAddress
                    : showPickupAddress // ignore: cast_nullable_to_non_nullable
                        as bool?,
            pickupAddress:
                freezed == pickupAddress
                    ? _value.pickupAddress
                    : pickupAddress // ignore: cast_nullable_to_non_nullable
                        as AddressModel?,
            pickupDate:
                freezed == pickupDate
                    ? _value.pickupDate
                    : pickupDate // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            merchandiseReturnNotes:
                freezed == merchandiseReturnNotes
                    ? _value.merchandiseReturnNotes
                    : merchandiseReturnNotes // ignore: cast_nullable_to_non_nullable
                        as List<MerchandiseReturnNote>?,
            showAddMerchandiseReturnNote:
                freezed == showAddMerchandiseReturnNote
                    ? _value.showAddMerchandiseReturnNote
                    : showAddMerchandiseReturnNote // ignore: cast_nullable_to_non_nullable
                        as bool?,
            userFields:
                freezed == userFields
                    ? _value.userFields
                    : userFields // ignore: cast_nullable_to_non_nullable
                        as List<UserField>?,
          )
          as $Val,
    );
  }

  /// Create a copy of MerchandiseReturnDetailsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AddressModelCopyWith<$Res>? get pickupAddress {
    if (_value.pickupAddress == null) {
      return null;
    }

    return $AddressModelCopyWith<$Res>(_value.pickupAddress!, (value) {
      return _then(_value.copyWith(pickupAddress: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MerchandiseReturnDetailsModelImplCopyWith<$Res>
    implements $MerchandiseReturnDetailsModelCopyWith<$Res> {
  factory _$$MerchandiseReturnDetailsModelImplCopyWith(
    _$MerchandiseReturnDetailsModelImpl value,
    $Res Function(_$MerchandiseReturnDetailsModelImpl) then,
  ) = __$$MerchandiseReturnDetailsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'MerchandiseReturnItems', includeIfNull: false)
    List<MerchandiseReturnItemModel>? merchandiseReturnItems,
    @JsonKey(name: 'Comments', includeIfNull: false) String? comments,
    @JsonKey(name: 'ReturnNumber', includeIfNull: false) int? returnNumber,
    @JsonKey(name: 'ExternalId', includeIfNull: false) String? externalId,
    @JsonKey(name: 'MerchandiseReturnStatus', includeIfNull: false)
    MerchandiseReturnStatus? merchandiseReturnStatus,
    @JsonKey(name: 'CreatedOnUtc', includeIfNull: false) DateTime? createdOnUtc,
    @JsonKey(name: 'ShowPickupDate', includeIfNull: false) bool? showPickupDate,
    @JsonKey(name: 'ShowPickupAddress', includeIfNull: false)
    bool? showPickupAddress,
    @JsonKey(name: 'PickupAddress', includeIfNull: false)
    AddressModel? pickupAddress,
    @JsonKey(name: 'PickupDate', includeIfNull: false) DateTime? pickupDate,
    @JsonKey(name: 'MerchandiseReturnNotes', includeIfNull: false)
    List<MerchandiseReturnNote>? merchandiseReturnNotes,
    @JsonKey(name: 'ShowAddMerchandiseReturnNote', includeIfNull: false)
    bool? showAddMerchandiseReturnNote,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });

  @override
  $AddressModelCopyWith<$Res>? get pickupAddress;
}

/// @nodoc
class __$$MerchandiseReturnDetailsModelImplCopyWithImpl<$Res>
    extends
        _$MerchandiseReturnDetailsModelCopyWithImpl<
          $Res,
          _$MerchandiseReturnDetailsModelImpl
        >
    implements _$$MerchandiseReturnDetailsModelImplCopyWith<$Res> {
  __$$MerchandiseReturnDetailsModelImplCopyWithImpl(
    _$MerchandiseReturnDetailsModelImpl _value,
    $Res Function(_$MerchandiseReturnDetailsModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MerchandiseReturnDetailsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? merchandiseReturnItems = freezed,
    Object? comments = freezed,
    Object? returnNumber = freezed,
    Object? externalId = freezed,
    Object? merchandiseReturnStatus = freezed,
    Object? createdOnUtc = freezed,
    Object? showPickupDate = freezed,
    Object? showPickupAddress = freezed,
    Object? pickupAddress = freezed,
    Object? pickupDate = freezed,
    Object? merchandiseReturnNotes = freezed,
    Object? showAddMerchandiseReturnNote = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$MerchandiseReturnDetailsModelImpl(
        merchandiseReturnItems:
            freezed == merchandiseReturnItems
                ? _value._merchandiseReturnItems
                : merchandiseReturnItems // ignore: cast_nullable_to_non_nullable
                    as List<MerchandiseReturnItemModel>?,
        comments:
            freezed == comments
                ? _value.comments
                : comments // ignore: cast_nullable_to_non_nullable
                    as String?,
        returnNumber:
            freezed == returnNumber
                ? _value.returnNumber
                : returnNumber // ignore: cast_nullable_to_non_nullable
                    as int?,
        externalId:
            freezed == externalId
                ? _value.externalId
                : externalId // ignore: cast_nullable_to_non_nullable
                    as String?,
        merchandiseReturnStatus:
            freezed == merchandiseReturnStatus
                ? _value.merchandiseReturnStatus
                : merchandiseReturnStatus // ignore: cast_nullable_to_non_nullable
                    as MerchandiseReturnStatus?,
        createdOnUtc:
            freezed == createdOnUtc
                ? _value.createdOnUtc
                : createdOnUtc // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        showPickupDate:
            freezed == showPickupDate
                ? _value.showPickupDate
                : showPickupDate // ignore: cast_nullable_to_non_nullable
                    as bool?,
        showPickupAddress:
            freezed == showPickupAddress
                ? _value.showPickupAddress
                : showPickupAddress // ignore: cast_nullable_to_non_nullable
                    as bool?,
        pickupAddress:
            freezed == pickupAddress
                ? _value.pickupAddress
                : pickupAddress // ignore: cast_nullable_to_non_nullable
                    as AddressModel?,
        pickupDate:
            freezed == pickupDate
                ? _value.pickupDate
                : pickupDate // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        merchandiseReturnNotes:
            freezed == merchandiseReturnNotes
                ? _value._merchandiseReturnNotes
                : merchandiseReturnNotes // ignore: cast_nullable_to_non_nullable
                    as List<MerchandiseReturnNote>?,
        showAddMerchandiseReturnNote:
            freezed == showAddMerchandiseReturnNote
                ? _value.showAddMerchandiseReturnNote
                : showAddMerchandiseReturnNote // ignore: cast_nullable_to_non_nullable
                    as bool?,
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
class _$MerchandiseReturnDetailsModelImpl
    implements _MerchandiseReturnDetailsModel {
  _$MerchandiseReturnDetailsModelImpl({
    @JsonKey(name: 'MerchandiseReturnItems', includeIfNull: false)
    final List<MerchandiseReturnItemModel>? merchandiseReturnItems = const [],
    @JsonKey(name: 'Comments', includeIfNull: false) this.comments,
    @JsonKey(name: 'ReturnNumber', includeIfNull: false) this.returnNumber,
    @JsonKey(name: 'ExternalId', includeIfNull: false) this.externalId,
    @JsonKey(name: 'MerchandiseReturnStatus', includeIfNull: false)
    this.merchandiseReturnStatus = MerchandiseReturnStatus.pending,
    @JsonKey(name: 'CreatedOnUtc', includeIfNull: false) this.createdOnUtc,
    @JsonKey(name: 'ShowPickupDate', includeIfNull: false)
    this.showPickupDate = false,
    @JsonKey(name: 'ShowPickupAddress', includeIfNull: false)
    this.showPickupAddress = false,
    @JsonKey(name: 'PickupAddress', includeIfNull: false) this.pickupAddress,
    @JsonKey(name: 'PickupDate', includeIfNull: false) this.pickupDate,
    @JsonKey(name: 'MerchandiseReturnNotes', includeIfNull: false)
    final List<MerchandiseReturnNote>? merchandiseReturnNotes = const [],
    @JsonKey(name: 'ShowAddMerchandiseReturnNote', includeIfNull: false)
    this.showAddMerchandiseReturnNote = false,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _merchandiseReturnItems = merchandiseReturnItems,
       _merchandiseReturnNotes = merchandiseReturnNotes,
       _userFields = userFields;

  factory _$MerchandiseReturnDetailsModelImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$MerchandiseReturnDetailsModelImplFromJson(json);

  final List<MerchandiseReturnItemModel>? _merchandiseReturnItems;
  @override
  @JsonKey(name: 'MerchandiseReturnItems', includeIfNull: false)
  List<MerchandiseReturnItemModel>? get merchandiseReturnItems {
    final value = _merchandiseReturnItems;
    if (value == null) return null;
    if (_merchandiseReturnItems is EqualUnmodifiableListView)
      return _merchandiseReturnItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'Comments', includeIfNull: false)
  final String? comments;
  @override
  @JsonKey(name: 'ReturnNumber', includeIfNull: false)
  final int? returnNumber;
  @override
  @JsonKey(name: 'ExternalId', includeIfNull: false)
  final String? externalId;
  @override
  @JsonKey(name: 'MerchandiseReturnStatus', includeIfNull: false)
  final MerchandiseReturnStatus? merchandiseReturnStatus;
  @override
  @JsonKey(name: 'CreatedOnUtc', includeIfNull: false)
  final DateTime? createdOnUtc;
  @override
  @JsonKey(name: 'ShowPickupDate', includeIfNull: false)
  final bool? showPickupDate;
  @override
  @JsonKey(name: 'ShowPickupAddress', includeIfNull: false)
  final bool? showPickupAddress;
  @override
  @JsonKey(name: 'PickupAddress', includeIfNull: false)
  final AddressModel? pickupAddress;
  @override
  @JsonKey(name: 'PickupDate', includeIfNull: false)
  final DateTime? pickupDate;
  final List<MerchandiseReturnNote>? _merchandiseReturnNotes;
  @override
  @JsonKey(name: 'MerchandiseReturnNotes', includeIfNull: false)
  List<MerchandiseReturnNote>? get merchandiseReturnNotes {
    final value = _merchandiseReturnNotes;
    if (value == null) return null;
    if (_merchandiseReturnNotes is EqualUnmodifiableListView)
      return _merchandiseReturnNotes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'ShowAddMerchandiseReturnNote', includeIfNull: false)
  final bool? showAddMerchandiseReturnNote;
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
    return 'MerchandiseReturnDetailsModel(merchandiseReturnItems: $merchandiseReturnItems, comments: $comments, returnNumber: $returnNumber, externalId: $externalId, merchandiseReturnStatus: $merchandiseReturnStatus, createdOnUtc: $createdOnUtc, showPickupDate: $showPickupDate, showPickupAddress: $showPickupAddress, pickupAddress: $pickupAddress, pickupDate: $pickupDate, merchandiseReturnNotes: $merchandiseReturnNotes, showAddMerchandiseReturnNote: $showAddMerchandiseReturnNote, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MerchandiseReturnDetailsModelImpl &&
            const DeepCollectionEquality().equals(
              other._merchandiseReturnItems,
              _merchandiseReturnItems,
            ) &&
            (identical(other.comments, comments) ||
                other.comments == comments) &&
            (identical(other.returnNumber, returnNumber) ||
                other.returnNumber == returnNumber) &&
            (identical(other.externalId, externalId) ||
                other.externalId == externalId) &&
            (identical(
                  other.merchandiseReturnStatus,
                  merchandiseReturnStatus,
                ) ||
                other.merchandiseReturnStatus == merchandiseReturnStatus) &&
            (identical(other.createdOnUtc, createdOnUtc) ||
                other.createdOnUtc == createdOnUtc) &&
            (identical(other.showPickupDate, showPickupDate) ||
                other.showPickupDate == showPickupDate) &&
            (identical(other.showPickupAddress, showPickupAddress) ||
                other.showPickupAddress == showPickupAddress) &&
            (identical(other.pickupAddress, pickupAddress) ||
                other.pickupAddress == pickupAddress) &&
            (identical(other.pickupDate, pickupDate) ||
                other.pickupDate == pickupDate) &&
            const DeepCollectionEquality().equals(
              other._merchandiseReturnNotes,
              _merchandiseReturnNotes,
            ) &&
            (identical(
                  other.showAddMerchandiseReturnNote,
                  showAddMerchandiseReturnNote,
                ) ||
                other.showAddMerchandiseReturnNote ==
                    showAddMerchandiseReturnNote) &&
            const DeepCollectionEquality().equals(
              other._userFields,
              _userFields,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_merchandiseReturnItems),
    comments,
    returnNumber,
    externalId,
    merchandiseReturnStatus,
    createdOnUtc,
    showPickupDate,
    showPickupAddress,
    pickupAddress,
    pickupDate,
    const DeepCollectionEquality().hash(_merchandiseReturnNotes),
    showAddMerchandiseReturnNote,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of MerchandiseReturnDetailsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MerchandiseReturnDetailsModelImplCopyWith<
    _$MerchandiseReturnDetailsModelImpl
  >
  get copyWith => __$$MerchandiseReturnDetailsModelImplCopyWithImpl<
    _$MerchandiseReturnDetailsModelImpl
  >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MerchandiseReturnDetailsModelImplToJson(this);
  }
}

abstract class _MerchandiseReturnDetailsModel
    implements MerchandiseReturnDetailsModel {
  factory _MerchandiseReturnDetailsModel({
    @JsonKey(name: 'MerchandiseReturnItems', includeIfNull: false)
    final List<MerchandiseReturnItemModel>? merchandiseReturnItems,
    @JsonKey(name: 'Comments', includeIfNull: false) final String? comments,
    @JsonKey(name: 'ReturnNumber', includeIfNull: false)
    final int? returnNumber,
    @JsonKey(name: 'ExternalId', includeIfNull: false) final String? externalId,
    @JsonKey(name: 'MerchandiseReturnStatus', includeIfNull: false)
    final MerchandiseReturnStatus? merchandiseReturnStatus,
    @JsonKey(name: 'CreatedOnUtc', includeIfNull: false)
    final DateTime? createdOnUtc,
    @JsonKey(name: 'ShowPickupDate', includeIfNull: false)
    final bool? showPickupDate,
    @JsonKey(name: 'ShowPickupAddress', includeIfNull: false)
    final bool? showPickupAddress,
    @JsonKey(name: 'PickupAddress', includeIfNull: false)
    final AddressModel? pickupAddress,
    @JsonKey(name: 'PickupDate', includeIfNull: false)
    final DateTime? pickupDate,
    @JsonKey(name: 'MerchandiseReturnNotes', includeIfNull: false)
    final List<MerchandiseReturnNote>? merchandiseReturnNotes,
    @JsonKey(name: 'ShowAddMerchandiseReturnNote', includeIfNull: false)
    final bool? showAddMerchandiseReturnNote,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$MerchandiseReturnDetailsModelImpl;

  factory _MerchandiseReturnDetailsModel.fromJson(Map<String, dynamic> json) =
      _$MerchandiseReturnDetailsModelImpl.fromJson;

  @override
  @JsonKey(name: 'MerchandiseReturnItems', includeIfNull: false)
  List<MerchandiseReturnItemModel>? get merchandiseReturnItems;
  @override
  @JsonKey(name: 'Comments', includeIfNull: false)
  String? get comments;
  @override
  @JsonKey(name: 'ReturnNumber', includeIfNull: false)
  int? get returnNumber;
  @override
  @JsonKey(name: 'ExternalId', includeIfNull: false)
  String? get externalId;
  @override
  @JsonKey(name: 'MerchandiseReturnStatus', includeIfNull: false)
  MerchandiseReturnStatus? get merchandiseReturnStatus;
  @override
  @JsonKey(name: 'CreatedOnUtc', includeIfNull: false)
  DateTime? get createdOnUtc;
  @override
  @JsonKey(name: 'ShowPickupDate', includeIfNull: false)
  bool? get showPickupDate;
  @override
  @JsonKey(name: 'ShowPickupAddress', includeIfNull: false)
  bool? get showPickupAddress;
  @override
  @JsonKey(name: 'PickupAddress', includeIfNull: false)
  AddressModel? get pickupAddress;
  @override
  @JsonKey(name: 'PickupDate', includeIfNull: false)
  DateTime? get pickupDate;
  @override
  @JsonKey(name: 'MerchandiseReturnNotes', includeIfNull: false)
  List<MerchandiseReturnNote>? get merchandiseReturnNotes;
  @override
  @JsonKey(name: 'ShowAddMerchandiseReturnNote', includeIfNull: false)
  bool? get showAddMerchandiseReturnNote;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of MerchandiseReturnDetailsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MerchandiseReturnDetailsModelImplCopyWith<
    _$MerchandiseReturnDetailsModelImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}
