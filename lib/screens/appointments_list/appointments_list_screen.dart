import 'package:flutter/material.dart';
import 'package:neuro_plus/common/main_layout.dart';
import 'package:neuro_plus/common/services/appointments/appointments_service.dart';
import 'package:neuro_plus/models/appointment.dart';
import 'package:neuro_plus/core/navigation/app_routes.dart';
import 'package:neuro_plus/screens/appointments_list/widgets/appointments_header.dart';
import 'package:neuro_plus/screens/appointments_list/widgets/appointments_filters.dart';
import 'package:neuro_plus/screens/appointments_list/widgets/appointments_search_bar.dart';
import 'package:neuro_plus/screens/appointments_list/widgets/appointment_card.dart';
import 'package:neuro_plus/screens/appointments_list/widgets/appointments_empty_state.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Appointment> _filteredAppointments = [];
  bool _isLoading = true;
  AppointmentStatus? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _loadAppointments();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadAppointments() async {
    setState(() => _isLoading = true);

    try {
      final appointments = AppointmentsService.getAllAppointments();

      if (mounted) {
        setState(() {
          _filteredAppointments = appointments;
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

  void _onSearchChanged() {
    final query = _searchController.text;
    setState(() {
      if (_selectedStatus != null) {
        _filteredAppointments =
            AppointmentsService.getAppointmentsByStatus(_selectedStatus!)
                .where(
                  (appointment) =>
                      appointment.patientName.toLowerCase().contains(
                        query.toLowerCase(),
                      ) ||
                      appointment.typeText.toLowerCase().contains(
                        query.toLowerCase(),
                      ) ||
                      (appointment.protocolNames?.any(
                            (name) => name.toLowerCase().contains(
                              query.toLowerCase(),
                            ),
                          ) ??
                          false),
                )
                .toList();
      } else {
        _filteredAppointments = AppointmentsService.searchAppointments(query);
      }
    });
  }

  void _filterByStatus(AppointmentStatus? status) {
    setState(() {
      _selectedStatus = status;
      if (status != null) {
        _filteredAppointments = AppointmentsService.getAppointmentsByStatus(
          status,
        );
      } else {
        _filteredAppointments = AppointmentsService.getAllAppointments();
      }
    });
    _onSearchChanged(); // Aplicar filtro de busca também
  }

  Future<void> _navigateToCreateAppointment() async {
    final result = await AppRoutes.navigateTo(
      context,
      AppRoutes.appointmentsCreate,
    );

    if (result == true) {
      _loadAppointments();
    }
  }

  Future<void> _navigateToEditAppointment(Appointment appointment) async {
    final result = await AppRoutes.navigateTo(
      context,
      AppRoutes.appointmentsCreate,
      arguments: appointment,
    );

    if (result == true) {
      _loadAppointments();
    }
  }

  Future<void> _navigateToAppointmentDetail(Appointment appointment) async {
    final result = await AppRoutes.navigateTo(
      context,
      AppRoutes.appointmentsDetail,
      arguments: appointment,
    );
    if (result == true) {
      _loadAppointments();
    }
  }

  Future<void> _updateAppointmentStatus(
    Appointment appointment,
    AppointmentStatus newStatus,
  ) async {
    try {
      await AppointmentsService.updateAppointmentStatus(
        appointment.id,
        newStatus,
      );
      _loadAppointments();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Status da consulta atualizado para "${_getStatusText(newStatus)}"',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao atualizar status: $e')));
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

  Future<void> _deleteAppointment(Appointment appointment) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirmar exclusão'),
            content: Text(
              'Tem certeza que deseja excluir a consulta com "${appointment.patientName}"?',
            ),
            actions: [
              TextButton(
                onPressed: () => AppRoutes.goBack(context, false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => AppRoutes.goBack(context, true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Excluir'),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      try {
        await AppointmentsService.deleteAppointment(appointment.id);
        _loadAppointments();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Consulta excluída com sucesso!')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao excluir consulta: $e')),
          );
        }
      }
    }
  }

  void _handleMenuAction(Appointment appointment, String action) async {
    switch (action) {
      case 'edit':
        if (appointment.canEdit) {
          _navigateToEditAppointment(appointment);
        }
        break;
      case 'start':
        _updateAppointmentStatus(appointment, AppointmentStatus.inProgress);
        break;
      case 'complete':
        _updateAppointmentStatus(appointment, AppointmentStatus.completed);
        break;
      case 'cancel':
        _updateAppointmentStatus(appointment, AppointmentStatus.cancelled);
        break;
      case 'delete':
        _deleteAppointment(appointment);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Consultas',
      navIndex: 1,
      child: Column(
        spacing: 8,
        children: [
          AppointmentsHeader(
            stats: AppointmentsService.getAppointmentStats(),
            onAddPressed: _navigateToCreateAppointment,
          ),
          AppointmentsFilters(
            selectedStatus: _selectedStatus,
            onStatusChanged: _filterByStatus,
          ),
          AppointmentsSearchBar(controller: _searchController),
          Expanded(child: _buildAppointmentsList()),
        ],
      ),
    );
  }

  Widget _buildAppointmentsList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_filteredAppointments.isEmpty) {
      return AppointmentsEmptyState(
        hasSearchQuery: _searchController.text.isNotEmpty,
        hasStatusFilter: _selectedStatus != null,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _filteredAppointments.length,
      itemBuilder: (context, index) {
        final appointment = _filteredAppointments[index];
        return AppointmentCard(
          appointment: appointment,
          onTap: () => _navigateToAppointmentDetail(appointment),
          onMenuAction: (action) => _handleMenuAction(appointment, action),
        );
      },
    );
  }
}
