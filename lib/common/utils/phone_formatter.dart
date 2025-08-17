import 'package:flutter/services.dart';

class BrazilianPhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    if (digits.isEmpty) {
      return newValue.copyWith(text: '');
    }

    final limitedDigits = digits.length > 11 ? digits.substring(0, 11) : digits;

    String formattedText = '';

    if (limitedDigits.length <= 2) {
      formattedText = '(${limitedDigits}';
    } else if (limitedDigits.length <= 6) {
      formattedText =
          '(${limitedDigits.substring(0, 2)}) ${limitedDigits.substring(2)}';
    } else if (limitedDigits.length <= 10) {
      formattedText =
          '(${limitedDigits.substring(0, 2)}) ${limitedDigits.substring(2, 6)}-${limitedDigits.substring(6)}';
    } else {
      formattedText =
          '(${limitedDigits.substring(0, 2)}) ${limitedDigits.substring(2, 7)}-${limitedDigits.substring(7)}';
    }

    return newValue.copyWith(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}

class BrazilianPhoneValidator {
  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Telefone é obrigatório';
    }

    final digits = value.replaceAll(RegExp(r'[^\d]'), '');

    if (digits.length < 10 || digits.length > 11) {
      return 'Telefone deve ter 10 ou 11 dígitos';
    }

    final ddd = int.tryParse(digits.substring(0, 2));
    if (ddd == null || ddd < 11 || ddd > 99) {
      return 'DDD inválido';
    }

    if (digits.length == 11) {
      if (digits[2] != '9') {
        return 'Celular deve começar com 9 após o DDD';
      }
    } else if (digits.length == 10) {
      if (digits[2] == '9') {
        return 'Telefone fixo não deve começar com 9';
      }
    }

    return null;
  }

  static String format(String phone) {
    final digits = phone.replaceAll(RegExp(r'[^\d]'), '');

    if (digits.length == 10) {
      return '(${digits.substring(0, 2)}) ${digits.substring(2, 6)}-${digits.substring(6)}';
    } else if (digits.length == 11) {
      return '(${digits.substring(0, 2)}) ${digits.substring(2, 7)}-${digits.substring(7)}';
    }

    return phone;
  }

  static String getDigits(String phone) {
    return phone.replaceAll(RegExp(r'[^\d]'), '');
  }
}
