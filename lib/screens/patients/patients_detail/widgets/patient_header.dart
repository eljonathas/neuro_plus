import 'package:flutter/material.dart';
import 'package:neuro_plus/common/config/theme.dart';
import 'package:neuro_plus/common/widgets/custom_card.dart';
import 'package:neuro_plus/models/patient.dart';
import 'package:intl/intl.dart';

class PatientHeader extends StatelessWidget {
  final Patient patient;
  final VoidCallback onEdit;

  const PatientHeader({super.key, required this.patient, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.primarySwatch.withValues(
                    alpha: 0.1,
                  ),
                  child: Icon(
                    Icons.person,
                    size: 32,
                    color: AppColors.primarySwatch,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        patient.fullName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${patient.age} anos • ${patient.gender}',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.gray[600],
                        ),
                      ),
                      Text(
                        'Nascimento: ${DateFormat('dd/MM/yyyy').format(patient.birthDate)}',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.gray[600],
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.primarySwatch.withValues(
                      alpha: 0.1,
                    ),
                    foregroundColor: AppColors.primarySwatch,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.gray[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppColors.gray[600],
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Cadastrado em ${DateFormat('dd/MM/yyyy').format(patient.createdAt)}',
                    style: TextStyle(fontSize: 12, color: AppColors.gray[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
