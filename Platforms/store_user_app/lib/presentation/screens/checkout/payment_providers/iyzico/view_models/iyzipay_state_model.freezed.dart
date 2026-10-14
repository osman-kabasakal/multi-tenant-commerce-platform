// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'iyzipay_state_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$IyzipayStateModel {
  IyzicoPaymentInfoModel? get paymentInfo =>
      throw _privateConstructorUsedError; // Seçili kart bilgisi
  String? get selectedCardToken =>
      throw _privateConstructorUsedError; // Kart taksit detayları
  InstallmentDetail? get installmentDetail =>
      throw _privateConstructorUsedError; // Seçili taksit bilgisi
  InstallmentPrice? get installmentPrice =>
      throw _privateConstructorUsedError; // 3D Secure seçeneği
  bool get useSecure3D =>
      throw _privateConstructorUsedError; // Yeni kart form verileri
  Map<String, dynamic>? get newCardData =>
      throw _privateConstructorUsedError; // Yükleme durumu
  bool get isLoading => throw _privateConstructorUsedError; // Hata mesajı
  String? get error => throw _privateConstructorUsedError;

  /// Create a copy of IyzipayStateModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IyzipayStateModelCopyWith<IyzipayStateModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IyzipayStateModelCopyWith<$Res> {
  factory $IyzipayStateModelCopyWith(
    IyzipayStateModel value,
    $Res Function(IyzipayStateModel) then,
  ) = _$IyzipayStateModelCopyWithImpl<$Res, IyzipayStateModel>;
  @useResult
  $Res call({
    IyzicoPaymentInfoModel? paymentInfo,
    String? selectedCardToken,
    InstallmentDetail? installmentDetail,
    InstallmentPrice? installmentPrice,
    bool useSecure3D,
    Map<String, dynamic>? newCardData,
    bool isLoading,
    String? error,
  });

  $IyzicoPaymentInfoModelCopyWith<$Res>? get paymentInfo;
}

/// @nodoc
class _$IyzipayStateModelCopyWithImpl<$Res, $Val extends IyzipayStateModel>
    implements $IyzipayStateModelCopyWith<$Res> {
  _$IyzipayStateModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IyzipayStateModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? paymentInfo = freezed,
    Object? selectedCardToken = freezed,
    Object? installmentDetail = freezed,
    Object? installmentPrice = freezed,
    Object? useSecure3D = null,
    Object? newCardData = freezed,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(
      _value.copyWith(
            paymentInfo:
                freezed == paymentInfo
                    ? _value.paymentInfo
                    : paymentInfo // ignore: cast_nullable_to_non_nullable
                        as IyzicoPaymentInfoModel?,
            selectedCardToken:
                freezed == selectedCardToken
                    ? _value.selectedCardToken
                    : selectedCardToken // ignore: cast_nullable_to_non_nullable
                        as String?,
            installmentDetail:
                freezed == installmentDetail
                    ? _value.installmentDetail
                    : installmentDetail // ignore: cast_nullable_to_non_nullable
                        as InstallmentDetail?,
            installmentPrice:
                freezed == installmentPrice
                    ? _value.installmentPrice
                    : installmentPrice // ignore: cast_nullable_to_non_nullable
                        as InstallmentPrice?,
            useSecure3D:
                null == useSecure3D
                    ? _value.useSecure3D
                    : useSecure3D // ignore: cast_nullable_to_non_nullable
                        as bool,
            newCardData:
                freezed == newCardData
                    ? _value.newCardData
                    : newCardData // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>?,
            isLoading:
                null == isLoading
                    ? _value.isLoading
                    : isLoading // ignore: cast_nullable_to_non_nullable
                        as bool,
            error:
                freezed == error
                    ? _value.error
                    : error // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of IyzipayStateModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $IyzicoPaymentInfoModelCopyWith<$Res>? get paymentInfo {
    if (_value.paymentInfo == null) {
      return null;
    }

    return $IyzicoPaymentInfoModelCopyWith<$Res>(_value.paymentInfo!, (value) {
      return _then(_value.copyWith(paymentInfo: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$IyzipayClaudeStateModelImplCopyWith<$Res>
    implements $IyzipayStateModelCopyWith<$Res> {
  factory _$$IyzipayClaudeStateModelImplCopyWith(
    _$IyzipayClaudeStateModelImpl value,
    $Res Function(_$IyzipayClaudeStateModelImpl) then,
  ) = __$$IyzipayClaudeStateModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    IyzicoPaymentInfoModel? paymentInfo,
    String? selectedCardToken,
    InstallmentDetail? installmentDetail,
    InstallmentPrice? installmentPrice,
    bool useSecure3D,
    Map<String, dynamic>? newCardData,
    bool isLoading,
    String? error,
  });

  @override
  $IyzicoPaymentInfoModelCopyWith<$Res>? get paymentInfo;
}

/// @nodoc
class __$$IyzipayClaudeStateModelImplCopyWithImpl<$Res>
    extends _$IyzipayStateModelCopyWithImpl<$Res, _$IyzipayClaudeStateModelImpl>
    implements _$$IyzipayClaudeStateModelImplCopyWith<$Res> {
  __$$IyzipayClaudeStateModelImplCopyWithImpl(
    _$IyzipayClaudeStateModelImpl _value,
    $Res Function(_$IyzipayClaudeStateModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of IyzipayStateModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? paymentInfo = freezed,
    Object? selectedCardToken = freezed,
    Object? installmentDetail = freezed,
    Object? installmentPrice = freezed,
    Object? useSecure3D = null,
    Object? newCardData = freezed,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(
      _$IyzipayClaudeStateModelImpl(
        paymentInfo:
            freezed == paymentInfo
                ? _value.paymentInfo
                : paymentInfo // ignore: cast_nullable_to_non_nullable
                    as IyzicoPaymentInfoModel?,
        selectedCardToken:
            freezed == selectedCardToken
                ? _value.selectedCardToken
                : selectedCardToken // ignore: cast_nullable_to_non_nullable
                    as String?,
        installmentDetail:
            freezed == installmentDetail
                ? _value.installmentDetail
                : installmentDetail // ignore: cast_nullable_to_non_nullable
                    as InstallmentDetail?,
        installmentPrice:
            freezed == installmentPrice
                ? _value.installmentPrice
                : installmentPrice // ignore: cast_nullable_to_non_nullable
                    as InstallmentPrice?,
        useSecure3D:
            null == useSecure3D
                ? _value.useSecure3D
                : useSecure3D // ignore: cast_nullable_to_non_nullable
                    as bool,
        newCardData:
            freezed == newCardData
                ? _value._newCardData
                : newCardData // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>?,
        isLoading:
            null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                    as bool,
        error:
            freezed == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc

class _$IyzipayClaudeStateModelImpl implements _IyzipayClaudeStateModel {
  const _$IyzipayClaudeStateModelImpl({
    this.paymentInfo,
    this.selectedCardToken,
    this.installmentDetail,
    this.installmentPrice,
    this.useSecure3D = false,
    final Map<String, dynamic>? newCardData,
    this.isLoading = false,
    this.error,
  }) : _newCardData = newCardData;

  @override
  final IyzicoPaymentInfoModel? paymentInfo;
  // Seçili kart bilgisi
  @override
  final String? selectedCardToken;
  // Kart taksit detayları
  @override
  final InstallmentDetail? installmentDetail;
  // Seçili taksit bilgisi
  @override
  final InstallmentPrice? installmentPrice;
  // 3D Secure seçeneği
  @override
  @JsonKey()
  final bool useSecure3D;
  // Yeni kart form verileri
  final Map<String, dynamic>? _newCardData;
  // Yeni kart form verileri
  @override
  Map<String, dynamic>? get newCardData {
    final value = _newCardData;
    if (value == null) return null;
    if (_newCardData is EqualUnmodifiableMapView) return _newCardData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  // Yükleme durumu
  @override
  @JsonKey()
  final bool isLoading;
  // Hata mesajı
  @override
  final String? error;

  @override
  String toString() {
    return 'IyzipayStateModel(paymentInfo: $paymentInfo, selectedCardToken: $selectedCardToken, installmentDetail: $installmentDetail, installmentPrice: $installmentPrice, useSecure3D: $useSecure3D, newCardData: $newCardData, isLoading: $isLoading, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IyzipayClaudeStateModelImpl &&
            (identical(other.paymentInfo, paymentInfo) ||
                other.paymentInfo == paymentInfo) &&
            (identical(other.selectedCardToken, selectedCardToken) ||
                other.selectedCardToken == selectedCardToken) &&
            (identical(other.installmentDetail, installmentDetail) ||
                other.installmentDetail == installmentDetail) &&
            (identical(other.installmentPrice, installmentPrice) ||
                other.installmentPrice == installmentPrice) &&
            (identical(other.useSecure3D, useSecure3D) ||
                other.useSecure3D == useSecure3D) &&
            const DeepCollectionEquality().equals(
              other._newCardData,
              _newCardData,
            ) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    paymentInfo,
    selectedCardToken,
    installmentDetail,
    installmentPrice,
    useSecure3D,
    const DeepCollectionEquality().hash(_newCardData),
    isLoading,
    error,
  );

  /// Create a copy of IyzipayStateModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IyzipayClaudeStateModelImplCopyWith<_$IyzipayClaudeStateModelImpl>
  get copyWith => __$$IyzipayClaudeStateModelImplCopyWithImpl<
    _$IyzipayClaudeStateModelImpl
  >(this, _$identity);
}

abstract class _IyzipayClaudeStateModel implements IyzipayStateModel {
  const factory _IyzipayClaudeStateModel({
    final IyzicoPaymentInfoModel? paymentInfo,
    final String? selectedCardToken,
    final InstallmentDetail? installmentDetail,
    final InstallmentPrice? installmentPrice,
    final bool useSecure3D,
    final Map<String, dynamic>? newCardData,
    final bool isLoading,
    final String? error,
  }) = _$IyzipayClaudeStateModelImpl;

  @override
  IyzicoPaymentInfoModel? get paymentInfo; // Seçili kart bilgisi
  @override
  String? get selectedCardToken; // Kart taksit detayları
  @override
  InstallmentDetail? get installmentDetail; // Seçili taksit bilgisi
  @override
  InstallmentPrice? get installmentPrice; // 3D Secure seçeneği
  @override
  bool get useSecure3D; // Yeni kart form verileri
  @override
  Map<String, dynamic>? get newCardData; // Yükleme durumu
  @override
  bool get isLoading; // Hata mesajı
  @override
  String? get error;

  /// Create a copy of IyzipayStateModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IyzipayClaudeStateModelImplCopyWith<_$IyzipayClaudeStateModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
