import 'package:flutter/material.dart';
import 'package:neuro_plus/common/config/theme.dart';
import 'package:neuro_plus/models/appointment.dart';
import 'package:neuro_plus/models/protocol.dart';

class AppointmentDetailsTab extends StatelessWidget {
  final Appointment appointment;
  final Protocol? protocol;

  const AppointmentDetailsTab({
    super.key,
    required this.appointment,
    this.protocol,
  });

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
    return Card(
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Protocolo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.gray[800],
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Nome', appointment.protocolName!),
            if (protocol != null && protocol!.description != null)
              _buildDetailRow('Descrição', protocol!.description!),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.assignment, size: 16, color: AppColors.gray[500]),
                const SizedBox(width: 8),
                Text(
                  appointment.protocolResponses != null
                      ? 'Protocolo preenchido'
                      : 'Protocolo não preenchido',
                  style: TextStyle(
                    fontSize: 14,
                    color: appointment.protocolResponses != null
                        ? Colors.green
                        : AppColors.gray[600],
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
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
              style: TextStyle(
                fontSize: 14,
                color: AppColors.gray[600],
              ),
            ),
          ],
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
              style: TextStyle(
                fontSize: 14,
                color: AppColors.gray[800],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 