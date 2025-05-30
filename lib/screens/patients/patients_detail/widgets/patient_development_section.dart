import 'package:flutter/material.dart';
import 'package:neuro_plus/common/config/theme.dart';
import 'package:neuro_plus/common/widgets/custom_card.dart';
import 'package:neuro_plus/models/patient.dart';
import 'package:neuro_plus/screens/patients/patients_detail/widgets/detail_info_row.dart';

class PatientDevelopmentSection extends StatelessWidget {
  final Patient patient;

  const PatientDevelopmentSection({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.child_care,
                  color: AppColors.primarySwatch,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Desenvolvimento',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.gray[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DetailInfoRow(
              label: 'Atraso no desenvolvimento',
              value: patient.developmentalDelay == true ? 'Sim' : 'Não',
              icon: Icons.timeline,
            ),
            if (patient.firstWordAge != null)
              DetailInfoRow(
                label: 'Primeira palavra',
                value: '${patient.firstWordAge} meses',
                icon: Icons.record_voice_over,
              ),
            if (patient.eyeContact?.isNotEmpty == true)
              DetailInfoRow(
                label: 'Contato visual',
                value: patient.eyeContact!,
                icon: Icons.visibility,
              ),
            DetailInfoRow(
              label: 'Comportamentos repetitivos',
              value: patient.repetitiveBehaviors == true ? 'Sim' : 'Não',
              icon: Icons.repeat,
            ),
            if (patient.repetitiveBehaviorsDescription?.isNotEmpty == true)
              DetailInfoRow(
                label: 'Descrição dos comportamentos',
                value: patient.repetitiveBehaviorsDescription!,
                icon: Icons.description,
              ),
            DetailInfoRow(
              label: 'Resistência a mudanças de rotina',
              value: patient.routineResistance == true ? 'Sim' : 'Não',
              icon: Icons.schedule,
            ),
            if (patient.socialInteractionWithChildren?.isNotEmpty == true)
              DetailInfoRow(
                label: 'Interação social com crianças',
                value: patient.socialInteractionWithChildren!,
                icon: Icons.groups,
              ),
            if (patient.sensoryHypersensitivity?.isNotEmpty == true)
              DetailInfoRow(
                label: 'Hipersensibilidade sensorial',
                value: patient.sensoryHypersensitivity!,
                icon: Icons.sensors,
              ),
          ],
        ),
      ),
    );
  }
}
