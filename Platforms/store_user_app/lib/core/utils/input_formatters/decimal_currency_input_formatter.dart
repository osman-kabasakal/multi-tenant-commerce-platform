import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

class DecimalCurrencyInputFormatter extends TextInputFormatter {
  final String currencySymbol;
  final String decimalSeparator;
  final String thousandSeparator;

  late NumberFormat _currencyFormatter;

  DecimalCurrencyInputFormatter({
    this.currencySymbol = '',
    this.decimalSeparator = '.',
    this.thousandSeparator = ',',
  }) : _currencyFormatter = NumberFormat.currency(
          locale: 'tr_TR',
          name: '',
          symbol: currencySymbol,
          decimalDigits: 2,
        );

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmptyOrNull) {
      return newValue;
    }

    // Decimal işareti kontrolü (tek bir decimal işaretine izin ver)
    List<String> parts = newValue.text.split(RegExp(r'[,]'));
    if (parts.length > 2) {
      return oldValue;
    }

    // Değeri işle
    String integerPart =
        parts.length > 1 ? parts[0].replaceAll(RegExp(r'[^\d]'), '') : '0';
    String fractionalPart = parts.length > 1
        ? parts[1].replaceAll(RegExp(r'[^\d]'), '')
        : parts[0].padLeft(2, '0');
    if (fractionalPart.length >= 2) {
      integerPart += fractionalPart.substring(0, fractionalPart.length - 2);
      fractionalPart = fractionalPart.substring(fractionalPart.length - 2);
    } else {
      fractionalPart = (integerPart.isNotEmpty
              ? integerPart.substring(integerPart.length - 1)
              : '0') +
          fractionalPart;
      integerPart = integerPart.length > 1
          ? integerPart.substring(0, integerPart.length - 1)
          : '0';
    }

    var formattedText =
        _currencyFormatter.format(double.parse('$integerPart.$fractionalPart'));
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
