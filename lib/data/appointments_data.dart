import 'package:neuro_plus/models/appointment.dart';

class AppointmentsData {
  static List<Appointment> getAppointments() {
    return [
      // Próximos agendamentos
      Appointment(
        date: DateTime(2025, 4, 22),
        time: '10:00 - 11:00 AM',
        title: 'Tooth Scaling',
        subtitle: 'Zendral Dental',
        appointmentId: 'RSV10102',
        isMultiple: true,
      ),
      Appointment(
        date: DateTime(2025, 4, 25),
        time: '14:00 - 15:00 PM',
        title: 'Behavior Assessment',
        subtitle: 'Neuro Center',
        appointmentId: 'RSV10108',
      ),
      Appointment(
        date: DateTime(2025, 4, 28),
        time: '09:30 - 10:30 AM',
        title: 'Terapia Ocupacional',
        subtitle: 'Neuro Center',
        appointmentId: 'RSV10115',
        isMultiple: true,
      ),
      
      // Agendamentos finalizados
      Appointment(
        date: DateTime(2025, 4, 20),
        time: '09:00 - 10:00 AM',
        title: 'Simple extractions',
        subtitle: 'Zendral Dental',
        appointmentId: 'RSV10105',
        isMultiple: true,
        paymentAmount: 240.00,
      ),
      Appointment(
        date: DateTime(2025, 4, 19),
        time: '17:00 - 18:00 PM',
        title: 'Emergency care',
        subtitle: 'Zendral Dental',
        appointmentId: 'RSV10094',
        isPaid: true,
      ),
      Appointment(
        date: DateTime(2025, 4, 15),
        time: '11:00 - 12:00 AM',
        title: 'Speech Therapy',
        subtitle: 'Neuro Center',
        appointmentId: 'RSV10089',
        isMultiple: true,
        isPaid: true,
      ),
    ];
  }
  
  static List<Appointment> getUpcomingAppointments() {
    final now = DateTime.now();
    return getAppointments()
        .where((appointment) => appointment.date.isAfter(now) && !appointment.isPaid)
        .toList();
  }
  
  static List<Appointment> getFinishedAppointments() {
    final now = DateTime.now();
    return getAppointments()
        .where((appointment) => appointment.date.isBefore(now) || appointment.isPaid)
        .toList();
  }
  
  static List<Appointment> getAppointmentsForDate(DateTime date) {
    return getAppointments()
        .where((appointment) => 
            appointment.date.year == date.year && 
            appointment.date.month == date.month && 
            appointment.date.day == date.day)
        .toList();
  }
} 