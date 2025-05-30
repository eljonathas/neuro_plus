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
            DetailInfoRow(
              label: 'Responsável',
              value: patient.guardians,
              icon: Icons.person_outline,
            ),
            DetailInfoRow(
              label: 'Telefone',
              value: patient.contactPhone,
              icon: Icons.phone_outlined,
            ),
            if (patient.contactEmail?.isNotEmpty == true)
              DetailInfoRow(
                label: 'E-mail',
                value: patient.contactEmail!,
                icon: Icons.email_outlined,
              ),
            DetailInfoRow(
              label: 'Endereço',
              value: patient.address,
              icon: Icons.location_on_outlined,
            ),
          ],
        ),
      ),
    );
  }
}
