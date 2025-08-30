import 'package:neuro_plus/common/utils/phone_formatter.dart';

class PatientFormValidators {
  static String? requiredValidator(String? value) {
    return (value?.isEmpty ?? true) ? 'Este campo é obrigatório' : null;
  }

  static String? emailValidator(String? value) {
    if (value?.isEmpty ?? true) return null;

    final email = value!.trim();

    // Verificar se contém @
    if (!email.contains('@')) {
      return 'E-mail deve conter o símbolo "@"';
    }

    final parts = email.split('@');
    if (parts.length != 2) {
      return 'E-mail deve conter apenas um símbolo "@"';
    }

    final localPart = parts[0];
    final domainPart = parts[1];

    // Verificar parte local (antes do @)
    if (localPart.isEmpty) {
      return 'E-mail deve ter texto antes do "@"';
    }

    if (localPart.length > 64) {
      return 'Parte antes do "@" não pode ter mais que 64 caracteres';
    }

    // Verificar caracteres inválidos na parte local
    final invalidLocalChars = RegExp(r'[^a-zA-Z0-9._%+-]');
    final invalidLocalMatch = invalidLocalChars.firstMatch(localPart);
    if (invalidLocalMatch != null) {
      final invalidChar = localPart[invalidLocalMatch.start];
      return 'E-mail contém caractere inválido: "$invalidChar"';
    }

    // Verificar se começa ou termina com ponto
    if (localPart.startsWith('.') || localPart.endsWith('.')) {
      return 'E-mail não pode começar ou terminar com ponto';
    }

    // Verificar pontos consecutivos
    if (localPart.contains('..')) {
      return 'E-mail não pode ter pontos consecutivos';
    }

    // Verificar parte do domínio (depois do @)
    if (domainPart.isEmpty) {
      return 'E-mail deve ter domínio após o "@"';
    }

    if (domainPart.length > 253) {
      return 'Domínio não pode ter mais que 253 caracteres';
    }

    // Verificar se o domínio contém pelo menos um ponto
    if (!domainPart.contains('.')) {
      return 'Domínio deve conter pelo menos um ponto (ex: .com)';
    }

    // Verificar caracteres inválidos no domínio
    final invalidDomainChars = RegExp(r'[^a-zA-Z0-9.-]');
    final invalidDomainMatch = invalidDomainChars.firstMatch(domainPart);
    if (invalidDomainMatch != null) {
      final invalidChar = domainPart[invalidDomainMatch.start];
      return 'Domínio contém caractere inválido: "$invalidChar"';
    }

    // Verificar se o domínio termina adequadamente
    final domainParts = domainPart.split('.');
    if (domainParts.last.length < 2 || domainParts.last.length > 6) {
      return 'Extensão do domínio deve ter entre 2 e 6 caracteres';
    }

    // Verificar se há apenas letras na extensão
    final extensionRegex = RegExp(r'^[a-zA-Z]+$');
    if (!extensionRegex.hasMatch(domainParts.last)) {
      return 'Extensão do domínio deve conter apenas letras';
    }

    return null;
  }

  static String? phoneValidator(String? value) {
    return BrazilianPhoneValidator.validate(value);
  }

  static String? optionalPhoneValidator(String? value) {
    if (value?.isEmpty ?? true) return null;
    return BrazilianPhoneValidator.validate(value);
  }

  static String? numericValidator(String? value) {
    if (value?.isEmpty ?? true) return null;

    final input = value!.trim();

    // Verificar se contém apenas dígitos
    final nonDigitRegex = RegExp(r'[^0-9]');
    final invalidMatch = nonDigitRegex.firstMatch(input);

    if (invalidMatch != null) {
      final invalidChar = input[invalidMatch.start];
      if (invalidChar == ' ') {
        return 'Números não podem conter espaços';
      } else if (invalidChar == '.' || invalidChar == ',') {
        return 'Digite apenas números inteiros (sem vírgulas ou pontos)';
      } else {
        return 'Caractere inválido: "$invalidChar". Digite apenas números';
      }
    }

    return null;
  }

  static String? ageValidator(String? value) {
    if (value?.isEmpty ?? true) return null;

    final input = value!.trim();
    final age = int.tryParse(input);

    if (age == null) {
      // Verificar caracteres específicos
      final nonDigitRegex = RegExp(r'[^0-9]');
      final invalidMatch = nonDigitRegex.firstMatch(input);

      if (invalidMatch != null) {
        final invalidChar = input[invalidMatch.start];
        if (invalidChar == '.' || invalidChar == ',') {
          return 'Idade deve ser um número inteiro (sem vírgulas ou pontos)';
        } else if (invalidChar == ' ') {
          return 'Idade não pode conter espaços';
        } else {
          return 'Caractere inválido na idade: "$invalidChar"';
        }
      }
      return 'Digite uma idade válida';
    }

    if (age < 0) {
      return 'Idade não pode ser negativa';
    }

    if (age > 120) {
      return 'Idade não pode ser maior que 120 anos';
    }

    return null;
  }

  static String? cepValidator(String? value) {
    if (value?.isEmpty ?? true) return null;

    final input = value!.trim();
    final digits = input.replaceAll(RegExp(r'[^\d]'), '');

    // Verificar caracteres inválidos
    final allowedChars = RegExp(r'^[\d\-\s]+$');
    if (!allowedChars.hasMatch(input)) {
      final invalidChars = input.replaceAll(RegExp(r'[\d\-\s]'), '');
      final uniqueInvalid = invalidChars.split('').toSet().join('');
      return 'CEP contém caractere(s) inválido(s): "$uniqueInvalid"';
    }

    if (digits.length != 8) {
      if (digits.length < 8) {
        final missing = 8 - digits.length;
        return 'CEP incompleto. Faltam $missing dígito(s)';
      } else {
        final extra = digits.length - 8;
        return 'CEP muito longo. Remova $extra dígito(s)';
      }
    }

    // Verificar se não é um CEP inválido comum (todos os dígitos iguais)
    if (digits.split('').toSet().length == 1) {
      return 'CEP inválido: não pode ter todos os dígitos iguais';
    }

    return null;
  }

  static String? urlValidator(String? value) {
    if (value?.isEmpty ?? true) return null;

    final url = value!.trim();

    if (!url.contains('.')) {
      return 'URL deve conter pelo menos um ponto';
    }

    if (url.contains(' ')) {
      return 'URL não pode conter espaços';
    }

    // Verificar caracteres inválidos comuns
    final invalidChars = RegExp(r'[\u00c0-\u017f]'); // Acentos
    final invalidMatch = invalidChars.firstMatch(url);
    if (invalidMatch != null) {
      final invalidChar = url[invalidMatch.start];
      return 'URL contém caractere inválido: "$invalidChar". Use apenas caracteres sem acentos';
    }

    // Verificar protocolo se presente
    if (url.contains('://')) {
      if (!url.startsWith('http://') && !url.startsWith('https://')) {
        final protocol = url.split('://')[0];
        return 'Protocolo "$protocol" inválido. Use "http" ou "https"';
      }
    }

    return null;
  }

  static String? nameValidator(String? value) {
    if (value?.isEmpty ?? true) return null;

    final name = value!.trim();

    // Verificar se contém apenas letras, espaços e acentos
    final validChars = RegExp(r'^[a-zA-Z\u00c0-\u017f\s]+$');
    if (!validChars.hasMatch(name)) {
      final invalidChars = name.replaceAll(
        RegExp(r'[a-zA-Z\u00c0-\u017f\s]'),
        '',
      );
      final uniqueInvalid = invalidChars.split('').toSet().join('');
      return 'Nome contém caractere(s) inválido(s): "$uniqueInvalid". Use apenas letras';
    }

    // Verificar se tem pelo menos duas partes (nome e sobrenome)
    final parts =
        name.split(RegExp(r'\s+')).where((part) => part.isNotEmpty).toList();
    if (parts.length < 2) {
      return 'Digite nome e sobrenome';
    }

    // Verificar se cada parte tem pelo menos 2 caracteres
    for (final part in parts) {
      if (part.length < 2) {
        return 'Cada parte do nome deve ter pelo menos 2 caracteres: "$part" é muito curto';
      }
    }

    return null;
  }
}
