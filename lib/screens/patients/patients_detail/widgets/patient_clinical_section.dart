import 'package:flutter/material.dart';
import 'package:neuro_plus/common/config/theme.dart';
import 'package:neuro_plus/common/widgets/custom_card.dart';
import 'package:neuro_plus/models/patient.dart';
import 'package:neuro_plus/screens/patients/patients_detail/widgets/detail_info_row.dart';

class PatientClinicalSection extends StatelessWidget {
  final Patient patient;

  const PatientClinicalSection({super.key, required this.patient});

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
                  Icons.medical_services,
                  color: AppColors.primarySwatch,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Informações Clínicas',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.gray[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (patient.referralReason?.isNotEmpty == true)
              DetailInfoRow(
                label: 'Motivo do encaminhamento',
                value: patient.referralReason!,
                icon: Icons.assignment_outlined,
              ),
            if (patient.referredBy?.isNotEmpty == true)
              DetailInfoRow(
                label: 'Encaminhado por',
                value: patient.referredBy!,
                icon: Icons.person_outline,
              ),
            DetailInfoRow(
              label: 'Avaliado anteriormente',
              value: patient.previouslyEvaluated == true ? 'Sim' : 'Não',
              icon: Icons.history,
            ),
            if (patient.previousDiagnosis?.isNotEmpty == true)
              DetailInfoRow(
                label: 'Diagnóstico anterior',
                value: patient.previousDiagnosis!,
                icon: Icons.medical_information_outlined,
              ),
            if (patient.comorbidities.isNotEmpty)
              DetailInfoRow(
                label: 'Comorbidades',
                value: patient.comorbidities.join(', '),
                icon: Icons.health_and_safety_outlined,
              ),
            if (patient.screeningsPerformed.isNotEmpty)
              DetailInfoRow(
                label: 'Triagens realizadas',
                value: patient.screeningsPerformed.join(', '),
                icon: Icons.checklist_outlined,
              ),
          ],
        ),
      ),
    );
  }
}
