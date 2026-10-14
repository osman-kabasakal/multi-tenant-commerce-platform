import 'package:nb_utils/nb_utils.dart';

extension StringExtensions on String? {
  String? validateText(String message) {
    if (this == null || this!.isEmpty) {
      return message;
    }
    return null;
  }

  /// Para birimi formatındaki metni double tipine dönüştürür
  ///
  /// [currencySymbol]: Kaldırılacak para birimi sembolü (örn: '₺', '$', '€')
  /// [decimalSeparator]: Ondalık ayırıcı (örn: ',', '.')
  /// [thousandSeparator]: Binlik ayırıcı (örn: '.', ',', ' ')
  double? toDoubleFromCurrency({
    String currencySymbol = '₺',
    String decimalSeparator = ',',
    String thousandSeparator = '.',
  }) {
    if (isEmptyOrNull) {
      return null;
    }

    try {
      // Para birimi sembolünü kaldır
      String cleanText = this!.replaceAll(currencySymbol, '').trim();

      // Binlik ayırıcıları kaldır
      cleanText = cleanText.replaceAll(thousandSeparator, '');

      // Ondalık ayırıcıyı nokta ile değiştir (standart double formatı için)
      if (decimalSeparator != '.') {
        cleanText = cleanText.replaceAll(decimalSeparator, '.');
      }

      // Diğer olası karakterleri kaldır
      cleanText = cleanText.replaceAll(RegExp(r'[^\d.]'), '');

      // Double'a dönüştür
      return double.parse(cleanText);
    } catch (e) {
      // Hata durumunda null dön
      return null;
    }
  }
}
