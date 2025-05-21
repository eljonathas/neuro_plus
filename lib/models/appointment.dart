class Appointment {
  final DateTime date;
  final String time;
  final String title;
  final String subtitle;
  final String appointmentId;
  final bool isMultiple;
  final bool isPaid;
  final double? paymentAmount;

  Appointment({
    required this.date,
    required this.time,
    required this.title,
    required this.subtitle,
    required this.appointmentId,
    this.isMultiple = false,
    this.isPaid = false,
    this.paymentAmount,
  });
} 