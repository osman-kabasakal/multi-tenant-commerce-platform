import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/domain/entities/models/iyzico_payment_info_model/iyzico_payment_info_model.dart';
import 'package:store_user_app/domain/repositories/shopping_cart/shopping_cart_repository.dart';
import 'package:store_user_app/presentation/screens/checkout/payment_providers/iyzico/view_models/iyzipay_state_model.dart';

import '../../../view_models/payment_info_step_model.dart';
import '../view_models/installmentDetail.dart';
import '../view_models/installmentPrice.dart';

part 'iyzipay_controller.g.dart';

@riverpod
class IyzipayController extends _$IyzipayController {
  late final Dio _dio;

  @override
  FutureOr<IyzipayStateModel> build(
      PaymentInfoStepModel paymentInfoModel) async {
    _dio = await getIt.getAsync<Dio>();

    final paymentInfo = await _getIyzicoPaymentInfo();
    var prepareStateModel = IyzipayStateModel(paymentInfo: paymentInfo);

    // Eğer seçili kart varsa taksit bilgilerini al
    if (paymentInfo.selectedCardToken != null) {
      final installmentDetail = await getInstallment(
          paymentInfo.installmentQueryUrl!,
          paymentInfo.storedUserCards!
              .firstWhere((s) => s.cardToken == paymentInfo.selectedCardToken)
              .binNumber!);

      return prepareStateModel.copyWith(
        paymentInfo: paymentInfo,
        selectedCardToken: paymentInfo.selectedCardToken,
        installmentDetail: installmentDetail,
        installmentPrice: installmentDetail?.installmentPrices?.firstOrNull,
      );
    }

    return prepareStateModel;
  }

  Future<IyzicoPaymentInfoModel> _getIyzicoPaymentInfo() async {
    try {
      var response = await _dio.get(paymentInfoModel.paymentUrl!);
      return IyzicoPaymentInfoModel.fromJson(response.data);
    } catch (e) {
      return IyzicoPaymentInfoModel();
    }
  }

  Future<InstallmentDetail?> getInstallmentDetailByCardToken(
      String cardToken) async {
    if (state.isLoading) return null;

    final card = state.requireValue.paymentInfo!.storedUserCards!
        .firstWhere((c) => c.cardToken == cardToken);

    if (card.binNumber == null) return null;

    return await getInstallmentDetailByBinNumber(card.binNumber!);
  }

  // Bin numarasına göre taksit detaylarını getir
  Future<InstallmentDetail?> getInstallmentDetailByBinNumber(
      String binNumber) async {
    try {
      if (state.isLoading) return null;
      InstallmentDetail? detail = await getInstallment(
          state.requireValue.paymentInfo!.installmentQueryUrl!, binNumber);
      state = AsyncValue.data(state.requireValue.copyWith(
        installmentDetail: detail,
        installmentPrice: detail?.installmentPrices?.firstOrNull,
      ));
      return detail;
    } catch (e) {
      state = AsyncValue.data(state.requireValue.copyWith(
        installmentDetail: null,
        installmentPrice: null,
      ));
    }
    return null;
  }

  Future<InstallmentDetail?> getInstallment(
      String installmentQueryUrl, String binNumber) async {
    final shoppingCartRepository =
        await getIt.getAsync<ShoppingCartRepository>();
    final cartTotal = await shoppingCartRepository.getShoppingCartCartTotal();

    final response = await _dio.get(
      installmentQueryUrl,
      queryParameters: {
        'bin': binNumber,
        'price': cartTotal!.data!.orderTotalValue,
      },
    );

    final installments = (response.data as List)
        .map((e) => InstallmentDetail.fromJson(e))
        .toList();

    final detail = installments.firstOrNull;
    return detail;
  }

  // Kart seçimi güncelleme
  Future<void> updateSelectedCard(String cardToken) async {
    state = AsyncValue.data(state.requireValue.copyWith(
      selectedCardToken: cardToken,
      newCardData: null,
    ));

    await getInstallmentDetailByCardToken(cardToken);
  }

  // Yeni kart verilerini güncelleme
  void updateNewCardData(Map<String, dynamic> formData) {
    state = AsyncValue.data(state.requireValue.copyWith(
      newCardData: formData,
      selectedCardToken: null,
    ));

    getInstallmentDetailByBinNumber(
        formData['cardNumber'].toString().substring(0, 6));
  }

  // Taksit seçeneğini güncelleme
  void updateInstallmentPrice(InstallmentPrice price) {
    state = AsyncValue.data(state.requireValue.copyWith(
      installmentPrice: price,
    ));
  }

  // 3D Secure seçeneğini güncelleme
  void toggleSecure3D() {
    state = AsyncValue.data(state.requireValue.copyWith(
      useSecure3D: !state.requireValue.useSecure3D,
    ));
  }
}
