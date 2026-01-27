import 'package:flutter/services.dart';

class CepInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    String formatted = digits;

    if (digits.length > 5) {
      formatted = '${digits.substring(0, 5)}-${digits.substring(5, digits.length > 8 ? 8 : digits.length)}';
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
