import 'package:flutter/material.dart';
import 'package:neuro_plus/common/config/theme.dart';
import 'package:neuro_plus/common/widgets/custom_card.dart';
import 'package:neuro_plus/models/patient.dart';
import 'package:neuro_plus/screens/patients/patients_detail/widgets/detail_info_row.dart';

class PatientSchoolSection extends StatelessWidget {
  final Patient patient;

  const PatientSchoolSection({super.key, required this.patient});

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
                Icon(Icons.school, color: AppColors.primarySwatch, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Informações Escolares',
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
              label: 'Frequenta escola',
              value: patient.attendsSchool == true ? 'Sim' : 'Não',
              icon: Icons.school_outlined,
            ),
            if (patient.schoolType?.isNotEmpty == true)
              DetailInfoRow(
                label: 'Tipo de escola',
                value: patient.schoolType!,
                icon: Icons.business,
              ),
            if (patient.schoolShift?.isNotEmpty == true)
              DetailInfoRow(
                label: 'Turno',
                value: patient.schoolShift!,
                icon: Icons.access_time,
              ),
            if (patient.hasCompanion?.isNotEmpty == true)
              DetailInfoRow(
                label: 'Possui mediador',
                value: patient.hasCompanion!,
                icon: Icons.support_agent,
              ),
            if (patient.schoolObservations?.isNotEmpty == true)
              DetailInfoRow(
                label: 'Observações escolares',
                value: patient.schoolObservations!,
                icon: Icons.note,
              ),
            if (patient.guardiansObservations?.isNotEmpty == true)
              DetailInfoRow(
                label: 'Observações dos responsáveis',
                value: patient.guardiansObservations!,
                icon: Icons.comment,
              ),
          ],
        ),
      ),
    );
  }
}
