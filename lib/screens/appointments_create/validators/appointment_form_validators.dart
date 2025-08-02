import 'package:neuro_plus/screens/appointments_create/models/appointment_form_data.dart';

class AppointmentFormValidators {
  static String? validateStep(int step, AppointmentFormData formData) {
    switch (step) {
      case 0:
        return _validatePatientStep(formData);
      case 1:
        return _validateDateTimeStep(formData);
      case 2:
        return _validateDetailsStep(formData);
      default:
        return null;
    }
  }

  static String? _validatePatientStep(AppointmentFormData formData) {
    if (formData.selectedPatient == null) {
      return 'Selecione um paciente';
    }
    return null;
  }

  static String? _validateDateTimeStep(AppointmentFormData formData) {
    if (formData.selectedDate == null) {
      return 'Selecione uma data';
    }
    if (formData.selectedTime == null) {
      return 'Selecione um horário';
    }
    return null;
  }

  static String? _validateDetailsStep(AppointmentFormData formData) {
    // Validações opcionais para step de detalhes
    return null;
  }
}
