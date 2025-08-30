import 'package:flutter/material.dart';
import 'package:neuro_plus/common/config/theme.dart';
import 'package:neuro_plus/common/widgets/custom_card.dart';
import 'package:neuro_plus/models/patient.dart';
import 'package:neuro_plus/screens/patients/patients_detail/widgets/detail_info_row.dart';

class PatientContactSection extends StatelessWidget {
  final Patient patient;

  const PatientContactSection({super.key, required this.patient});

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
                  Icons.contact_phone,
                  color: AppColors.primarySwatch,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Informações de Contato',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.gray[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Informações gerais de contato
            DetailInfoRow(
              label: 'Telefone Principal',
              value: patient.contactPhone,
              icon: Icons.phone_outlined,
            ),
            if (patient.contactEmail?.isNotEmpty == true)
              DetailInfoRow(
                label: 'E-mail Principal',
                value: patient.contactEmail!,
                icon: Icons.email_outlined,
              ),
            DetailInfoRow(
              label: 'Endereço Principal',
              value: patient.address,
              icon: Icons.location_on_outlined,
            ),

            const SizedBox(height: 24),

            // Seção de responsáveis
            Row(
              children: [
                Icon(
                  Icons.people_outline,
                  color: AppColors.primarySwatch,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  'Responsáveis/Cuidadores',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.gray[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            ...patient.guardians.asMap().entries.map((entry) {
              final index = entry.key;
              final guardian = entry.value;
              return _buildGuardianCard(guardian, index + 1);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildGuardianCard(Guardian guardian, int number) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.gray[200]!),
        borderRadius: BorderRadius.circular(8),
        color: AppColors.gray[50],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Responsável/Cuidador $number',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.primarySwatch,
            ),
          ),
          const SizedBox(height: 8),
          DetailInfoRow(
            label: 'Nome',
            value: guardian.name,
            icon: Icons.person_outline,
          ),
          DetailInfoRow(
            label: 'Telefone',
            value: guardian.phone,
            icon: Icons.phone_outlined,
          ),
          if (guardian.email.isNotEmpty)
            DetailInfoRow(
              label: 'E-mail',
              value: guardian.email,
              icon: Icons.email_outlined,
            ),
          DetailInfoRow(
            label: 'Parentesco',
            value: guardian.relationship,
            icon: Icons.family_restroom_outlined,
          ),
          DetailInfoRow(
            label: 'Endereço',
            value: guardian.address,
            icon: Icons.location_on_outlined,
          ),
        ],
      ),
    );
  }
}
