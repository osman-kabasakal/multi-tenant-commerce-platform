import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:store_user_app/domain/entities/models/iyzico_payment_info_model/iyzico_payment_info_model.dart';

import 'installmentDetail.dart';
import 'installmentPrice.dart';

part 'iyzipay_state_model.freezed.dart';

@freezed
class IyzipayStateModel with _$IyzipayStateModel {
  const factory IyzipayStateModel({
    IyzicoPaymentInfoModel? paymentInfo,
    // Seçili kart bilgisi
    String? selectedCardToken,
    // Kart taksit detayları
    InstallmentDetail? installmentDetail,
    // Seçili taksit bilgisi
    InstallmentPrice? installmentPrice,
    // 3D Secure seçeneği
    @Default(false) bool useSecure3D,
    // Yeni kart form verileri
    Map<String, dynamic>? newCardData,
    // Yükleme durumu
    @Default(false) bool isLoading,
    // Hata mesajı
    String? error,
  }) = _IyzipayClaudeStateModel;
}
