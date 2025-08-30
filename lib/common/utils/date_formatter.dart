import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// Formatador automático para datas brasileiras (dd/MM/yyyy)
/// Insere barras automaticamente conforme o usuário digita
class BrazilianDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remove tudo que não é dígito
    final digits = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    if (digits.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Limita a 8 dígitos (ddMMyyyy)
    final limitedDigits = digits.length > 8 ? digits.substring(0, 8) : digits;

    String formattedText = '';

    if (limitedDigits.length <= 2) {
      // Apenas o dia: "01" -> "01"
      formattedText = limitedDigits;
    } else if (limitedDigits.length <= 4) {
      // Dia + mês: "0101" -> "01/01"
      formattedText =
          '${limitedDigits.substring(0, 2)}/${limitedDigits.substring(2)}';
    } else {
      // Dia + mês + ano: "01012023" -> "01/01/2023"
      formattedText =
          '${limitedDigits.substring(0, 2)}/${limitedDigits.substring(2, 4)}/${limitedDigits.substring(4)}';
    }

    return newValue.copyWith(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}

/// Validador para datas brasileiras com mensagens detalhadas
class BrazilianDateValidator {
  /// Valida se a data está no formato correto e é uma data válida
  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Data é obrigatória';
    }

    final trimmed = value.trim();

    // Verificar formato básico dd/MM/yyyy
    final dateRegex = RegExp(r'^\d{2}/\d{2}/\d{4}$');
    if (!dateRegex.hasMatch(trimmed)) {
      return 'Data deve estar no formato DD/MM/AAAA';
    }

    final parts = trimmed.split('/');
    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);

    if (day == null || month == null || year == null) {
      return 'Data contém valores inválidos';
    }

    // Validações básicas
    if (day < 1 || day > 31) {
      return 'Dia deve estar entre 01 e 31';
    }

    if (month < 1 || month > 12) {
      return 'Mês deve estar entre 01 e 12';
    }

    if (year < 1900) {
      return 'Ano deve ser maior que 1900';
    }

    if (year > DateTime.now().year) {
      return 'Ano não pode ser maior que ${DateTime.now().year}';
    }

    // Tentar criar a data para validar se ela existe
    try {
      final date = DateTime(year, month, day);

      // Verificar se os valores são realmente os mesmos (ex: 30/02 se tornaria 02/03)
      if (date.day != day || date.month != month || date.year != year) {
        return 'Data não existe no calendário';
      }

      // Verificar se não é uma data futura
      if (date.isAfter(DateTime.now())) {
        return 'Data de nascimento não pode ser no futuro';
      }

      // Verificar idade mínima (pessoa muito antiga)
      final age = DateTime.now().difference(date).inDays ~/ 365;
      if (age > 120) {
        return 'Idade não pode ser maior que 120 anos';
      }
    } catch (e) {
      return 'Data inválida';
    }

    return null;
  }

  /// Converte string formatada para DateTime
  static DateTime? parseDate(String? value) {
    if (value == null || value.isEmpty) return null;

    try {
      final parts = value.split('/');
      if (parts.length != 3) return null;

      final day = int.tryParse(parts[0]);
      final month = int.tryParse(parts[1]);
      final year = int.tryParse(parts[2]);

      if (day == null || month == null || year == null) return null;

      return DateTime(year, month, day);
    } catch (e) {
      return null;
    }
  }

  /// Formata DateTime para string brasileira
  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  /// Obtém apenas os dígitos da data
  static String getDigits(String date) {
    return date.replaceAll(RegExp(r'[^\d]'), '');
  }
}
