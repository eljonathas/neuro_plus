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
    if (value?.isEmpty ?? true) return 'Este campo é obrigatório';
    final phoneRegex = RegExp(r'^\+?[0-9\s\-()]{8,20}$');
    return phoneRegex.hasMatch(value!) ? null : 'Telefone inválido';
  }

  static String? optionalPhoneValidator(String? value) {
    if (value?.isEmpty ?? true) return null;
    final phoneRegex = RegExp(r'^\+?[0-9\s\-()]{8,20}$');
    return phoneRegex.hasMatch(value!) ? null : 'Telefone inválido';
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
