import 'package:flutter/material.dart';
import 'package:neuro_plus/common/main_layout.dart';
import 'package:neuro_plus/common/services/appointments/appointments_service.dart';
import 'package:neuro_plus/common/services/protocols/protocol_service.dart';
import 'package:neuro_plus/models/appointment.dart';
import 'package:neuro_plus/models/protocol.dart';
import 'package:neuro_plus/screens/appointments/appointment_detail/widgets/appointment_header.dart';
import 'package:neuro_plus/screens/appointments/appointment_detail/widgets/appointment_tabs.dart';
import 'package:neuro_plus/screens/appointments/appointment_detail/widgets/appointment_details_tab.dart';
import 'package:neuro_plus/screens/appointments/appointment_detail/widgets/protocol_tab.dart';
import 'package:neuro_plus/screens/appointments/appointment_detail/widgets/appointment_action_buttons.dart';

class AppointmentDetailScreen extends StatefulWidget {
  final Appointment appointment;

  const AppointmentDetailScreen({
    super.key,
    required this.appointment,
  });

  @override
  State<AppointmentDetailScreen> createState() => _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState extends State<AppointmentDetailScreen> {
  int _currentTabIndex = 0;
  Protocol? _protocol;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProtocol();
  }

  Future<void> _loadProtocol() async {
    if (widget.appointment.protocolId != null) {
      setState(() => _isLoading = true);
      
      try {
        await ProtocolsService.init();
        final protocol = ProtocolsService.getProtocolById(widget.appointment.protocolId!);
        
        if (mounted) {
          setState(() {
            _protocol = protocol;
            _isLoading = false;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao carregar protocolo: $e')),
          );
        }
      }
    }
  }

  Future<void> _updateAppointmentStatus(AppointmentStatus newStatus) async {
    try {
      await AppointmentsService.updateAppointmentStatus(widget.appointment.id, newStatus);
      
      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Status atualizado para "${_getStatusText(newStatus)}"')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao atualizar status: $e')),
        );
      }
    }
  }

  String _getStatusText(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.scheduled:
        return 'Agendada';
      case AppointmentStatus.inProgress:
        return 'Em andamento';
      case AppointmentStatus.completed:
        return 'Concluída';
      case AppointmentStatus.cancelled:
        return 'Cancelada';
      case AppointmentStatus.noShow:
        return 'Faltou';
    }
  }

  void _onTabChanged(int index) {
    setState(() {
      _currentTabIndex = index;
    });
  }

  Widget _buildActiveTabContent() {
    if (_currentTabIndex == 0) {
      return AppointmentDetailsTab(
        appointment: widget.appointment,
        protocol: _protocol,
      );
    } else if (_currentTabIndex == 1 && widget.appointment.hasProtocol) {
      return ProtocolTab(
        appointment: widget.appointment,
        protocol: _protocol,
        isLoading: _isLoading,
      );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: '${widget.appointment.formattedDate} (${widget.appointment.time})',
      navIndex: 1,
      isBackButtonVisible: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppointmentHeader(appointment: widget.appointment),
          const SizedBox(height: 24),
          AppointmentTabs(
            currentTabIndex: _currentTabIndex,
            hasProtocol: widget.appointment.hasProtocol,
            onTabChanged: _onTabChanged,
          ),
          const SizedBox(height: 24),
          Expanded(child: _buildActiveTabContent()),
          AppointmentActionButtons(
            appointment: widget.appointment,
            onStatusUpdate: _updateAppointmentStatus,
          ),
        ],
      ),
    );
  }
} 