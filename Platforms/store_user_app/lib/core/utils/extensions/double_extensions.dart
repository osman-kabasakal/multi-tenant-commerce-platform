import 'package:intl/intl.dart';

extension DoubleExtensions on double {
  String toCurrencyString() {
    return NumberFormat.currency(
            locale: 'tr_TR', name: '', decimalDigits: 2, symbol: '')
        .format(this);
  }
}
