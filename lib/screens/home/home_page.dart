import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:neuro_plus/common/config/theme.dart';
import 'package:neuro_plus/common/main_layout.dart';
import 'package:neuro_plus/common/widgets/custom_calendar.dart';
import 'package:neuro_plus/common/services/appointments/appointments_service.dart';
import 'package:neuro_plus/models/appointment.dart';
import 'package:neuro_plus/common/widgets/logo.dart';

import 'package:neuro_plus/screens/home/widgets/appointment_card.dart';
import 'package:neuro_plus/core/navigation/app_routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.now();
  List<Appointment> filteredAppointments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    setState(() => _isLoading = true);

    try {
      await AppointmentsService.init();
      final appointments = AppointmentsService.getAppointmentsByDate(
        selectedDate,
      );

      if (mounted) {
        setState(() {
          filteredAppointments = appointments;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar consultas: $e')),
        );
      }
    }
  }

  Future<void> _onDateSelected(DateTime date) async {
    setState(() {
      selectedDate = date;
      _isLoading = true;
    });

    try {
      final appointments = AppointmentsService.getAppointmentsByDate(date);

      if (mounted) {
        setState(() {
          filteredAppointments = appointments;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar consultas: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      hideTitle: true,
      title: "Página Inicial",
      navIndex: 0,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: const NeuralLogoDecoration(
                color: AppColors.primarySwatch,
              ),
              height: 16,
              width: 100,
              margin: const EdgeInsets.only(top: 16),
            ),
            const SizedBox(height: 32),
            const Text(
              'Calendário',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            CustomCalendar(
              selectedDate: selectedDate,
              onDateSelected: _onDateSelected,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Agendamentos',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                TextButton(
                  onPressed: () {
                    AppRoutes.navigateTo(context, AppRoutes.appointmentsList);
                  },
                  child: const Text(
                    'Ver todas',
                    style: TextStyle(color: AppColors.primarySwatch),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildAppointmentsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentsList() {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (filteredAppointments.isEmpty) {
      return Center(
        child: Column(
          children: [
            const SizedBox(height: 32),
            Icon(
              Icons.calendar_today_outlined,
              size: 64,
              color: AppColors.gray[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhuma consulta agendada',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: AppColors.gray[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Não há consultas para ${_formatDate(selectedDate)}',
              style: TextStyle(fontSize: 14, color: AppColors.gray[500]),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                AppRoutes.navigateTo(context, AppRoutes.appointmentsCreate);
              },
              icon: const Icon(Icons.add),
              label: const Text('Agendar consulta'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primarySwatch,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      );
    }

    return Column(
      children:
          filteredAppointments
              .map((appointment) => _buildAppointmentCard(appointment))
              .toList(),
    );
  }

  Widget _buildAppointmentCard(Appointment appointment) {
    return AppointmentCard(
      date: appointment.date.day.toString(),
      time: appointment.time,
      title: appointment.typeText,
      subtitle: appointment.patientName,
      appointmentId: appointment.id.substring(0, 8),
      status: appointment.status,
      onTap: () => _navigateToDetail(appointment),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM').format(date);
  }

  void _navigateToDetail(Appointment appointment) {
    AppRoutes.navigateTo(
      context,
      AppRoutes.appointmentsDetail,
      arguments: appointment,
    );
  }
}
