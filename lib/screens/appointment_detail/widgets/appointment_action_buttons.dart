import 'package:flutter/material.dart';
import 'package:neuro_plus/common/widgets/custom_button.dart';
import 'package:neuro_plus/models/appointment.dart';

class AppointmentActionButtons extends StatelessWidget {
  final Appointment appointment;
  final Function(AppointmentStatus) onStatusUpdate;

  const AppointmentActionButtons({
    super.key,
    required this.appointment,
    required this.onStatusUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          if (appointment.status == AppointmentStatus.scheduled) ...[
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Iniciar consulta',
                    onPressed: () => onStatusUpdate(AppointmentStatus.inProgress),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    text: 'Cancelar',
                    onPressed: () => onStatusUpdate(AppointmentStatus.cancelled),
                    backgroundColor: Colors.red[100],
                    foregroundColor: Colors.red[700],
                  ),
                ),
              ],
            ),
          ] else if (appointment.status == AppointmentStatus.inProgress) ...[
            CustomButton(
              text: 'Concluir consulta',
              onPressed: () => onStatusUpdate(AppointmentStatus.completed),
              width: double.infinity,
            ),
          ],
        ],
      ),
    );
  }
} 