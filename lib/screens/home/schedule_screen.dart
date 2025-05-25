import 'package:flutter/material.dart';
import 'package:neuro_plus/common/main_layout.dart';
import 'package:neuro_plus/data/appointments_data.dart';
import 'package:neuro_plus/models/appointment.dart';
import 'package:neuro_plus/screens/appointment/appointment_detail_screen.dart';
import 'package:neuro_plus/screens/home/widgets/appointment_card.dart';
import 'package:neuro_plus/screens/home/widgets/schedule_section.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  late List<Appointment> upcomingAppointments;
  late List<Appointment> finishedAppointments;

  @override
  void initState() {
    super.initState();
    upcomingAppointments = AppointmentsData.getUpcomingAppointments();
    finishedAppointments = AppointmentsData.getFinishedAppointments();
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: "Schedule",
      navIndex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          ScheduleSection(
            title: 'Upcoming',
            count: upcomingAppointments.length,
            children: [
              const SizedBox(height: 16),
              ...upcomingAppointments.map(
                (appointment) => AppointmentCard(
                  date: appointment.date.day.toString(),
                  time: appointment.time,
                  title: appointment.title,
                  subtitle: appointment.subtitle,
                  appointmentId: appointment.appointmentId,
                  isMultiple: appointment.isMultiple,
                  isPaid: appointment.isPaid,
                  paymentAmount: appointment.paymentAmount,
                  onTap: () => _navigateToDetail(appointment),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ScheduleSection(
            title: 'Finished',
            count: finishedAppointments.length,
            children: [
              const SizedBox(height: 16),
              ...finishedAppointments.map(
                (appointment) => AppointmentCard(
                  date: appointment.date.day.toString(),
                  time: appointment.time,
                  title: appointment.title,
                  subtitle: appointment.subtitle,
                  appointmentId: appointment.appointmentId,
                  isMultiple: appointment.isMultiple,
                  isPaid: appointment.isPaid,
                  paymentAmount: appointment.paymentAmount,
                  onTap: () => _navigateToDetail(appointment),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _navigateToDetail(Appointment appointment) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => AppointmentDetailScreen(
              date: _formatFullDate(appointment.date),
              time: appointment.time,
              appointmentId: appointment.appointmentId,
              clinicName: appointment.subtitle,
              address: '1400 Parkview Avenue',
              city: 'Manhattan Beach',
              state: 'CA',
              zipCode: '90266',
              treatment: appointment.title,
              treatmentDetail: 'Visit #2 - ${appointment.title} (Q1+Q2)',
              rating: 4.5,
              reviewCount: 120,
              distance: 1.2,
              isMultiple: appointment.isMultiple,
              duration: 1,
            ),
      ),
    );
  }

  String _formatFullDate(DateTime date) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${days[date.weekday - 1]}, ${date.day} ${months[date.month - 1]}';
  }
}
