import 'package:flutter/material.dart';
import 'package:neuro_plus/core/main_layout.dart';
import 'package:neuro_plus/core/widgets/custom_calendar.dart';
import 'package:neuro_plus/data/appointments_data.dart';
import 'package:neuro_plus/models/appointment.dart';
import 'package:neuro_plus/screens/appointment/appointment_detail_screen.dart';
import 'package:neuro_plus/screens/home/schedule_screen.dart';
import 'package:neuro_plus/screens/home/widgets/appointment_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int navIndex = 0;
  DateTime selectedDate = DateTime.now();
  late List<Appointment> filteredAppointments;

  @override
  void initState() {
    super.initState();
    filteredAppointments = AppointmentsData.getAppointmentsForDate(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: "Home",
      navIndex: navIndex,
      onNavTap: (index) {
        if (index == 2) { // Protocols tab
          Navigator.pushReplacementNamed(context, '/protocols');
        } else {
          setState(() {
            navIndex = index;
          });
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Calendar',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ScheduleScreen()),
                  );
                }, 
                child: const Text('View all')
              ),
            ],
          ),
          const SizedBox(height: 16),
          CustomCalendar(
            selectedDate: selectedDate,
            onDateSelected: (date) {
              setState(() {
                selectedDate = date;
                filteredAppointments = AppointmentsData.getAppointmentsForDate(date);
              });
            },
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Appointments for ${_formatDate(selectedDate)}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              Text(
                '${filteredAppointments.length} found',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          filteredAppointments.isEmpty
              ? _buildEmptyState()
              : Column(
                  children: filteredAppointments
                      .map((appointment) => _buildAppointmentCard(appointment))
                      .toList(),
                ),
        ],
      ),
    );
  }
  
  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No appointments for this date',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select another date or schedule a new appointment',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
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
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${date.day} ${months[date.month - 1]}';
  }
  
  void _navigateToDetail(Appointment appointment) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AppointmentDetailScreen(
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
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${days[date.weekday - 1]}, ${date.day} ${months[date.month - 1]}';
  }
}
