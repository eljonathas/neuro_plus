import 'package:flutter/material.dart';
import 'package:neuro_plus/common/main_layout.dart';
import 'package:neuro_plus/common/services/appointments/appointments_service.dart';
import 'package:neuro_plus/models/appointment.dart';
import 'package:neuro_plus/screens/appointment_detail/widgets/appointment_header.dart';
import 'package:neuro_plus/screens/appointment_detail/widgets/appointment_tabs.dart';
import 'package:neuro_plus/screens/appointment_detail/widgets/appointment_details_tab.dart';
import 'package:neuro_plus/screens/appointment_detail/widgets/soap_notes_tab.dart';
import 'package:neuro_plus/screens/appointment_detail/widgets/protocol_tab.dart';
import 'package:neuro_plus/screens/appointment_detail/widgets/appointment_action_buttons.dart';

class AppointmentDetailScreen extends StatefulWidget {
  final Appointment appointment;

  const AppointmentDetailScreen({super.key, required this.appointment});

  @override
  State<AppointmentDetailScreen> createState() =>
      _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState extends State<AppointmentDetailScreen> {
  int _currentTabIndex = 0;
  late Appointment _currentAppointment;

  @override
  void initState() {
    super.initState();
    _currentAppointment = widget.appointment;
  }

  Future<void> _updateAppointmentStatus(AppointmentStatus newStatus) async {
    try {
      await AppointmentsService.updateAppointmentStatus(
        _currentAppointment.id,
        newStatus,
      );

      if (mounted) {
        setState(() {
          _currentAppointment = _currentAppointment.copyWith(status: newStatus);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao atualizar status: $e')));
      }
    }
  }

  void _onTabChanged(int index) {
    setState(() {
      _currentTabIndex = index;
    });
  }

  Future<void> _reloadAppointment() async {
    try {
      await AppointmentsService.init();
      final updatedAppointment = AppointmentsService.getAppointment(
        _currentAppointment.id,
      );

      if (updatedAppointment != null && mounted) {
        setState(() {
          _currentAppointment = updatedAppointment;
        });
      }
    } catch (e) {
      // Erro ao recarregar consulta - falha silenciosa
    }
  }

  Widget _buildActiveTabContent() {
    if (_currentTabIndex == 0) {
      return AppointmentDetailsTab(appointment: _currentAppointment);
    } else if (_currentTabIndex == 1) {
      return SoapNotesTab(
        appointment: _currentAppointment,
        onNotesUpdated: _reloadAppointment,
      );
    } else if (_currentTabIndex == 2 && _currentAppointment.hasProtocol) {
      return ProtocolTab(
        appointment: _currentAppointment,
        onProtocolUpdated: _reloadAppointment,
      );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title:
          '${_currentAppointment.formattedDate} (${_currentAppointment.time})',
      navIndex: 1,
      isBackButtonVisible: true,
      resizeToAvoidBottomInset: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppointmentHeader(appointment: _currentAppointment),
          AppointmentTabs(
            currentTabIndex: _currentTabIndex,
            hasProtocol: _currentAppointment.hasProtocol,
            onTabChanged: _onTabChanged,
          ),
          const SizedBox(height: 24),
          Expanded(child: _buildActiveTabContent()),
          AppointmentActionButtons(
            appointment: _currentAppointment,
            onStatusUpdate: _updateAppointmentStatus,
          ),
        ],
      ),
    );
  }
}
