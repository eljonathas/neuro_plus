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

          if (appointment.hasSoapNotes) ...[
            const SizedBox(height: 16),
            _buildSoapNotesCard(),
          ],

          if (appointment.readableNotes != null &&
              appointment.readableNotes!.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildObservationsCard(),
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

  Widget _buildSoapNotesCard() {
    final hasSubjective = appointment.soapSubjective?.trim().isNotEmpty == true;
    final hasObjective = appointment.soapObjective?.trim().isNotEmpty == true;
    final hasAssessment = appointment.soapAssessment?.trim().isNotEmpty == true;
    final hasPlan = appointment.soapPlan?.trim().isNotEmpty == true;

    final filledSections =
        [
          hasSubjective,
          hasObjective,
          hasAssessment,
          hasPlan,
        ].where((filled) => filled).length;

    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.medical_services_outlined,
                  size: 20,
                  color: AppColors.gray[600],
                ),
                const SizedBox(width: 8),
                Text(
                  'Notas SOAP',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.gray[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildDetailRow('Seções Preenchidas', '$filledSections de 4'),
            if (hasSubjective)
              _buildSoapSection('Subjetivo (S)', appointment.soapSubjective!),
            if (hasObjective)
              _buildSoapSection('Objetivo (O)', appointment.soapObjective!),
            if (hasAssessment)
              _buildSoapSection('Avaliação (A)', appointment.soapAssessment!),
            if (hasPlan) _buildSoapSection('Plano (P)', appointment.soapPlan!),
          ],
        ),
      ),
    );
  }

  Widget _buildSoapSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.gray[700],
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.gray[50],
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.gray[200]!),
            ),
            child: Text(
              content.trim(),
              style: TextStyle(
                fontSize: 13,
                color: AppColors.gray[700],
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildObservationsCard() {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.note_outlined,
                    size: 20,
                    color: AppColors.gray[600],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Observações',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.gray[800],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.gray[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.gray[200]!),
                ),
                child: Text(
                  appointment.readableNotes!,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.gray[700],
                    height: 1.4,
                  ),
                ),
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
        spacing: 4,
        children: [
          Text(
            '$label:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.gray[600],
            ),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 14, color: AppColors.gray[800]),
          ),
        ],
      ),
    );
  }
}
