import 'package:flutter/services.dart';

class PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    String formatted = digits;

    if (digits.length >= 2) {
      formatted = '(${digits.substring(0, 2)})';
    }
    if (digits.length > 2) {
      formatted += ' ${digits.substring(2, digits.length > 7 ? 7 : digits.length)}';
    }
    if (digits.length > 7) {
      formatted += '-${digits.substring(7, digits.length > 11 ? 11 : digits.length)}';
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
