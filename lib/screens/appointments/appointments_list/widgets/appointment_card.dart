import 'package:flutter/material.dart';
import 'package:neuro_plus/common/config/theme.dart';
import 'package:neuro_plus/common/widgets/custom_card.dart';
import 'package:neuro_plus/models/appointment.dart';

class AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  final VoidCallback onTap;
  final Function(String) onMenuAction;

  const AppointmentCard({
    super.key,
    required this.appointment,
    required this.onTap,
    required this.onMenuAction,
  });

  @override
  Widget build(BuildContext context) {
    final isToday =
        appointment.date.day == DateTime.now().day &&
        appointment.date.month == DateTime.now().month &&
        appointment.date.year == DateTime.now().year;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: CustomCard(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  appointment.patientName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (isToday) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primarySwatch.withValues(
                                      alpha: 0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'HOJE',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primarySwatch,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${appointment.formattedDate} às ${appointment.time}',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.gray[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildStatusChip(appointment.status),
                    _buildPopupMenu(),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.medical_services,
                      size: 16,
                      color: AppColors.gray[500],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      appointment.typeText,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.gray[600],
                      ),
                    ),
                    if (appointment.hasProtocol) ...[
                      const SizedBox(width: 16),
                      Icon(
                        Icons.assignment,
                        size: 16,
                        color: AppColors.gray[500],
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          appointment.protocolNames?.join(', ') ?? '',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.gray[600],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
                if (appointment.notes != null &&
                    appointment.notes!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    appointment.notes!,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.gray[500],
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ),
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            appointment.statusText,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopupMenu() {
    return PopupMenuButton<String>(
      onSelected: onMenuAction,
      itemBuilder:
          (context) => [
            if (appointment.canEdit)
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit, size: 18),
                    SizedBox(width: 8),
                    Text('Editar'),
                  ],
                ),
              ),
            if (appointment.status == AppointmentStatus.scheduled)
              const PopupMenuItem(
                value: 'start',
                child: Row(
                  children: [
                    Icon(Icons.play_arrow, size: 18),
                    SizedBox(width: 8),
                    Text('Iniciar'),
                  ],
                ),
              ),
            if (appointment.status == AppointmentStatus.inProgress)
              const PopupMenuItem(
                value: 'complete',
                child: Row(
                  children: [
                    Icon(Icons.check, size: 18),
                    SizedBox(width: 8),
                    Text('Concluir'),
                  ],
                ),
              ),
            if (appointment.status == AppointmentStatus.scheduled)
              const PopupMenuItem(
                value: 'cancel',
                child: Row(
                  children: [
                    Icon(Icons.cancel, size: 18),
                    SizedBox(width: 8),
                    Text('Cancelar'),
                  ],
                ),
              ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 18, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Excluir', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
    );
  }
}
