import 'package:neuro_plus/common/utils/phone_formatter.dart';

class PatientFormValidators {
  static String? requiredValidator(String? value) {
    return (value?.isEmpty ?? true) ? 'Este campo é obrigatório' : null;
  }

  static String? emailValidator(String? value) {
    if (value?.isEmpty ?? true) return null;
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(value!) ? null : 'E-mail inválido';
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
    if (int.tryParse(value!) == null) {
      return 'Digite apenas números';
    }
    return null;
  }

  static String? ageValidator(String? value) {
    if (value?.isEmpty ?? true) return null;
    final age = int.tryParse(value!);
    if (age == null) return 'Digite uma idade válida';
    if (age < 0 || age > 100) return 'Digite uma idade entre 0 e 100 anos';
    return null;
  }
}
