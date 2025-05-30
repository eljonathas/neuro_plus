import 'package:flutter/material.dart';
import 'package:neuro_plus/common/config/theme.dart';
import 'package:neuro_plus/common/widgets/custom_card.dart';
import 'package:neuro_plus/models/appointment.dart';

class AppointmentDetailsTab extends StatelessWidget {
  final Appointment appointment;

  const AppointmentDetailsTab({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAppointmentInfoCard(),

          if (appointment.hasProtocol) ...[
            const SizedBox(height: 16),
            _buildProtocolInfoCard(),
          ],

          if (appointment.notes != null && appointment.notes!.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildNotesCard(),
          ],
        ],
      ),
    );
  }

  Widget _buildAppointmentInfoCard() {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Informações da consulta',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.gray[800],
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Paciente', appointment.patientName),
            _buildDetailRow('Data', appointment.formattedDate),
            _buildDetailRow('Horário', appointment.time),
            _buildDetailRow('Duração', '${appointment.duration} minutos'),
            _buildDetailRow('Tipo', appointment.typeText),
            _buildDetailRow('Status', appointment.statusText),
            if (appointment.location != null)
              _buildDetailRow('Local', appointment.location!),
          ],
        ),
      ),
    );
  }

  Widget _buildProtocolInfoCard() {
    final protocolCount = appointment.protocolIds?.length ?? 0;
    final protocolNames = appointment.protocolNames ?? [];
    final filledCount = appointment.protocolResponses?.length ?? 0;

    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Protocolos',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.gray[800],
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow(
              'Quantidade',
              '$protocolCount protocolo${protocolCount != 1 ? 's' : ''}',
            ),
            if (protocolNames.isNotEmpty)
              _buildDetailRow('Nomes', protocolNames.join(', ')),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.assignment, size: 16, color: AppColors.gray[500]),
                const SizedBox(width: 8),
                Text(
                  filledCount > 0
                      ? '$filledCount de $protocolCount preenchido${filledCount != 1 ? 's' : ''}'
                      : 'Nenhum protocolo preenchido',
                  style: TextStyle(
                    fontSize: 14,
                    color: filledCount > 0 ? Colors.green : AppColors.gray[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesCard() {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Observações',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.gray[800],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                appointment.notes!,
                style: TextStyle(fontSize: 14, color: AppColors.gray[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.gray[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 14, color: AppColors.gray[800]),
            ),
          ),
        ],
      ),
    );
  }
}
