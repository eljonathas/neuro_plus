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
      formattedText = '($limitedDigits)';
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

    final original = value.trim();
    final digits = original.replaceAll(RegExp(r'[^\d]'), '');

    // Verificar se há caracteres inválidos (que não sejam dígitos, espaços, parentêses, hífens)
    final allowedChars = RegExp(r'^[\d\s\(\)\-]+$');
    if (!allowedChars.hasMatch(original)) {
      final invalidChars = original.replaceAll(RegExp(r'[\d\s\(\)\-]'), '');
      final uniqueInvalid = invalidChars.split('').toSet().join('');
      return 'Telefone contém caractere(s) inválido(s): "$uniqueInvalid"';
    }

    if (digits.isEmpty) {
      return 'Telefone deve conter pelo menos um número';
    }

    if (digits.length < 10) {
      final missing = 10 - digits.length;
      return 'Telefone muito curto. Faltam $missing dígito(s)';
    }

    if (digits.length > 11) {
      final extra = digits.length - 11;
      return 'Telefone muito longo. Remova $extra dígito(s)';
    }

    final ddd = digits.substring(0, 2);
    final dddNumber = int.tryParse(ddd);

    if (dddNumber == null || dddNumber < 11 || dddNumber > 99) {
      return 'DDD "$ddd" é inválido. Use DDD entre 11 e 99';
    }

    if (digits.length == 11) {
      if (digits[2] != '9') {
        final thirdDigit = digits[2];
        return 'Celular deve começar com "9" após o DDD, mas encontrou "$thirdDigit"';
      }
    } else if (digits.length == 10) {
      if (digits[2] == '9') {
        return 'Telefone fixo não deve começar com "9" após o DDD';
      }
      // Verificar se o primeiro dígito do telefone fixo é válido (2-5)
      final firstPhoneDigit = int.tryParse(digits[2]);
      if (firstPhoneDigit == null ||
          firstPhoneDigit < 2 ||
          firstPhoneDigit > 5) {
        return 'Telefone fixo deve começar com dígito entre 2 e 5 após o DDD';
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
