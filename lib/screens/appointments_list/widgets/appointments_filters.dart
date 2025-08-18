import 'package:flutter/material.dart';
import 'package:neuro_plus/common/config/theme.dart';
import 'package:neuro_plus/models/appointment.dart';

class AppointmentsFilters extends StatelessWidget {
  final AppointmentStatus? selectedStatus;
  final Function(AppointmentStatus?) onStatusChanged;

  const AppointmentsFilters({
    super.key,
    required this.selectedStatus,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildFilterChip('Todas', null),
          const SizedBox(width: 8),
          _buildFilterChip('Agendadas', AppointmentStatus.scheduled),
          const SizedBox(width: 8),
          _buildFilterChip('Em andamento', AppointmentStatus.inProgress),
          const SizedBox(width: 8),
          _buildFilterChip('Concluídas', AppointmentStatus.completed),
          const SizedBox(width: 8),
          _buildFilterChip('Canceladas', AppointmentStatus.cancelled),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, AppointmentStatus? status) {
    final isSelected = selectedStatus == status;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onStatusChanged(status),
      backgroundColor: Colors.white,
      selectedColor: AppColors.primarySwatch.withValues(alpha: 0.1),
      checkmarkColor: AppColors.primarySwatch,
      labelStyle: TextStyle(
        color: isSelected ? AppColors.primarySwatch : AppColors.gray[600],
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
      side: BorderSide(
        color: isSelected ? AppColors.primarySwatch : AppColors.gray[300]!,
      ),
    );
  }
}
