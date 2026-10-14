import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';

class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remove all non-digit characters
    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    // Define the parts of the phone number
    final countryCode = '+90';
    var areaCode = digitsOnly.length <= 2
        ? digitsOnly.isEmptyOrNull
            ? ''
            : digitsOnly.replaceFirst(
                '90'.substring(0, digitsOnly.length.clamp(1, 2)), '')
        : digitsOnly;
    var firstPart = '';
    var secondPart = '';
    var thirdPart = '';

    // Format the phone number based on the number of digits
    if (digitsOnly.length > 2) {
      areaCode = digitsOnly.substring(2, digitsOnly.length.clamp(2, 5));
      if (digitsOnly.length > 5) {
        firstPart = digitsOnly.substring(5, digitsOnly.length.clamp(5, 8));
        if (digitsOnly.length > 8) {
          secondPart = digitsOnly.substring(8, digitsOnly.length.clamp(8, 10));
          if (digitsOnly.length > 10) {
            thirdPart =
                digitsOnly.substring(10, digitsOnly.length.clamp(10, 12));
          }
        }
      }
    }

    // Build the formatted string
    final formattedNumber = StringBuffer();
    formattedNumber.write(countryCode);
    if (areaCode.isNotEmpty) {
      formattedNumber.write(' (');
      formattedNumber.write(areaCode);
    }
    if (firstPart.isNotEmpty) {
      formattedNumber.write(') ');
      formattedNumber.write(firstPart);
    }
    if (secondPart.isNotEmpty) {
      formattedNumber.write(' ');
      formattedNumber.write(secondPart);
    }
    if (thirdPart.isNotEmpty) {
      formattedNumber.write(' ');
      formattedNumber.write(thirdPart);
    }

    return TextEditingValue(
      text: formattedNumber.toString(),
      selection: TextSelection.collapsed(offset: formattedNumber.length),
    );
  }
}
