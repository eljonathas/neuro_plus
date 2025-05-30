import 'package:flutter/material.dart';
import 'package:neuro_plus/common/config/theme.dart';
import 'package:neuro_plus/models/appointment.dart';

class AppointmentHeader extends StatelessWidget {
  final Appointment appointment;

  const AppointmentHeader({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  appointment.patientName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _buildStatusChip(appointment.status),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${appointment.formattedDate} às ${appointment.time}',
                style: TextStyle(fontSize: 14, color: AppColors.gray[600]),
              ),
              Text(
                '${appointment.typeText} • ${appointment.duration} minutos',
                style: TextStyle(fontSize: 14, color: AppColors.gray[500]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(AppointmentStatus status) {
    Color color;
    IconData icon;

    switch (status) {
      case AppointmentStatus.scheduled:
        color = Colors.blue;
        icon = Icons.schedule;
        break;
      case AppointmentStatus.inProgress:
        color = Colors.orange;
        icon = Icons.play_arrow;
        break;
      case AppointmentStatus.completed:
        color = Colors.green;
        icon = Icons.check_circle;
        break;
      case AppointmentStatus.cancelled:
        color = Colors.red;
        icon = Icons.cancel;
        break;
      case AppointmentStatus.noShow:
        color = Colors.grey;
        icon = Icons.person_off;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            appointment.statusText,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
