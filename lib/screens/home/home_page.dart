import 'package:flutter/material.dart';
import 'package:neuro_plus/common/main_layout.dart';
import 'package:neuro_plus/common/widgets/custom_calendar.dart';
import 'package:neuro_plus/data/appointments_data.dart';
import 'package:neuro_plus/models/appointment.dart';
import 'package:neuro_plus/screens/appointment/appointment_detail_screen.dart';
import 'package:neuro_plus/screens/home/schedule_screen.dart';
import 'package:neuro_plus/screens/home/widgets/appointment_card.dart';
import 'package:neuro_plus/screens/home/widgets/appointments_empty_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.now();
  late List<Appointment> filteredAppointments;

  @override
  void initState() {
    super.initState();
    filteredAppointments = AppointmentsData.getAppointmentsForDate(
      selectedDate,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: "Home",
      navIndex: 0,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Calendário',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ScheduleScreen(),
                      ),
                    );
                  },
                  child: const Text('View all'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomCalendar(
              selectedDate: selectedDate,
              onDateSelected: (date) {
                setState(() {
                  selectedDate = date;
                  filteredAppointments =
                      AppointmentsData.getAppointmentsForDate(date);
                });
              },
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Consultas para ${_formatDate(selectedDate)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${filteredAppointments.length} found',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 16),
            filteredAppointments.isEmpty
                ? AppointmentsEmptyState()
                : Column(
                  children:
                      filteredAppointments
                          .map(
                            (appointment) => _buildAppointmentCard(appointment),
                          )
                          .toList(),
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentCard(Appointment appointment) {
    return AppointmentCard(
      date: appointment.date.day.toString(),
      time: appointment.time,
      title: appointment.title,
      subtitle: appointment.subtitle,
      appointmentId: appointment.appointmentId,
      isMultiple: appointment.isMultiple,
      isPaid: appointment.isPaid,
      paymentAmount: appointment.paymentAmount,
      onTap: () => _navigateToDetail(appointment),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Janeiro',
      'Fevereiro',
      'Março',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro',
    ];
    return '${date.day} ${months[date.month - 1]}';
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
