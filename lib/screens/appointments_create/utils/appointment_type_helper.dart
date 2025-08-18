import 'package:neuro_plus/models/appointment.dart';

class AppointmentTypeHelper {
  static String getTypeText(AppointmentType type) {
    switch (type) {
      case AppointmentType.evaluation:
        return 'Avaliação';
      case AppointmentType.revaluation:
        return 'Reavaliação';
      case AppointmentType.followUp:
        return 'Acompanhamento';
      case AppointmentType.consultation:
        return 'Consulta';
    }
  }
}
