// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'iyzico_payment_info_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

IyzicoPaymentInfoModel _$IyzicoPaymentInfoModelFromJson(
  Map<String, dynamic> json,
) {
  return _IyzicoPaymentInfoModel.fromJson(json);
}

/// @nodoc
mixin _$IyzicoPaymentInfoModel {
  @JsonKey(name: 'CreditCardFormData', includeIfNull: false)
  Map<String, FieldDefinition>? get creditCardFormData =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'StoredUserCards', includeIfNull: false)
  List<Card>? get storedUserCards => throw _privateConstructorUsedError;
  @JsonKey(name: 'SandBox', includeIfNull: false)
  bool? get sandBox => throw _privateConstructorUsedError;
  @JsonKey(name: 'SelectedCardToken', includeIfNull: false)
  String? get selectedCardToken => throw _privateConstructorUsedError;
  @JsonKey(name: 'InstallmentQueryUrl', includeIfNull: false)
  String? get installmentQueryUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'IyzicoBrandImageUrl', includeIfNull: false)
  String? get iyzicoBrandImageUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'CreditCardBrandUrl', includeIfNull: false)
  String? get creditCardBrandUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields => throw _privateConstructorUsedError;

  /// Serializes this IyzicoPaymentInfoModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of IyzicoPaymentInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IyzicoPaymentInfoModelCopyWith<IyzicoPaymentInfoModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IyzicoPaymentInfoModelCopyWith<$Res> {
  factory $IyzicoPaymentInfoModelCopyWith(
    IyzicoPaymentInfoModel value,
    $Res Function(IyzicoPaymentInfoModel) then,
  ) = _$IyzicoPaymentInfoModelCopyWithImpl<$Res, IyzicoPaymentInfoModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'CreditCardFormData', includeIfNull: false)
    Map<String, FieldDefinition>? creditCardFormData,
    @JsonKey(name: 'StoredUserCards', includeIfNull: false)
    List<Card>? storedUserCards,
    @JsonKey(name: 'SandBox', includeIfNull: false) bool? sandBox,
    @JsonKey(name: 'SelectedCardToken', includeIfNull: false)
    String? selectedCardToken,
    @JsonKey(name: 'InstallmentQueryUrl', includeIfNull: false)
    String? installmentQueryUrl,
    @JsonKey(name: 'IyzicoBrandImageUrl', includeIfNull: false)
    String? iyzicoBrandImageUrl,
    @JsonKey(name: 'CreditCardBrandUrl', includeIfNull: false)
    String? creditCardBrandUrl,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class _$IyzicoPaymentInfoModelCopyWithImpl<
  $Res,
  $Val extends IyzicoPaymentInfoModel
>
    implements $IyzicoPaymentInfoModelCopyWith<$Res> {
  _$IyzicoPaymentInfoModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IyzicoPaymentInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? creditCardFormData = freezed,
    Object? storedUserCards = freezed,
    Object? sandBox = freezed,
    Object? selectedCardToken = freezed,
    Object? installmentQueryUrl = freezed,
    Object? iyzicoBrandImageUrl = freezed,
    Object? creditCardBrandUrl = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _value.copyWith(
            creditCardFormData:
                freezed == creditCardFormData
                    ? _value.creditCardFormData
                    : creditCardFormData // ignore: cast_nullable_to_non_nullable
                        as Map<String, FieldDefinition>?,
            storedUserCards:
                freezed == storedUserCards
                    ? _value.storedUserCards
                    : storedUserCards // ignore: cast_nullable_to_non_nullable
                        as List<Card>?,
            sandBox:
                freezed == sandBox
                    ? _value.sandBox
                    : sandBox // ignore: cast_nullable_to_non_nullable
                        as bool?,
            selectedCardToken:
                freezed == selectedCardToken
                    ? _value.selectedCardToken
                    : selectedCardToken // ignore: cast_nullable_to_non_nullable
                        as String?,
            installmentQueryUrl:
                freezed == installmentQueryUrl
                    ? _value.installmentQueryUrl
                    : installmentQueryUrl // ignore: cast_nullable_to_non_nullable
                        as String?,
            iyzicoBrandImageUrl:
                freezed == iyzicoBrandImageUrl
                    ? _value.iyzicoBrandImageUrl
                    : iyzicoBrandImageUrl // ignore: cast_nullable_to_non_nullable
                        as String?,
            creditCardBrandUrl:
                freezed == creditCardBrandUrl
                    ? _value.creditCardBrandUrl
                    : creditCardBrandUrl // ignore: cast_nullable_to_non_nullable
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
abstract class _$$IyzicoPaymentInfoModelImplCopyWith<$Res>
    implements $IyzicoPaymentInfoModelCopyWith<$Res> {
  factory _$$IyzicoPaymentInfoModelImplCopyWith(
    _$IyzicoPaymentInfoModelImpl value,
    $Res Function(_$IyzicoPaymentInfoModelImpl) then,
  ) = __$$IyzicoPaymentInfoModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'CreditCardFormData', includeIfNull: false)
    Map<String, FieldDefinition>? creditCardFormData,
    @JsonKey(name: 'StoredUserCards', includeIfNull: false)
    List<Card>? storedUserCards,
    @JsonKey(name: 'SandBox', includeIfNull: false) bool? sandBox,
    @JsonKey(name: 'SelectedCardToken', includeIfNull: false)
    String? selectedCardToken,
    @JsonKey(name: 'InstallmentQueryUrl', includeIfNull: false)
    String? installmentQueryUrl,
    @JsonKey(name: 'IyzicoBrandImageUrl', includeIfNull: false)
    String? iyzicoBrandImageUrl,
    @JsonKey(name: 'CreditCardBrandUrl', includeIfNull: false)
    String? creditCardBrandUrl,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    List<UserField>? userFields,
  });
}

/// @nodoc
class __$$IyzicoPaymentInfoModelImplCopyWithImpl<$Res>
    extends
        _$IyzicoPaymentInfoModelCopyWithImpl<$Res, _$IyzicoPaymentInfoModelImpl>
    implements _$$IyzicoPaymentInfoModelImplCopyWith<$Res> {
  __$$IyzicoPaymentInfoModelImplCopyWithImpl(
    _$IyzicoPaymentInfoModelImpl _value,
    $Res Function(_$IyzicoPaymentInfoModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of IyzicoPaymentInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? creditCardFormData = freezed,
    Object? storedUserCards = freezed,
    Object? sandBox = freezed,
    Object? selectedCardToken = freezed,
    Object? installmentQueryUrl = freezed,
    Object? iyzicoBrandImageUrl = freezed,
    Object? creditCardBrandUrl = freezed,
    Object? userFields = freezed,
  }) {
    return _then(
      _$IyzicoPaymentInfoModelImpl(
        creditCardFormData:
            freezed == creditCardFormData
                ? _value._creditCardFormData
                : creditCardFormData // ignore: cast_nullable_to_non_nullable
                    as Map<String, FieldDefinition>?,
        storedUserCards:
            freezed == storedUserCards
                ? _value._storedUserCards
                : storedUserCards // ignore: cast_nullable_to_non_nullable
                    as List<Card>?,
        sandBox:
            freezed == sandBox
                ? _value.sandBox
                : sandBox // ignore: cast_nullable_to_non_nullable
                    as bool?,
        selectedCardToken:
            freezed == selectedCardToken
                ? _value.selectedCardToken
                : selectedCardToken // ignore: cast_nullable_to_non_nullable
                    as String?,
        installmentQueryUrl:
            freezed == installmentQueryUrl
                ? _value.installmentQueryUrl
                : installmentQueryUrl // ignore: cast_nullable_to_non_nullable
                    as String?,
        iyzicoBrandImageUrl:
            freezed == iyzicoBrandImageUrl
                ? _value.iyzicoBrandImageUrl
                : iyzicoBrandImageUrl // ignore: cast_nullable_to_non_nullable
                    as String?,
        creditCardBrandUrl:
            freezed == creditCardBrandUrl
                ? _value.creditCardBrandUrl
                : creditCardBrandUrl // ignore: cast_nullable_to_non_nullable
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
class _$IyzicoPaymentInfoModelImpl implements _IyzicoPaymentInfoModel {
  _$IyzicoPaymentInfoModelImpl({
    @JsonKey(name: 'CreditCardFormData', includeIfNull: false)
    final Map<String, FieldDefinition>? creditCardFormData = const {},
    @JsonKey(name: 'StoredUserCards', includeIfNull: false)
    final List<Card>? storedUserCards = const [],
    @JsonKey(name: 'SandBox', includeIfNull: false) this.sandBox = false,
    @JsonKey(name: 'SelectedCardToken', includeIfNull: false)
    this.selectedCardToken,
    @JsonKey(name: 'InstallmentQueryUrl', includeIfNull: false)
    this.installmentQueryUrl,
    @JsonKey(name: 'IyzicoBrandImageUrl', includeIfNull: false)
    this.iyzicoBrandImageUrl,
    @JsonKey(name: 'CreditCardBrandUrl', includeIfNull: false)
    this.creditCardBrandUrl,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields = const [],
  }) : _creditCardFormData = creditCardFormData,
       _storedUserCards = storedUserCards,
       _userFields = userFields;

  factory _$IyzicoPaymentInfoModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$IyzicoPaymentInfoModelImplFromJson(json);

  final Map<String, FieldDefinition>? _creditCardFormData;
  @override
  @JsonKey(name: 'CreditCardFormData', includeIfNull: false)
  Map<String, FieldDefinition>? get creditCardFormData {
    final value = _creditCardFormData;
    if (value == null) return null;
    if (_creditCardFormData is EqualUnmodifiableMapView)
      return _creditCardFormData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final List<Card>? _storedUserCards;
  @override
  @JsonKey(name: 'StoredUserCards', includeIfNull: false)
  List<Card>? get storedUserCards {
    final value = _storedUserCards;
    if (value == null) return null;
    if (_storedUserCards is EqualUnmodifiableListView) return _storedUserCards;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'SandBox', includeIfNull: false)
  final bool? sandBox;
  @override
  @JsonKey(name: 'SelectedCardToken', includeIfNull: false)
  final String? selectedCardToken;
  @override
  @JsonKey(name: 'InstallmentQueryUrl', includeIfNull: false)
  final String? installmentQueryUrl;
  @override
  @JsonKey(name: 'IyzicoBrandImageUrl', includeIfNull: false)
  final String? iyzicoBrandImageUrl;
  @override
  @JsonKey(name: 'CreditCardBrandUrl', includeIfNull: false)
  final String? creditCardBrandUrl;
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
    return 'IyzicoPaymentInfoModel(creditCardFormData: $creditCardFormData, storedUserCards: $storedUserCards, sandBox: $sandBox, selectedCardToken: $selectedCardToken, installmentQueryUrl: $installmentQueryUrl, iyzicoBrandImageUrl: $iyzicoBrandImageUrl, creditCardBrandUrl: $creditCardBrandUrl, userFields: $userFields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IyzicoPaymentInfoModelImpl &&
            const DeepCollectionEquality().equals(
              other._creditCardFormData,
              _creditCardFormData,
            ) &&
            const DeepCollectionEquality().equals(
              other._storedUserCards,
              _storedUserCards,
            ) &&
            (identical(other.sandBox, sandBox) || other.sandBox == sandBox) &&
            (identical(other.selectedCardToken, selectedCardToken) ||
                other.selectedCardToken == selectedCardToken) &&
            (identical(other.installmentQueryUrl, installmentQueryUrl) ||
                other.installmentQueryUrl == installmentQueryUrl) &&
            (identical(other.iyzicoBrandImageUrl, iyzicoBrandImageUrl) ||
                other.iyzicoBrandImageUrl == iyzicoBrandImageUrl) &&
            (identical(other.creditCardBrandUrl, creditCardBrandUrl) ||
                other.creditCardBrandUrl == creditCardBrandUrl) &&
            const DeepCollectionEquality().equals(
              other._userFields,
              _userFields,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_creditCardFormData),
    const DeepCollectionEquality().hash(_storedUserCards),
    sandBox,
    selectedCardToken,
    installmentQueryUrl,
    iyzicoBrandImageUrl,
    creditCardBrandUrl,
    const DeepCollectionEquality().hash(_userFields),
  );

  /// Create a copy of IyzicoPaymentInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IyzicoPaymentInfoModelImplCopyWith<_$IyzicoPaymentInfoModelImpl>
  get copyWith =>
      __$$IyzicoPaymentInfoModelImplCopyWithImpl<_$IyzicoPaymentInfoModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$IyzicoPaymentInfoModelImplToJson(this);
  }
}

abstract class _IyzicoPaymentInfoModel implements IyzicoPaymentInfoModel {
  factory _IyzicoPaymentInfoModel({
    @JsonKey(name: 'CreditCardFormData', includeIfNull: false)
    final Map<String, FieldDefinition>? creditCardFormData,
    @JsonKey(name: 'StoredUserCards', includeIfNull: false)
    final List<Card>? storedUserCards,
    @JsonKey(name: 'SandBox', includeIfNull: false) final bool? sandBox,
    @JsonKey(name: 'SelectedCardToken', includeIfNull: false)
    final String? selectedCardToken,
    @JsonKey(name: 'InstallmentQueryUrl', includeIfNull: false)
    final String? installmentQueryUrl,
    @JsonKey(name: 'IyzicoBrandImageUrl', includeIfNull: false)
    final String? iyzicoBrandImageUrl,
    @JsonKey(name: 'CreditCardBrandUrl', includeIfNull: false)
    final String? creditCardBrandUrl,
    @JsonKey(name: 'UserFields', includeIfNull: false)
    final List<UserField>? userFields,
  }) = _$IyzicoPaymentInfoModelImpl;

  factory _IyzicoPaymentInfoModel.fromJson(Map<String, dynamic> json) =
      _$IyzicoPaymentInfoModelImpl.fromJson;

  @override
  @JsonKey(name: 'CreditCardFormData', includeIfNull: false)
  Map<String, FieldDefinition>? get creditCardFormData;
  @override
  @JsonKey(name: 'StoredUserCards', includeIfNull: false)
  List<Card>? get storedUserCards;
  @override
  @JsonKey(name: 'SandBox', includeIfNull: false)
  bool? get sandBox;
  @override
  @JsonKey(name: 'SelectedCardToken', includeIfNull: false)
  String? get selectedCardToken;
  @override
  @JsonKey(name: 'InstallmentQueryUrl', includeIfNull: false)
  String? get installmentQueryUrl;
  @override
  @JsonKey(name: 'IyzicoBrandImageUrl', includeIfNull: false)
  String? get iyzicoBrandImageUrl;
  @override
  @JsonKey(name: 'CreditCardBrandUrl', includeIfNull: false)
  String? get creditCardBrandUrl;
  @override
  @JsonKey(name: 'UserFields', includeIfNull: false)
  List<UserField>? get userFields;

  /// Create a copy of IyzicoPaymentInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IyzicoPaymentInfoModelImplCopyWith<_$IyzicoPaymentInfoModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
